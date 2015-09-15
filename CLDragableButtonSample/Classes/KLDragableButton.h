//
//  KLDragableButton.h
//  eBookReader
//
//  Created by Leo Chang on 4/21/15.
//  Copyright (c) 2015 Spring House Entertainment Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@protocol KLDraggableButtonDelegate;
@interface KLDragableButton : UIButton <UIGestureRecognizerDelegate>
{
    BOOL drabable;
    CGFloat firstX;
    CGFloat firstY;
}

@property (nonatomic, weak) id <KLDraggableButtonDelegate> delegate;

- (instancetype)init;

- (void)show;
- (void)dismiss;

@end

@protocol KLDraggableButtonDelegate <NSObject>

- (void)didEndedDragging;

@end