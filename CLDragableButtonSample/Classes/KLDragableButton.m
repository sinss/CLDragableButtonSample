//
//  KLDragableButton.m
//  eBookReader
//
//  Created by Leo Chang on 4/21/15.
//  Copyright (c) 2015 Spring House Entertainment Tech. All rights reserved.
//

#import "KLDragableButton.h"

const static CGFloat animationDuration = 0.2;

@implementation KLDragableButton

//init from iboutlet
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self bindingGesture];
    }
    return self;
}

/*
 initialize from code
 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self bindingGesture];
    }
    return self;
}

- (void)show
{
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.alpha = 1;
    } completion:^(BOOL finish){
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:animationDuration animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finish){
        
    }];
}

- (void)dealloc
{
    _delegate = nil;
}

- (void)bindingGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longTap.delegate = self;
    
    [self addGestureRecognizer:longTap];
    [self addGestureRecognizer:panGesture];
    
    self.multipleTouchEnabled = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    [self bringSubviewToFront:[gesture view]];
    CGPoint translatedPoint = [gesture translationInView:self];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        firstX = [self center].x;
        firstY = [self center].y;
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    
    [self setCenter:translatedPoint];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
//        CGFloat velocityX = (0.2*[gesture velocityInView:self].x);
//        CGFloat velocityY = (0.2*[gesture velocityInView:self].y);
//        
//        CGFloat finalX = translatedPoint.x + velocityX;
//        CGFloat finalY = translatedPoint.y + velocityY;;
//        
//        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
//            if (finalX < 0) {
//                //finalX = 0;
//            } else if (finalX > 768) {
//                //finalX = 768;
//            }
//            
//            if (finalY < 0) {
//                finalY = 0;
//            } else if (finalY > 1024) {
//                finalY = 1024;
//            }
//        } else {
//            if (finalX < 0) {
//                //finalX = 0;
//            } else if (finalX > 1024) {
//                //finalX = 768;
//            }
//            
//            if (finalY < 0) {
//                finalY = 0;
//            } else if (finalY > 768) {
//                finalY = 1024;
//            }
//        }
//        
//        CGFloat animationDuration = (ABS(velocityX)*.0002)+.1;
//        
//        NSLog(@"the duration is: %f", animationDuration);
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:animationDuration];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
//        [self setCenter:CGPointMake(finalX, finalY)];
//        [UIView commitAnimations];
        
        if ([self.delegate respondsToSelector:@selector(didEndedDragging)])
        {
            [self.delegate didEndedDragging];
        }
    }
}

- (void)animationDidFinish
{
    
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)gesture
{
    /*
     UIGestureRecognizerStatePossible,   // the recognizer has not yet recognized its gesture, but may be evaluating touch events. this is the default state
     
     UIGestureRecognizerStateBegan,      // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
     UIGestureRecognizerStateChanged,    // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
     UIGestureRecognizerStateEnded,      // the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
     UIGestureRecognizerStateCancelled,  // the recognizer has received touches resulting in the cancellation of the gesture. the action method will be called at the next turn of the run loop. the recognizer will be reset to UIGestureRecognizerStatePossible
     
     UIGestureRecognizerStateFailed,     // the recognizer has received a touch sequence that can not be recognized as the gesture. the action method will not be called and the recognizer will be reset to UIGestureRecognizerStatePossible
     
     // Discrete Gestures – gesture recognizers that recognize a discrete event but do not report changes (for example, a tap) do not transition through the Began and Changed states and can not fail or be cancelled
     UIGestureRecognizerStateRecognize
     */
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        drabable = YES;
        
        [self startShaking];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        drabable = NO;
        [self stopShaking];
    }
}

#pragma mark - UIGestureReconizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        return YES;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)startShaking
{
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-5.0));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(5.0));
    
    self.transform = leftWobble;  // starting point
    
    [UIView beginAnimations:@"wobble" context:(__bridge void *)(self)];
    [UIView setAnimationRepeatAutoreverses:YES]; // important
    [UIView setAnimationRepeatCount:NSIntegerMax];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(wobbleEnded:finished:context:)];
    
    self.transform = rightWobble; // end here & auto-reverse
    
    [UIView commitAnimations];
}

- (void)stopShaking
{
    [self.layer removeAllAnimations];
    CGAffineTransform original = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0.0));
    self.transform = original;  // starting point
}

@end
