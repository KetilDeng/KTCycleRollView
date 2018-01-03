//
//  ViewController.m
//  KTCycleRollView
//
//  Created by Ketao Deng on 2018/1/3.
//  Copyright © 2018年 Ketao Deng. All rights reserved.
//

#import "ViewController.h"
#import "CycleRollView.h"

/** 屏幕宽 */
#define SCREEN_WIDTH MIN([UIScreen mainScreen].bounds.size.width,[UIScreen  mainScreen].bounds.size.height)
/** 屏幕高 */
#define SCREEN_HEIGHT MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
/** iPhoneX判断 */
#define IS_iPhoneX (SCREEN_HEIGHT == 812 && SCREEN_WIDTH == 375)
/** iPhoneX导航头高度 */
#define iPHONEX_NAVBAR_H IS_iPhoneX?88.0:64.0

@interface ViewController ()

@property (nonatomic, strong) CycleRollView *cycleRollView;
@property (nonatomic, strong) CycleRollView *leftCycleRollView;
@property (nonatomic, strong) CycleRollView *rightCycleRollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CycleRollView";
    [self.view addSubview:self.cycleRollView];
    [self.view addSubview:self.leftCycleRollView];
    [self.view addSubview:self.rightCycleRollView];
    
    self.cycleRollView.imageURLs = @[@"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b919050a32.png",
                                     @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b926fa84c0.png",
                                     @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b92ee7702c.png",
                                     @"http:\/\/img.yishouapp.com\/2017\/12\/30\/5a479a221a186.png"];
    
    self.leftCycleRollView.imageURLs = @[@"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b919050a32.png",
                                         @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b926fa84c0.png",
                                         @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b92ee7702c.png",
                                         @"http:\/\/img.yishouapp.com\/2017\/12\/30\/5a479a221a186.png"];
    
    self.rightCycleRollView.imageURLs = @[@"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b919050a32.png",
                                          @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b926fa84c0.png",
                                          @"http:\/\/img.yishouapp.com\/2018\/01\/02\/5a4b92ee7702c.png",
                                          @"http:\/\/img.yishouapp.com\/2017\/12\/30\/5a479a221a186.png"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CycleRollView *)cycleRollView
{
    if (!_cycleRollView) {
        _cycleRollView = [CycleRollView cycleRollWithFrame:CGRectMake(0, iPHONEX_NAVBAR_H, SCREEN_WIDTH, 135) placeholder:nil];
        _cycleRollView.cycleRollViewClickItemBlock = ^(NSInteger currentIndex) {
            NSLog(@"%ld", currentIndex);
        };
    }
    return _cycleRollView;
}

- (CycleRollView *)leftCycleRollView
{
    if (!_leftCycleRollView) {
        _leftCycleRollView = [CycleRollView cycleRollWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleRollView.frame)+40, SCREEN_WIDTH, 135) alignType:CycleRollPageControlAlignTypeLeft placeholder:nil];
        _leftCycleRollView.cycleRollViewClickItemBlock = ^(NSInteger currentIndex) {
            NSLog(@"%ld", currentIndex);
        };
    }
    return _leftCycleRollView;
}

- (CycleRollView *)rightCycleRollView
{
    if (!_rightCycleRollView) {
        _rightCycleRollView = [CycleRollView cycleRollWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftCycleRollView.frame)+40, SCREEN_WIDTH, 135) alignType:CycleRollPageControlAlignTypeRight placeholder:nil disableTimer:YES];
        _rightCycleRollView.cycleRollViewClickItemBlock = ^(NSInteger currentIndex) {
            NSLog(@"%ld", currentIndex);
        };
    }
    return _rightCycleRollView;
}

@end
