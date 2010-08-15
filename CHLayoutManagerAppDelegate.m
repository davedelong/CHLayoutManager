//
//  CHLayoutManagerAppDelegate.m
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

#import "CHLayoutManagerAppDelegate.h"
#import "CHLayout.h"
#import "SinTransformer.h"


@implementation CHLayoutManagerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	[button1 setLayoutName:@"button1"];
	[button2 addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMinX relativeTo:@"button1" attribute:CHLayoutConstraintAttributeMaxX]];
	[button2 addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMaxY relativeTo:@"button1" attribute:CHLayoutConstraintAttributeMaxY]];
	[button2 addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeWidth relativeTo:@"button1" attribute:CHLayoutConstraintAttributeWidth]];
	
//	[progress startAnimation:nil];
	CHLayoutConstraint * centerHorizontal = [CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMidX relativeTo:@"superview" attribute:CHLayoutConstraintAttributeMidX];
	CHLayoutConstraint * centerVertical = [CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMidY relativeTo:@"superview" attribute:CHLayoutConstraintAttributeMidY];
	[progress addConstraint:centerHorizontal];
	[progress addConstraint:centerVertical];
	
	
	[leftVerticalButton setLayoutName:@"leftVertical"];
	[leftVerticalButton addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMinX relativeTo:@"superview" attribute:CHLayoutConstraintAttributeMinX offset:37]];
	[rightVerticalButton addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMaxX relativeTo:@"superview" attribute:CHLayoutConstraintAttributeMaxX offset:-13]];
	[rightVerticalButton addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMinY relativeTo:@"leftVertical" attribute:CHLayoutConstraintAttributeMinY]];
	
#if NS_BLOCKS_AVAILABLE
	
	CHLayoutTransformer transformer = ^(CGFloat source) {
		CGFloat superViewHeight = [[rightVerticalButton superview] frame].size.height;
		return (superViewHeight - source);
	};
	[rightVerticalButton addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMaxY relativeTo:@"leftVertical" attribute:CHLayoutConstraintAttributeMinY blockTransformer:transformer]];
	
#endif
	
	[helpButton addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMinX relativeTo:@"leftVertical" attribute:CHLayoutConstraintAttributeMinY scale:2.0 offset:0.0]];
	
	SinTransformer * sinTransformer = [[SinTransformer alloc] init];
	[helpButton addConstraint:[CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMinY relativeTo:@"button1" attribute:CHLayoutConstraintAttributeMinY valueTransformer:sinTransformer]];
	[sinTransformer release];
	
	[self sliderChanged:nil];
//	[[CHLayoutManager sharedLayoutManager] beginProcessingView:[window contentView]];
}

- (IBAction) sliderChanged:(id)sender {
	CGFloat sliderValue = [widthSlider floatValue];
	NSRect button1Frame = [button1 frame];
	button1Frame.size.width = sliderValue;
	button1Frame.origin.y = sliderValue;
	[button1 setFrame:button1Frame];
	
	CGFloat range = ([widthSlider maxValue] - [widthSlider minValue]);
	CGFloat percentage = ((sliderValue - range)/range) * 0.9;
	NSRect leftVerticalFrame = [leftVerticalButton frame];
	leftVerticalFrame.origin.y = ([[window contentView] frame].size.height * percentage);
	[leftVerticalButton setFrame:leftVerticalFrame];
}

- (IBAction) clickButton1:(id)sender {

}

@end
