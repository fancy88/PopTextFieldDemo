//
//  PopShadowView.m
//  VTPopView
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "PopShadowView.h"

@interface PopShadowView ()
@property (nonatomic, assign) NSInteger      type;
@end

@implementation PopShadowView

- (instancetype)initWithType:(NSInteger )type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //获取图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_type == 0) {
        //渐变
        CGContextSaveGState(context);
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }else{
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    }

    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
