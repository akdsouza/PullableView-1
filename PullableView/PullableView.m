
#import "PullableView.h"
#import "UpCalculationState.h"

/**
 @author Fabio Rodella fabio@crocodella.com.br
 */
typedef enum{
    UP=1,
    DOWN,
    LEFT,
    RIGHT
} Direction;

@implementation PullableView{
    Direction direction;
}

@synthesize headerView;
@synthesize minVisiblePoint;
@synthesize maxVisiblePoint;
@synthesize dragRecognizer;
@synthesize tapRecognizer;
@synthesize animate;
@synthesize animationDuration;
@synthesize delegate;
@synthesize opened;


- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self postInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self postInit];
    }
    return self;
}

- (void)postInit{

    animate = YES;
    animationDuration = 0.2;

    toggleOnTap = YES;

    [self setOpened:NO animated:NO];
}

- (void)setHeaderView:(UIView *)_headerView{

    // set the header view. Subclasses should resize, reposition and style this view

    headerView=_headerView;

    dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDrag:)];
    dragRecognizer.minimumNumberOfTouches = 1;
    dragRecognizer.maximumNumberOfTouches = 1;

    [headerView addGestureRecognizer:dragRecognizer];

    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;

    [headerView addGestureRecognizer:tapRecognizer];
}

- (void)handleDrag:(UIPanGestureRecognizer *)sender {
    
    if ([sender state] == UIGestureRecognizerStateBegan) {

        //Determines if the view can be pulled in the x or y axis
        verticalAxis = minVisiblePoint.x == maxVisiblePoint.x;

        [self detectDirection];

    } else if ([sender state] == UIGestureRecognizerStateChanged) {
                
        CGPoint translate = [sender translationInView:self.superview];

        CGPoint newPos=[calculationState calculateNewOrigin:translate];

        [sender setTranslation:translate inView:self.superview];

        [self setOrigin:newPos];

    } else if ([sender state] == UIGestureRecognizerStateEnded) {
        
        // Gets the velocity of the gesture in the axis, so it can be
        // determined to which endpoint the state should be set.
        
        CGPoint vectorVelocity = [sender velocityInView:self.superview];
        CGFloat axisVelocity = verticalAxis ? vectorVelocity.y : vectorVelocity.x;

        BOOL op;

        if (direction==UP) {
             CGPoint target = axisVelocity > 0 ? self.minVisiblePoint : self.maxVisiblePoint;
             op = CGPointEqualToPoint(target, self.maxVisiblePoint);
        }

        [self setOpened:op animated:animate];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {

    if ([sender state] == UIGestureRecognizerStateEnded) {
        [self detectDirection];
        [self setOpened:!opened animated:animate];
    }
}

- (void)setToggleOnTap:(BOOL)tap {
    toggleOnTap = tap;
    tapRecognizer.enabled = tap;
}

- (BOOL)toggleOnTap {
    return toggleOnTap;
}

- (void)setOpened:(BOOL)op animated:(BOOL)anim {
    opened = op;
    
    if (anim) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    }

    CGPoint selectedVisiblePoint=opened ? self.maxVisiblePoint : self.minVisiblePoint;

    [self setOrigin:[calculationState calculateOriginToShowPoint:selectedVisiblePoint]];

    if (anim) {
        
        // For the duration of the animation, no further interaction with the view is permitted
        dragRecognizer.enabled = NO;
        tapRecognizer.enabled = NO;
        
        [UIView commitAnimations];
        
    } else {
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}

- (void)setOrigin:(CGPoint)origin{
    CGRect viewFrame = self.frame;
    viewFrame.origin=origin;
    self.frame=viewFrame;
}

- (void)detectDirection{

    CGRect superFrame=self.superview.frame;
    CGRect selfFrames=self.frame;

    if (selfFrames.origin.y<superFrame.size.height) {
        direction=UP;
        calculationState=[[UpCalculationState alloc]initWithView:self andMinPointToView:self.minVisiblePoint andMaxPointToView:self.maxVisiblePoint];
    } else if(selfFrames.origin.x<superFrame.size.width){
        direction=LEFT;
    }else if (selfFrames.origin.y + selfFrames.size.height > superFrame.origin.y) {
        direction=DOWN;
    } else if(selfFrames.origin.x + selfFrames.size.width > superFrame.origin.x){
        direction=RIGHT;
    }

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if (finished) {
        // Restores interaction after the animation is over
        dragRecognizer.enabled = YES;
        tapRecognizer.enabled = toggleOnTap;
        
        if ([delegate respondsToSelector:@selector(pullableView:didChangeState:)]) {
            [delegate pullableView:self didChangeState:opened];
        }
    }
}

@end
