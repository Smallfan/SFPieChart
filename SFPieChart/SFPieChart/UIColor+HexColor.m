//
//  UIColor+HexColor.m
//  
//
//  Created by Jonas Schnelli on 01.07.10.
//  Modified by Vladimir Boichentsov on 23.10.11.
//  Modified by Smallfan on 20.10.15.
//  Copyright 2010 include7 AG. All rights reserved.
//

#import "UIColor+HexColor.h"


@implementation UIColor (i7HexColor)

- (NSString *) hexString {
	
    const CGFloat *_color = CGColorGetComponents(self.CGColor);
    NSString *hex = [NSString stringWithFormat:@"#%02X%02X%02X", (int)(_color[0]*255.0), (int)(_color[1]*255.0), (int)(_color[2]*255.0)];
    
    return hex;
}

+ (UIColor *) colorWithHex:(int)color {
    return [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:1.0];
}

+ (UIColor *) colorWithHexRed:(int)red green:(char)green blue:(char)blue alpha:(char)alpha {
    int x = 0;
    x |= (red & 0xff) << 24;
    x |= (green & 0xff) << 16;
    x |= (blue & 0xff) << 8;
    x |= (alpha & 0xff);
    return [UIColor colorWithHex:x];
}


+ (UIColor *) colorWithHexString:(NSString *)hexString {
	
	/* convert the string into a int */
	unsigned int colorValueR,colorValueG,colorValueB,colorValueA;
	NSString *hexStringCleared = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
	if(hexStringCleared.length == 3) {
		/* short color form */
		/* im lazy, maybe you have a better idea to convert from #fff to #ffffff */
		hexStringCleared = [NSString stringWithFormat:@"%@%@%@%@%@%@", [hexStringCleared substringWithRange:NSMakeRange(0, 1)],[hexStringCleared substringWithRange:NSMakeRange(0, 1)],
												[hexStringCleared substringWithRange:NSMakeRange(1, 1)],[hexStringCleared substringWithRange:NSMakeRange(1, 1)],
												[hexStringCleared substringWithRange:NSMakeRange(2, 1)],[hexStringCleared substringWithRange:NSMakeRange(2, 1)]];
	}
	if(hexStringCleared.length == 6) {
		hexStringCleared = [hexStringCleared stringByAppendingString:@"ff"];
	}
	
	/* im in hurry ;) */
	NSString *red = [hexStringCleared substringWithRange:NSMakeRange(0, 2)];
	NSString *green = [hexStringCleared substringWithRange:NSMakeRange(2, 2)];
	NSString *blue = [hexStringCleared substringWithRange:NSMakeRange(4, 2)];
	NSString *alpha = [hexStringCleared substringWithRange:NSMakeRange(6, 2)];
	
	[[NSScanner scannerWithString:red] scanHexInt:&colorValueR];
	[[NSScanner scannerWithString:green] scanHexInt:&colorValueG];
	[[NSScanner scannerWithString:blue] scanHexInt:&colorValueB];
	[[NSScanner scannerWithString:alpha] scanHexInt:&colorValueA];
	

	return [UIColor colorWithRed:((colorValueR)&0xFF)/255.0 
					green:((colorValueG)&0xFF)/255.0 
					 blue:((colorValueB)&0xFF)/255.0 
					alpha:((colorValueA)&0xFF)/255.0];
	

}

+ (UIColor *) colorWithIntegerRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {

    if (alpha > 1 ) {
        alpha = alpha/255.f;
    }
    
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}


@end
