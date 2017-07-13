//
//  ViewController.m
//  PopTextFieldDemo
//
//  Created by apple on 2017/7/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "GatewayLoginView.h"

@interface ViewController ()<GatewayLoginViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationItem];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)setNavigationItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target: self action:@selector(editAction)];
}

- (void)editAction{
    GatewayLoginView *popView = [[GatewayLoginView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 130, self.view.frame.size.height / 2 - 100, 260, 200)];
    popView.delegate = self;
    [popView presentToVisible];
}

#pragma mark - GatewayLoginViewDelegate
- (void)loginGatewayWithDictionary: (NSDictionary *)dictionary{
    NSLog(@"%@", dictionary);
    
}

- (void)loginGatewayWithAccount:(NSString *)account Password:(NSString *)password{
    NSLog(@"account: %@, password: %@", account, password);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
