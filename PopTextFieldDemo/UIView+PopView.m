//
//  UIView+PopView.m
//  VTPopView
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "UIView+PopView.h"
#import <objc/runtime.h>
#import "PopShadowView.h"
static char  vt_shadowViewKey;
static char  vt_popBackgroudColorKey;
static char  vt_popTypeKey;
static char  vt_formerRectKey;
static NSTimeInterval const kFadeInAnimationDuration = 0.25;
static NSInteger      const shadowViewTag = 890990988999;
static NSInteger      const popViewTag = 8909909882999;

@implementation UIView (PopView)

- (void)presentPopViewType:(PresentType)type animation:(void(^)())animation{
    self.popType = type;
    self.formerRect = self.frame;
    [self vt_layoutBackgroundView];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vt_shadowView.alpha = 0;
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            self.vt_shadowView.alpha = 0.3;
        }];
        
        switch (type) {
            case PresentTypeCustom:
            {
                if (animation) {
                    [UIView animateWithDuration:kFadeInAnimationDuration animations:animation];
                }
            }
                break;
            case PresentViewTypeUp:
            {
                self.frame = CGRectMake(self.formerRect.origin.x, -self.formerRect.size.height, self.formerRect.size.width, self.formerRect.size.height);
                [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                    self.frame = self.formerRect;
                }];
            }
                break;
            case PresentViewTypeBottom:
            {
                self.frame = CGRectMake(self.formerRect.origin.x, [UIScreen mainScreen].bounds.size.height, self.formerRect.size.width, self.formerRect.size.height);
                [UIView animateWithDuration:kFadeInAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.frame = self.formerRect;
                } completion:^(BOOL finished) {
                    
                }];

            }
                break;
            case PresentViewTypeBlowup:
            {
                self.frame = CGRectMake(self.formerRect.origin.x, self.formerRect.origin.y, self.formerRect.size.width, 0);
                [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                    self.frame = self.formerRect;
                }];
            }
                break;
            case PresentViewTypeGradual:
            {
                self.alpha = 0;
                self.frame = self.formerRect;
                [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                    self.alpha = 1;
                }];
            }
                break;
            default:
                break;
        }
    });
}

- (void)vt_layoutBackgroundView{
    UIWindow * keywindow = [UIApplication sharedApplication].keyWindow;
    for (int i = 0; i < keywindow.subviews.count; i ++) {
        UIView * subview = keywindow.subviews[i];
        if (subview.tag == popViewTag ||subview.tag == shadowViewTag) {
            [subview removeFromSuperview];
            i -- ;
        }
    }
    self.clipsToBounds = YES;
    self.frame = CGRectZero;
    self.vt_shadowView = [[PopShadowView alloc] initWithType:1];
    self.vt_shadowView.frame = keywindow.bounds;
    [keywindow addSubview:self.vt_shadowView];
    [keywindow addSubview:self];
    self.vt_shadowView.tag = shadowViewTag;
    self.vt_shadowView.alpha = 0;
    self.tag = popViewTag;
    __weak typeof(self) weakSelf = self;
    self.vt_shadowView.tapBlock = ^{
        if (weakSelf) {
            [weakSelf dismissPopViewAnimation:YES completion:nil];
        }
    };
}


- (void)dismissPopViewAnimation:(BOOL)animation completion:(void(^)())completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(animation){
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                self.vt_shadowView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.vt_shadowView removeFromSuperview];
                if (completion) {
                    completion();
                }
                self.frame = self.formerRect;
            }];
            switch (self.popType) {
                case PresentViewTypeUp:
                {
                    [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                        self.frame = CGRectMake(self.frame.origin.x, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                        
                    }];
                }
                    break;
                case PresentViewTypeBottom:
                {
                    [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                        self.frame = CGRectMake(self.frame.origin.x, [UIScreen mainScreen].bounds.size.height, self.frame.size.width, self.frame.size.height);
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                    }];
                    
                }
                    break;
                case PresentViewTypeBlowup:
                {
                    [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0);
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                    }];
                }
                    break;
                case PresentViewTypeGradual | PresentTypeCustom:
                {
                    [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                        self.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self removeFromSuperview];
                    }];
                }
                    break;
                default:
                    self.vt_shadowView.alpha = 0;
                    self.alpha = 0;
                    [self removeFromSuperview];
                    [self.vt_shadowView removeFromSuperview];
                    break;
            }
        }else{
            self.vt_shadowView.alpha = 0;
            self.alpha = 0;
            [self removeFromSuperview];
            [self.vt_shadowView removeFromSuperview];
            if (completion) {
                completion();
            }
        }
    });
}

#pragma mark atrribute

- (void)setVt_shadowView:(PopShadowView *)vt_shadowView{
    objc_setAssociatedObject(self, &vt_shadowViewKey, vt_shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (PopShadowView*)vt_shadowView{
    return objc_getAssociatedObject(self, &vt_shadowViewKey);
}
- (void)setPopBackgroudColor:(UIColor *)popBackgroudColor{
    objc_setAssociatedObject(self, &vt_popBackgroudColorKey, popBackgroudColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)popBackgroudColor{
    return objc_getAssociatedObject(self, &vt_popBackgroudColorKey);
}
- (void)setPopType:(PresentType)popType{
    objc_setAssociatedObject(self, &vt_popTypeKey, [NSString stringWithFormat:@"%ld",(long)popType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (PresentType )popType{
    return [objc_getAssociatedObject(self, &vt_popTypeKey) integerValue];
}
- (void)setFormerRect:(CGRect)formerRect{
    NSString * rectString = [NSString stringWithFormat:@"%f|%f|%f|%f",formerRect.origin.x,formerRect.origin.y,formerRect.size.width,formerRect.size.height];
    objc_setAssociatedObject(self, &vt_formerRectKey, rectString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGRect )formerRect{
    NSString * rectString = objc_getAssociatedObject(self, &vt_formerRectKey);
    if (rectString) {
        NSArray * rectArray = [rectString componentsSeparatedByString:@"|"];
        if (rectArray.count == 4) {
            return CGRectMake([rectArray[0] floatValue], [rectArray[1] floatValue], [rectArray[2] floatValue], [rectArray[3] floatValue]);
        }
    }
    return CGRectZero;
}
@end
