//
//  SinTransformer.m
//  CHLayoutManager
//
//  Created by Dave DeLong on 8/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SinTransformer.h"


@implementation SinTransformer

- (id) transformedValue:(id)value {
	CGFloat source = [value floatValue];
	CGFloat output = fabs((50*sinf(source))) + 20;
	return [NSNumber numberWithFloat:output];
}

@end
