//
//  SFPieChart.m
//  SFPieChartDemo
//
//  Created by Smallfan on 10/20/15.
//  Copyright © 2015 Smallfan. All rights reserved.
//

#import "SFPieChart.h"
#import "SFPiePiece.h"
#import "UIColor+HexColor.h"

@interface SFPiePieceData : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *value;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) NSNumber *precent;
@property (nonatomic) BOOL accent;
@end
@implementation SFPiePieceData
@end

@interface SFPieChart () {
    CGPoint moveP;
    
    double _onePrecent;
    double _onePrecentOfChart;
}
@property (nonatomic, retain) NSMutableArray *chartsData;
@property (nonatomic) float radius;
@property (nonatomic) float holeRadius;
@property (nonatomic, assign) SFPiePiece *hitLayer;

@property (nonatomic) BOOL presentWithAnimation;
@property (nonatomic) SFPieChartAnimationOptions animationOptions;
@property (nonatomic) float animationDuration;


@property (nonatomic, strong) NSMutableArray *drawPointArray;

@end

@interface SFPiePiece ()
- (void)_animate;
- (void)setAnimationOptions:(SFPieChartAnimationOptions)options;
- (void)setAnimationDuration:(float)duration;
- (void)setShowLabel:(BOOL)value;
@property (nonatomic, copy) void (^endAnimationBlock)(void);
@end


@implementation SFPieChart {
    CGPoint _touchBegan;
}


- (id)init {
    self = [super init];
    if (self) {
        self.chartsData = [NSMutableArray array];
        self.strokeColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.7];
        
        self.startAngle = 0;
        self.length = M_PI*2;
        self.radiusPrecent = 0.9;
        self.holeRadius = 0;
        self.holeRadiusPrecent = 0.2;
        self.maxAccentPrecent = 0.25;
        self.enableStrokeColor = NO;
        self.minPrecentForShowLabel = 5;
        
        [self addObserver:self
               forKeyPath:@"chartValues"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        [self addObserver:self
               forKeyPath:@"enableStrokeColor"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        [self addObserver:self
               forKeyPath:@"holeRadiusPrecent"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
        [self addObserver:self
               forKeyPath:@"radiusPrecent"
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:nil];
    }
    return self;
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"chartValues"];
        [self removeObserver:self forKeyPath:@"enableStrokeColor"];
        [self removeObserver:self forKeyPath:@"holeRadiusPrecent"];
        [self removeObserver:self forKeyPath:@"radiusPrecent"];
    } @catch (NSException * __unused exception) {}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"chartValues"] || [keyPath isEqualToString:@"enableStrokeColor"]) {
        [self updateCharts];
    }
    if([keyPath isEqualToString:@"holeRadiusPrecent"] || [keyPath isEqualToString:@"radiusPrecent"]) {
        [self setFrame:self.frame];
    }
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.radius = frame.size.width / 2 * _radiusPrecent;
    self.holeRadius = _radius*_holeRadiusPrecent;
    [self updateCharts];
}


//default color list
- (UIColor *)defaultColors:(NSInteger)index {
    
    switch (index) {
        case 0:
            return [UIColor colorWithHex:0xFEE95B];
        case 1:
            return [UIColor colorWithHex:0xA5D770];
        case 2:
            return [UIColor colorWithHex:0x8ACC82];
        case 3:
            return [UIColor colorWithHex:0x5BBE84];
        case 4:
            return [UIColor colorWithHex:0x2DB185];
        case 5:
            return [UIColor colorWithHex:0x04A38D];
        case 6:
            return [UIColor colorWithHex:0x4E79BF];
        case 7:
            return [UIColor colorWithHex:0x5E93C4];
        case 8:
            return [UIColor colorWithHex:0xE54E79];
        case 9:
            return [UIColor colorWithHex:0xE34646];
        case 10:
            return [UIColor colorWithHex:0xFE9D47];
        case 11:
            return [UIColor colorWithHex:0xC23C4A];
            
        default:
            return [UIColor colorWithRed:(arc4random() % 255)/255.0f green:(arc4random() % 255)/255.0f blue:(arc4random() % 255)/255.0f alpha:1.0];
    }
}

