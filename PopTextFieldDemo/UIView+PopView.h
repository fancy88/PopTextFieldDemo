//
//  UIView+PopView.h
//  VTPopView
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VTPopViewController;
@class PopView;
@class PopShadowView;

typedef NS_ENUM(NSInteger , PresentType) {
    PresentTypeCustom             = 1000, //自定义
    PresentViewTypeUp,                    //从上部进来
    PresentViewTypeBottom,                //从下部进来
    PresentViewTypeBlowup,                //放大
    PresentViewTypeGradual                //渐变
};

@interface UIView (PopView)
@property (nonatomic, strong) PopShadowView           *vt_shadowView;
@property (nonatomic, strong) UIColor                 *popBackgroudColor;//弹出视图的背景色
@property (nonatomic, assign) PresentType              popType;
@property (nonatomic, assign) CGRect                   formerRect;
- (void)presentPopViewType:(PresentType)type animation:(void(^)())animation;

- (void)dismissPopViewAnimation:(BOOL)animation completion:(void(^)())completion;
@end
