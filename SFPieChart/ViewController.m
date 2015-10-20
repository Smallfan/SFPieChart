//
//  ViewController.m
//  SFPieChartDemo
//
//  Created by Smallfan on 10/20/15.
//  Copyright © 2015 Smallfan. All rights reserved.
//

#import "ViewController.h"
#import "SFPieChart.h"
#import "UIColor+HexColor.h"

@interface ViewController () {
 
    SFPieChart *_chartView;
    
    NSArray *_chartValues;
    
    UILabel *_signatureLabel;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)setup {
    
    if (!_chartView) {
        _chartView = [[SFPieChart alloc] init];
        [_chartView setFrame:CGRectMake(0, 0, 220, 220)];
        [_chartView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
        [_chartView setEnableStrokeColor:NO];
        [_chartView setHoleRadiusPrecent:0.55];
        [_chartView setShowLabels:YES];
        [_chartView setLabelLineColor:[UIColor whiteColor]];
        [_chartView setLabelTextColor:[UIColor whiteColor]];
        [_chartView setMinPrecentForShowLabel:2];
        [self.view addSubview:_chartView];
    }
    
    _chartValues = @[
                         @{@"name":@"1", @"value":@135},
                         @{@"name":@"2", @"value":@22},
                         @{@"name":@"3", @"value":@18},
                         @{@"name":@"4", @"value":@8},
                         @{@"name":@"5", @"value":@5},
                         @{@"name":@"6", @"value":@4},
                         @{@"name":@"7", @"value":@2},
                         @{@"name":@"8", @"value":@2},
                         @{@"name":@"9", @"value":@1},
                         @{@"name":@"10", @"value":@1},
                         @{@"name":@"11", @"value":@1},
                         @{@"name":@"12", @"value":@1}
                         //e.g
                         //@{@"name":@"13", @"value":@50, @"color":[UIColor colorWithHex:0xb0bec5aa]}
                         ];
    
    
    [_chartView setChartValues:_chartValues animation:YES options:SFPieChartAnimationFanAll];
    
    
    
    if (_signatureLabel == nil) {
        _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 220, [[UIScreen mainScreen] bounds].size.height - 40, 200, 40)];
        _signatureLabel.textColor = [UIColor whiteColor];
        _signatureLabel.font = [UIFont boldSystemFontOfSize:17];
        _signatureLabel.textAlignment = NSTextAlignmentRight;
        _signatureLabel.text = @"Created by Smallfan";
        [self.view addSubview:_signatureLabel];
    }
    
}


@end