- (void)updateCharts {

    if (!_chartValues) {
        return;
    }
    
    // Clean old layers
    NSArray *arraySublayers = [NSArray arrayWithArray:self.layer.sublayers];
    for (CALayer *l in arraySublayers) {
        [l removeFromSuperlayer];
    }
    arraySublayers = nil;
    
    // init temp variables
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    double fullValue = 0;
    
    
    //export data
    NSUInteger index = 0;
    for (NSDictionary *object in _chartValues) {
        
        SFPiePieceData *data;
        BOOL created = NO;
        if ([_chartsData count] > index) {
            data = [_chartsData objectAtIndex:index];
        } else {
            data = [[SFPiePieceData alloc] init];
            created = YES;
        }
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)object;
            data.name = [dict objectForKey:@"name"];
            data.value = [dict objectForKey:@"value"];
            if (![dict objectForKey:@"color"] || [[dict objectForKey:@"color"] isEqualToString:@""]) {
                data.color = [self defaultColors:index];
            } else {
                data.color = [dict objectForKey:@"color"];
            }
            data.accent = [[dict objectForKey:@"accent"] boolValue];
        } else {
            data.value = (NSNumber *)object;
            if (created) {
                data.color = [self defaultColors:index];
            }
        }
        
        if (created) {
            [_chartsData addObject:data];
        }
        
        //calculate total value
        fullValue += fabsf([data.value floatValue]);
        index++;
    }
    
    //calculate precent of value
    for(NSInteger index = 0; index < _chartsData.count; index++) {
        SFPiePieceData *data;
        data = [_chartsData objectAtIndex:index];
        data.precent = [NSNumber numberWithFloat:([data.value floatValue] / fullValue)];
        [_chartsData replaceObjectAtIndex:index withObject:data];
    }
    
    
    //actual value of 1%
    _onePrecent = fullValue * 0.01;
    //radian of 1%
    _onePrecentOfChart = _length * 0.01;
    //startAngle
    double start = _startAngle;
    
    _drawPointArray = [NSMutableArray array];

    for (SFPiePieceData *data in _chartsData) {
        
        //calculate percentage
        double pieceValuePrecents = fabsf([data.value floatValue]) / _onePrecent;
        //calculate radian of value
        double pieceChartValue = _onePrecentOfChart * pieceValuePrecents;
        
        //filter value of 0%
        if (pieceChartValue == 0) {
            continue;
        }
        
        SFPiePiece *piece = [[SFPiePiece alloc] init];
        [piece setFrame:rect];
        [piece setEndAnimationBlock:^{
            if (self.showLabels) {
                [self drawLabel];
            }
        }];
        
        if (data.accent) {
            [piece setAccentPrecent:0.1];
        }
        
        [piece setValue:pieceValuePrecents];
        
        //innerRadius
        [piece setInnerRadius:_radius];
        
        //outerRadius
        [piece setOuterRadius:_holeRadius];
        piece.fillColor = data.color.CGColor;
        
        
        //set color of stroke line
        if (_enableStrokeColor) {
            piece.strokeColor = _strokeColor.CGColor;
        }
        
        
        CGFloat slashLength = 15;
        CGSize size = self.frame.size;
        CGPoint center = CGPointMake(size.width / 2, size.height / 2);
        NSMutableDictionary *pointDic = [NSMutableDictionary dictionary];
        [pointDic setObject:[NSValue valueWithCGPoint:[self prepareForCross:pieceChartValue start:start length:_radius+5 center:center]] forKey:@"startPoint"];
        [pointDic setObject:[NSValue valueWithCGPoint:[self prepareForCross:pieceChartValue start:start length:_radius+5+slashLength center:center]] forKey:@"endPoint"];
        [self.drawPointArray addObject:pointDic];
        
        //begin Animate
        [piece pieceAngle:pieceChartValue start:start];
        
        
        //set hidden of piece before animation starting
        if (_presentWithAnimation) {
            [piece setHidden:YES];
        }
        
        //animation options
        [piece setAnimationDuration:_animationDuration];
        [piece setAnimationOptions:_animationOptions];
        
        [self.layer addSublayer:piece];
        
        start += pieceChartValue;
    }
    
    // if was selected present with animation
    if (_presentWithAnimation) {
        
        for (NSInteger i = 0, len = [self.layer sublayers].count; i < len; i++) {
            SFPiePiece *piece = (SFPiePiece *)[[self.layer sublayers] objectAtIndex:i];
            if (i+1 < len) {
                __block SFPiePiece *blockPiece = (SFPiePiece *)[[self.layer sublayers] objectAtIndex:i+1];
                [piece setEndAnimationBlock:^{
                    [blockPiece _animate];
                }];
            }
        }
        
        SFPiePiece *piece = (SFPiePiece *)[[self.layer sublayers] objectAtIndex:0];
        [piece _animate];
        
        _presentWithAnimation = NO;
    }
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation {
    [self setChartValues:chartValues animation:animation options:(SFPieChartAnimationFanAll | SFPieChartAnimationTimingLinear)];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation options:(SFPieChartAnimationOptions)options {
    [self setChartValues:chartValues animation:animation duration:0.7 options:options];
}

- (void) setChartValues:(NSArray *)chartValues animation:(BOOL)animation duration:(float)duration options:(SFPieChartAnimationOptions)options {
    _presentWithAnimation = animation;
    _animationOptions = options;
    _animationDuration = duration;
    self.chartValues = chartValues;
}




//calculate slash start point
- (CGPoint)prepareForCross:(float)angle start:(float)startAngle length:(float)length center:(CGPoint)center {
    float calcAngle = angle + startAngle * 2;
    float x = center.x + length*cos(calcAngle/2);
    float y = center.y + length*sin(calcAngle/2);
    
    return CGPointMake(x,y);
}


//draw slash & label
- (void)drawLabel {
    
    CGSize size = self.frame.size;
    CGPoint center = CGPointMake(size.width / 2, size.height / 2);
    
    
    for (NSInteger index = 0; index < _drawPointArray.count; index++) {
       
        //disable draw when the actual value less than a certain value
        SFPiePieceData *data = [_chartsData objectAtIndex:index];
        if ([data.precent floatValue] * 100 < self.minPrecentForShowLabel) {
            continue;
        }
        
        
        NSDictionary *drawPointDic = [_drawPointArray objectAtIndex:index];
        
        CAShapeLayer *dataLineLayer = [[CAShapeLayer alloc] init];
        dataLineLayer.fillColor = nil;
        dataLineLayer.strokeColor = self.labelLineColor.CGColor;
        dataLineLayer.lineWidth = 1;
        dataLineLayer.frame = self.bounds;
        
        NSMutableArray *points = [NSMutableArray array];
        [points addObject:[drawPointDic objectForKey:@"startPoint"]];
        [points addObject:[drawPointDic objectForKey:@"endPoint"]];
        
        //turn left or right
        CGFloat lineLength = 15;
        CGPoint endPoint = [[drawPointDic objectForKey:@"endPoint"] CGPointValue];
        if ([[drawPointDic objectForKey:@"endPoint"] CGPointValue].x <= center.x) {
            endPoint.x -= lineLength;
        } else {
            endPoint.x += lineLength;
        }
        [points addObject:[NSValue valueWithCGPoint:endPoint]];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:[[points firstObject] CGPointValue]];
        
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, [points count] - 1)];
        [points enumerateObjectsAtIndexes:indexSet
                                  options:0
                               usingBlock:^(NSValue *pointValue, NSUInteger idx, BOOL *stop) {
                                   [path addLineToPoint:[pointValue CGPointValue]];
                               }];
        
        
        dataLineLayer.path = path.CGPath;
        [self.layer addSublayer:dataLineLayer];
        
        
        
            
        CATextLayer *label = [[CATextLayer alloc] init];
        [label setFont:@"Helvetica"];
        [label setFontSize:15];
        [label setFrame:CGRectMake(0, 0, 40, 15)];
        [label setString:[NSString stringWithFormat:@"%.0f%%",[data.precent floatValue] * 100]];
        [label setAlignmentMode:kCAAlignmentCenter];
        [label setForegroundColor:self.labelTextColor.CGColor];
        [label setBackgroundColor:[UIColor clearColor].CGColor];
        label.contentsScale = [[UIScreen mainScreen] scale];
        CGPoint labelCenter;
        if ([[drawPointDic objectForKey:@"endPoint"] CGPointValue].x <= center.x) {
            labelCenter = CGPointMake(endPoint.x - lineLength, endPoint.y);
        } else {
            labelCenter = CGPointMake(endPoint.x + lineLength, endPoint.y);
        }
        [label setPosition:labelCenter];
        [self.layer addSublayer:label];
        
        
    }
    
}


@end
