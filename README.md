# SFPieChart
Pie Chart iOS with precent label to present.

This projs adapted from [@VBPieChart](https://github.com/sakrist/VBPieChart)(thx).
Animated Pie Chart control for iOS apps, based on CALayer.
Support to show precent value of each block in piechart.

<img src="https://github.com/Smallfan/SFPieChart/blob/master/Screenshot.png">


Usage
-----

_chartView = [[SFPieChart alloc] init];<br>
[_chartView setFrame:CGRectMake(0, 0, 220, 220)];
[_chartView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];<br>
[_chartView setEnableStrokeColor:NO];<br>
[_chartView setHoleRadiusPrecent:0.55];<br>
[_chartView setShowLabels:YES];<br>
[_chartView setLabelLineColor:[UIColor whiteColor]];<br>
[_chartView setLabelTextColor:[UIColor whiteColor]];<br>
[_chartView setMinPrecentForShowLabel:2];<br>

NSArray *chartValues = @[...];<br>

[_chartView setChartValues:_chartValues animation:YES options:SFPieChartAnimationFanAll];<br>


--

Version: 0.1.0<br>

Email: CoderSmallfan@gmail.com

