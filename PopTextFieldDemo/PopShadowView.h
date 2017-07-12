//
//  PopShadowView.h
//  VTPopView
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TapBlock)();

@interface PopShadowView : UIView

@property (nonatomic, copy) TapBlock      tapBlock;
- (instancetype)initWithType:(NSInteger )type;

@end
