//
//  UpCalculationState.m
//  PullableView
//
//  Created by Ahmed Henawey on 20/12/2014.
//  Copyright (c) 2014 Ahmed Henawey. All rights reserved.
//

#import "UpCalculationState.h"

@implementation UpCalculationState{
    UIView *_view;
    CGPoint _startPosition;
    CGPoint _minPointToView;
    CGPoint _maxPointToView;
}

- (id)initWithView:(UIView*)view andMinPointToView:(CGPoint) minPointToView andMaxPointToView:(CGPoint) maxPointToView{
    self = [super init];
    if (self) {
        _view=view;
        _startPosition=_view.frame.origin;
        _minPointToView=minPointToView;
        _maxPointToView=maxPointToView;
    }
    return self;
}

- (CGPoint)calculateOriginToShowPoint:(CGPoint)point{
    //1-calculate how much in view shown
    //2-substract the shown from view height from desied point
    //3-add the result to y

    CGFloat shownHeightFromView= _view.superview.frame.size.height-_view.frame.origin.y;

    CGFloat neededToShift=point.y-shownHeightFromView;

    CGPoint calculatedOrigin=CGPointMake(0, _view.frame.origin.y - neededToShift);

    return calculatedOrigin;
}

- (CGPoint)calculateNewOrigin:(CGPoint)translate{

    CGPoint newPos= CGPointMake(_startPosition.x, _startPosition.y + translate.y);

    if (_view.superview.frame.size.height > (newPos.y + _maxPointToView.y)) {
        newPos.y = _view.frame.origin.y;
    }
    return newPos;

}

@end
