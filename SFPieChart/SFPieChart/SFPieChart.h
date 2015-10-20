//
//  SFPieChart.h
//  SFPieChartDemo
//
//  Created by Smallfan on 10/20/15.
//  Copyright © 2015 Smallfan. All rights reserved.
//

#import <UIKit/UIKit.h>

//animation options
typedef NS_OPTIONS(NSUInteger, SFPieChartAnimationOptions) {
    SFPieChartAnimationFanAll                     = 1 <<  0, // show all of circle
    SFPieChartAnimationTimingLinear               = 4 << 16, // clockwise animation
    
};

@interface SFPieChart : UIView

//Initial value
@property (nonatomic, strong) NSArray *chartValues;

//Default is NO
@property (nonatomic) BOOL enableStrokeColor;
@property (nonatomic, strong) UIColor *strokeColor;

//Default is NO, under development
@property (nonatomic) BOOL showLabels;
@property (nonatomic) float minPrecentForShowLabel;
@property (nonatomic, strong) UIColor *labelLineColor;  //Default is black color
@property (nonatomic, strong) UIColor *labelTextColor;  //Default is black color

//Hole in center of diagram, precent of radius
//Default is 0.2, from 0 to 1
@property (nonatomic) float holeRadiusPrecent;

//Radius of diagram dependce to view size
//Default is 0.9, possible value from 0 to 1.
@property (nonatomic) float radiusPrecent;

//Default is 0.25, optimal
@property (nonatomic) float maxAccentPrecent;

//Length of circle, from 0 to M_PI*2
//Default M_PI*2.
@property (nonatomic) float length;

//Start angle
@property (nonatomic) float startAngle;

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation;
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(SFPieChartAnimationOptions)options;
- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(SFPieChartAnimationOptions)options;

@end
