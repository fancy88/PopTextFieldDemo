//
//  GatewayLoginView.m
//  PopTextFieldDemo
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "GatewayLoginView.h"
#import "UIView+PopView.h"

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//屏幕 宽高
#define kScreenHight (MAX([[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width))

#define INTERVAL_KEYBOARD 10
// 自定义的缓冲距离INTERVAL_KEYBOARD

@interface GatewayLoginView()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UITextField *passWordTF;

@end

@implementation GatewayLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 55)];
        titleLabel.text = @"请输入网账号及密码";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15.0f];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height, frame.size.width, 1)];
        [titleLabel addSubview:lineLabel];
        lineLabel.backgroundColor = RGB(242, 242, 242);
        [self addSubview:titleLabel];
        
        self.accountTF = [self getTextFieldY:CGRectGetMaxY(titleLabel.frame) + 10 leftText:@"账 号:" placeholder:@"请输入账号"];
        self.passWordTF = [self getTextFieldY:CGRectGetMaxY(self.accountTF.frame) + 20 leftText:@"密 码:" placeholder:@"请输入密码"];
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passWordTF.frame) + 20, self.frame.size.width / 2, 30)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismissToInvisible) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        UILabel *divisionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, CGRectGetMaxY(self.passWordTF.frame) + 10, 1, 45)];
        divisionLabel.backgroundColor = RGB(242, 242, 242);
        [self addSubview:divisionLabel];
        
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, CGRectGetMaxY(self.passWordTF.frame) + 20, self.frame.size.width / 2, 30)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureButtonclick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        
        [self addNoticeForKeyboard];
    }
    return self;
}

- (UITextField *)getTextFieldY: (NSInteger)originY leftText: (NSString *)text placeholder: (NSString *)placeholder{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, originY, self.frame.size.width - 5, 30)];
    textField.placeholder = placeholder;
    textField.delegate = self;
    [textField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 90, 30)];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    textField.leftView     = label;
    textField.leftViewMode = UITextFieldViewModeAlways;
    [self addSubview: textField];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textField.frame) + 9, self.frame.size.width, 1)];
    lineLabel.backgroundColor = RGB(242, 242, 242);
    [self addSubview:lineLabel];
    
    return textField;
}

#pragma mark - public method

- (void)presentToVisible{
    
    [self presentPopViewType:PresentViewTypeGradual animation:nil];
    
}

- (void)dismissToInvisible{
    
    [self dismissPopViewAnimation:YES completion:^{
        
    }];
    
}

#pragma mark - Other Action
- (void)sureButtonclick{
    NSString *account  = self.accountTF.text;
    NSString *password = self.passWordTF.text;
    account = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//过滤左右空格
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([self.delegate respondsToSelector:@selector(loginGatewayWithAccount:Password:)]) {
        [self.delegate loginGatewayWithAccount:account Password:password];
    }
    
    [self dismissToInvisible];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = kbHeight - kScreenHight + (self.frame.origin.y + self.frame.size.height);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - offset - INTERVAL_KEYBOARD, self.frame.size.width, self.frame.size.height);
        }];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

@end
