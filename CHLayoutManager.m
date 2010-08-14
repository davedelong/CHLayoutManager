//
//  CHLayoutManager.m
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

#import "CHLayoutManager.h"
#import "CHLayoutConstraint.h"
#import "NSView+CHLayout.h"
#import <objc/runtime.h>

@interface CHLayoutContainer : NSObject
{
	NSString * layoutName;
	NSMutableArray * constraints;
}

@property (nonatomic, copy) NSString * layoutName;
@property (readonly) NSMutableArray * constraints;

@end

@implementation CHLayoutContainer
@synthesize layoutName, constraints;

+ (id) container {
	return [[[self alloc] init] autorelease];
}

- (id) init {
	if (self = [super init]) {
		constraints = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void) dealloc {
	[constraints release];
	[layoutName release];
	[super dealloc];
}

@end



static CHLayoutManager * _sharedLayoutManager = nil;

__attribute__((constructor))
static void construct_layoutManagerSingleton() {
	NSAutoreleasePool * p = [[NSAutoreleasePool alloc] init];
	_sharedLayoutManager = [[CHLayoutManager alloc] init];
	[p release];
}

__attribute__((destructor))
static void destroy_layoutManagerSingleton() {
	//since this happens at some point during teardown, I'm not sure there'll be an autorelease pool in place
	//but just in case.... make one anyway
	
	NSAutoreleasePool * p = [[NSAutoreleasePool alloc] init];
	[_sharedLayoutManager release], _sharedLayoutManager = nil;
	[p release];
}

@implementation CHLayoutManager

+ (id) sharedLayoutManager {
	return _sharedLayoutManager;
}

+ (id) allocWithZone:(NSZone *)zone {
	if (_sharedLayoutManager) {
		return [_sharedLayoutManager retain];
	} else {
		return [super allocWithZone:zone];
	}
}

- (id) init {
	if (!_sharedLayoutManager) {
		if (self = [super init]) {
			//initialization goes here
			isProcessingChanges = NO;
			viewsToProcess = [[NSMutableArray alloc] init];
			processedViews = [[NSMutableSet alloc] init];
			constraints = [[NSMutableDictionary alloc] init];
			
			hasRegistered = NO;
		}
	} else if (self != _sharedLayoutManager) {
		[super dealloc];
		self = _sharedLayoutManager;
	}
	return self;
}

- (void) dealloc {
	[viewsToProcess release];
	[processedViews release];
	[constraints release];
	[super dealloc];
}

- (void) processView:(NSView *)aView {
	if (hasRegistered == NO) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameChanged:) name:NSViewFrameDidChangeNotification object:nil];
		hasRegistered = YES;
	}
	[processedViews addObject:aView];
	
	/**
	 ORDER OF OPERATIONS:
	 1.  See if this view has any direct constraints
	 2.  See if this view has any siblings with constraints to this view
	 3.  See if this view has any children with constraints to superview
	 
	 **/
	
	//constraints for this view:
	NSArray * viewConstraints = [self constraintsOnView:aView];
	for (CHLayoutConstraint * constraint in viewConstraints) {
		[constraint applyToTargetView:aView];
	}
	
	NSArray * superSubviews = [[aView superview] subviews];
	for (NSView * subview in superSubviews) {
		if (subview == aView) { continue; }
		
		NSArray * subviewConstraints = [self constraintsOnView:subview];
		for (CHLayoutConstraint * subviewConstraint in subviewConstraints) {
			NSView * sourceView = [subview relativeViewForName:[subviewConstraint sourceName]];
			if (sourceView == aView) {
				[subviewConstraint applyToTargetView:subview];
			}
		}
	}
	
	NSArray * subviews = [aView subviews];
	for (NSView * subview in subviews) {
		NSArray * subviewConstraints = [self constraintsOnView:subview];
		for (CHLayoutConstraint * subviewConstraint in subviewConstraints) {
			NSView * sourceView = [subview relativeViewForName:[subviewConstraint sourceName]];
			if (sourceView == aView) {
				[subviewConstraint applyToTargetView:subview];
			}
		}
	}
}

- (void) beginProcessingView:(NSView *)view {
	if (isProcessingChanges == NO) {
		isProcessingChanges = YES;
		[viewsToProcess removeAllObjects];
		[processedViews removeAllObjects];
		[viewsToProcess addObject:view];
		
		while([viewsToProcess count] > 0) {
			NSView * currentView = [[viewsToProcess objectAtIndex:0] retain];
			[viewsToProcess removeObjectAtIndex:0];			
			if ([viewsToProcess containsObject:currentView] == NO) {
				[self processView:currentView];
			}
			[currentView release];
		}
		
		isProcessingChanges = NO;
	} else {
		if ([processedViews containsObject:view] == NO) {
			[viewsToProcess addObject:view];
		}
	}
}

- (void) frameChanged:(NSNotification *)notification {
	NSView * view = [notification object];
	[self beginProcessingView:view];
}

#pragma mark -

- (NSValue *) keyForView:(NSView *)view {
	return [NSValue valueWithPointer:view];	
}

- (void) addConstraint:(CHLayoutConstraint *)constraint toView:(NSView *)view {
	NSValue * viewPointer = [self keyForView:view];
	CHLayoutContainer * viewContainer = [constraints objectForKey:viewPointer];
	if (viewContainer == nil) {
		viewContainer = [CHLayoutContainer container];
		[constraints setObject:viewContainer forKey:viewPointer];
	}
	[[viewContainer constraints] addObject:constraint];
	[self beginProcessingView:view];
}

- (void) removeConstraintsFromView:(NSView *)view {
	NSValue * viewPointer = [self keyForView:view];
	[constraints removeObjectForKey:viewPointer];
}

- (NSArray *) constraintsOnView:(NSView *)view {
	NSValue * viewPointer = [self keyForView:view];
	CHLayoutContainer * container = [constraints objectForKey:viewPointer];
	if (container == nil) { return [NSArray array]; }
	return [[[container constraints] copy] autorelease];
}

- (NSString *) layoutNameForView:(NSView *)view {
	NSValue * viewPointer = [self keyForView:view];
	CHLayoutContainer * container = [constraints objectForKey:viewPointer];
	return [container layoutName];
}

- (void) setLayoutName:(NSString *)name forView:(NSView *)view {
	NSValue * viewPointer = [self keyForView:view];
	CHLayoutContainer * viewContainer = [constraints objectForKey:viewPointer];
	if (viewContainer == nil) {
		viewContainer = [CHLayoutContainer container];
		[constraints setObject:viewContainer forKey:viewPointer];
	}
	[viewContainer setLayoutName:name];
}

@end
