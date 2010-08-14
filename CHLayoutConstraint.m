//
//  CHLayoutConstraint.m
//  CHLayoutManager
/**
 Copyright (c) 2010 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import "CHLayout.h"


@implementation CHLayoutConstraint
@synthesize offset, scale, attribute, sourceAttribute, sourceName;

#pragma mark Basic Initializers

+ (id)constraintWithAttribute:(CHLayoutConstraintAttribute)attr relativeTo:(NSString *)srcLayer attribute:(CHLayoutConstraintAttribute)srcAttr {
	return [self constraintWithAttribute:attr relativeTo:srcLayer attribute:srcAttr scale:1.0 offset:0.0];
}

+ (id)constraintWithAttribute:(CHLayoutConstraintAttribute)attr relativeTo:(NSString *)srcLayer attribute:(CHLayoutConstraintAttribute)srcAttr offset:(CGFloat)offset {
	return [self constraintWithAttribute:attr relativeTo:srcLayer attribute:srcAttr scale:1.0 offset:offset];
}

+ (id)constraintWithAttribute:(CHLayoutConstraintAttribute)attr relativeTo:(NSString *)srcLayer attribute:(CHLayoutConstraintAttribute)srcAttr scale:(CGFloat)scale offset:(CGFloat)offset {
	return [[[self alloc] initWithAttribute:attr relativeTo:srcLayer attribute:srcAttr scale:scale offset:offset] autorelease];
}

- (id)initWithAttribute:(CHLayoutConstraintAttribute)attr relativeTo:(NSString *)srcLayer attribute:(CHLayoutConstraintAttribute)srcAttr scale:(CGFloat)aScale offset:(CGFloat)anOffset {
	if (self = [super init]) {
		offset = anOffset;
		scale = aScale;
		attribute = attr;
		sourceAttribute = srcAttr;
		sourceName = [srcLayer copy];
	}
	return self;
}

- (void) dealloc {
	[sourceName release];
	[super dealloc];
}

- (CGFloat) transformValue:(CGFloat)original {
	return (original * scale) + offset;
}

- (void) applyToTargetView:(NSView *)target {
	NSView * source = [target relativeViewForName:[self sourceName]];
	if (source == target) { return; }
	if (source == nil) { return; }
	if ([self sourceAttribute] == 0) { return; }
	
	CGFloat sourceValue = [source valueForLayoutAttribute:[self sourceAttribute]];
	CGFloat targetValue = [self transformValue:sourceValue];
	
	[target setValue:targetValue forLayoutAttribute:[self attribute]];
}

@end
