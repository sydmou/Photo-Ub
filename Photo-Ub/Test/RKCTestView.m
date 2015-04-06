//
//  RKCTestView.m
//  Test
//
//  Created by 张昊 on 15/3/31.
//  Copyright (c) 2015年 HaoYa. All rights reserved.
//

#import "RKCTestView.h"
#import "ViewController.h"
@implementation RKCTestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginButton.frame = CGRectMake(0, 0, frame.size.width, 100);
        [_loginButton addTarget:(ViewController *)self.superview action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loginButton];
        
    }
    return self;
}
@end
