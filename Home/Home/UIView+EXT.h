//
//  UIView+EXT.h
//  StrawberrySend
//
//  Created by cnsyl066 on 15/8/6.
//  Copyright (c) 2015年 佐筱猪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EXT)
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@end
