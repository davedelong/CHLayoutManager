//
//  NSNumber+CHLayout.m
//  CHLayoutManager
//
//  Created by Dave DeLong on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+CHLayout.h"


@implementation NSNumber (CHLayout)

+ (id)numberWithCGFloat_ch:(CGFloat)cgFloat {
	return [[[self alloc] initWithCGFloat_ch:cgFloat] autorelease];
}

- (id)initWithCGFloat_ch:(CGFloat)cgFloat {
#if CGFLOAT_IS_DOUBLE
	return [self initWithDouble:cgFloat];
#else
	return [self initWithFloat:cgFloat];
#endif
}

- (CGFloat)CGFloatValue_ch {
#if CGFLOAT_IS_DOUBLE
	return [self doubleValue];
#else
	return [self floatValue];
#endif
}

@end
