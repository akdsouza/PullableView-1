//
//  CalculationState.h
//  PullableView
//
//  Created by Ahmed Henawey on 20/12/2014.
//  Copyright (c) 2014 Ahmed Henawey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CalculationState <NSObject>

- (id)initWithView:(UIView*)view andMinPointToView:(CGPoint) minPointToView andMaxPointToView:(CGPoint) maxPointToView;

- (CGPoint)calculateOriginToShowPoint:(CGPoint)point;

- (CGPoint)calculateNewOrigin:(CGPoint)translate;

@end
