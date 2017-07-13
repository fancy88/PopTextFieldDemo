//
//  GatewayLoginView.h
//  PopTextFieldDemo
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GatewayLoginViewDelegate <NSObject>

- (void)loginGatewayWithAccount: (NSString *)account Password: (NSString *)password;

@end

@interface GatewayLoginView : UIView

- (void)presentToVisible;
- (void)dismissToInvisible;

@property(nonatomic, weak) id<GatewayLoginViewDelegate> delegate;

@end
