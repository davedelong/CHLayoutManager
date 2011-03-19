//
//  NSNumber+CHLayout.h
//  CHLayoutManager
//
//  Created by Dave DeLong on 3/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNumber (CHLayout)

+ (id)numberWithCGFloat_ch:(CGFloat)cgFloat;
- (id)initWithCGFloat_ch:(CGFloat)cgFloat;

- (CGFloat)CGFloatValue_ch;

@end
