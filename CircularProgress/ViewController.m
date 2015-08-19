//
//  ViewController.m
//  CircularProgress
//
//  Created by Ren Guohua on 15/8/19.
//  Copyright (c) 2015年 Ren guohua. All rights reserved.
//

#import "ViewController.h"
#import "CSTCircleProgressView.h"
#import "Colours.h"

@interface ViewController ()

@property (nonatomic, strong) CSTCircleProgressView *progressView;

@end


#pragma mark - Life cycle

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_configSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    
    return UIStatusBarAnimationFade;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}


#pragma mark - Private method

- (void)p_configSubViews{
    
    [self.view addSubview:self.progressView];
    [self p_configLayoutConstraintsWithProgressView];
    self.progressView.progress = 0.7;
}

- (void)p_configLayoutConstraintsWithProgressView{
    
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *constraintWidth = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:9.0 / 10.0 constant:0.0];
    
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.progressView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    
    
    [NSLayoutConstraint activateConstraints:@[constraintCenterX,constraintCenterY,constraintWidth,constraintHeight]];
}


#pragma mark - Setters and getters

- (CSTCircleProgressView *)progressView{

    if (!_progressView) {
        
        _progressView = [[CSTCircleProgressView alloc] init];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.roundedCorners = YES;
        _progressView.trackTintColor = [UIColor colorFromHexString:@"c4ebff"];
        _progressView.thicknessRatio = 0.1;
        
    }
    
    return _progressView;
}

@end
