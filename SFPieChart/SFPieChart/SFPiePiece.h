//
//  SFPiePiece.h
//  SFPieChartDemo
//
//  Created by Smallfan on 10/20/15.
//  Copyright © 2015 Smallfan. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface SFPiePiece : CAShapeLayer

@property (nonatomic) float innerRadius;
@property (nonatomic) float outerRadius;

@property (nonatomic) double value;

@property (nonatomic, readonly) float angle;
@property (nonatomic, readonly) float startAngle;

// Default is NO
@property (nonatomic, readonly) BOOL accent;

// Default is 0.1 (i.e. 10%) of innerRadius
@property (nonatomic) float accentPrecent;

- (BOOL) animateToAccent:(float)accentPrecent;

- (void) pieceAngle:(float)angle start:(float)startAngle;


@end
