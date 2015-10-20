# SFPieChart
Pie Chart iOS with precent label to present.

This projs adapted from [@VBPieChart](https://github.com/sakrist/VBPieChart)(thx).
Animated Pie Chart control for iOS apps, based on CALayer.
Support to show precent value of each block in piechart.

<img src="https://github.com/Smallfan/SFPieChart/master/Screenshot.png">


Usage
-----

_chartView = [[SFPieChart alloc] init];
[_chartView setFrame:CGRectMake(0, 0, 220, 220)];
[_chartView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
[_chartView setEnableStrokeColor:NO];
[_chartView setHoleRadiusPrecent:0.55];
[_chartView setShowLabels:YES];
[_chartView setLabelLineColor:[UIColor whiteColor]];
[_chartView setLabelTextColor:[UIColor whiteColor]];
[_chartView setMinPrecentForShowLabel:2];
NSArray *chartValues = @[...];
[_chartView setChartValues:_chartValues animation:YES options:SFPieChartAnimationFanAll];


--

Version: 0.1.0<br>

Email: CoderSmallfan@gmail.com

