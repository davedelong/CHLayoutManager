//
//  NSView+CHLayout.m
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

#import "NSView+CHLayout.h"
#import <objc/runtime.h>
#import "CHLayoutManager.h"

static NSString * NSViewLayoutName_CHLayout = @"NSViewLayoutName_CHLayout";
static NSString * NSViewConstraints_CHLayout = @"NSViewConstraints_CHLayout";

@implementation NSView (CHLayout)

- (void) setLayoutName:(NSString *)newLayoutName {
	objc_setAssociatedObject(self, &NSViewLayoutName_CHLayout, newLayoutName, OBJC_ASSOCIATION_COPY);
}

- (NSString *) layoutName {
	return (NSString *)objc_getAssociatedObject(self, &NSViewLayoutName_CHLayout);
}

- (void) addConstraint:(CHLayoutConstraint *)constraint {
	NSMutableArray * constraints = (NSMutableArray *)objc_getAssociatedObject(self, &NSViewConstraints_CHLayout);
	if (constraints == nil) {
		constraints = [NSMutableArray array];
		objc_setAssociatedObject(self, &NSViewConstraints_CHLayout, constraints, OBJC_ASSOCIATION_RETAIN);
	}
	[constraints addObject:constraint];
	[[CHLayoutManager sharedLayoutManager] beginProcessingView:self];
}

- (NSArray *) constraints {
	NSMutableArray * constraints = (NSMutableArray *)objc_getAssociatedObject(self, &NSViewConstraints_CHLayout);
	if (constraints == nil) { return [NSArray array]; }
	
	return [[constraints copy] autorelease];
}

- (void) removeAllConstraints {
	NSMutableArray * constraints = (NSMutableArray *)objc_getAssociatedObject(self, &NSViewConstraints_CHLayout);
	if (constraints != nil) {
		[constraints removeAllObjects];
	}
}

- (CGFloat) valueForLayoutAttribute:(CHLayoutConstraintAttribute)attribute {
	NSRect frame = [self frame];
	switch (attribute) {
		case CHLayoutConstraintAttributeMinY:
			return NSMinY(frame);
		case CHLayoutConstraintAttributeMaxY:
			return NSMaxY(frame);
		case CHLayoutConstraintAttributeMinX:
			return NSMinX(frame);
		case CHLayoutConstraintAttributeMaxX:
			return NSMaxX(frame);
		case CHLayoutConstraintAttributeWidth:
			return NSWidth(frame);
		case CHLayoutConstraintAttributeHeight:
			return NSHeight(frame);
		case CHLayoutConstraintAttributeMidY:
			return NSMidY(frame);
		case CHLayoutConstraintAttributeMidX:
			return NSMidX(frame);
		default:
			return 0;
	}
}

- (void) setValue:(CGFloat)newValue forLayoutAttribute:(CHLayoutConstraintAttribute)attribute {
	NSRect frame = [self frame];
	switch (attribute) {
		case CHLayoutConstraintAttributeMinY:
			frame.origin.y = newValue;
			break;
		case CHLayoutConstraintAttributeMaxY:
			frame.origin.y = newValue - frame.size.height;
			break;
		case CHLayoutConstraintAttributeMinX:
			frame.origin.x = newValue;
			break;
		case CHLayoutConstraintAttributeMaxX:
			frame.origin.x = newValue - frame.size.height;
			break;
		case CHLayoutConstraintAttributeWidth:
			frame.size.width = newValue;
			break;
		case CHLayoutConstraintAttributeHeight:
			frame.size.height = newValue;
			break;
		case CHLayoutConstraintAttributeMidY:
			frame.origin.y = newValue - (frame.size.height/2);
			break;
		case CHLayoutConstraintAttributeMidX:
			frame.origin.x = newValue - (frame.size.width/2);
			break;
	}
	[self setFrame:frame];
}

- (NSView *) relativeViewForName:(NSString *)name {
	if ([name isEqual:@"superview"]) {
		return [self superview];
	}
	
	NSArray * superSubviews = [[self superview] subviews];
	for (NSView *view in superSubviews) {
		if ([[view layoutName] isEqual:name]) {
			return (view == self ? nil : view);
		}
	}
	return nil;
}

@end
