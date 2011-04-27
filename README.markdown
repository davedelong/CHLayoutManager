**This project is no longer considered under active development, and has been deprecated in favor of built-in API.  Please see the "Supported Platforms" section for more information.**

#CHLayoutManager

CHLayoutManager is a way to add positioning and sizing constraints on views.  The easiest way to understand this is with an example:

##Example

    [okButton setLayoutName:@"ok"];
    CHLayoutConstraint * stayToTheLeft = [CHLayoutConstraint constraintWithAttribute:CHLayoutConstraintAttributeMaxX relativeTo:@"ok" attribute:CHLayoutConstraintAttributeMinX offset:-10];
    [cancelButton addConstraint:stayToTheLeft];

Now, whenever `okButton` is resized or moved, `cancelButton` will be automatically moved to have its right edge positioned 10 pixels to the left of `okButton`'s left edge.

##Usage

In order to use CHLayoutManager in your app, copy these 7 files into your project:

- `CHLayout.h`
- `CHLayoutManager.h`
- `CHLayoutManager.m`
- `CHLayoutConstraint.h`
- `CHLayoutConstraint.m`
- `NSView+CHLayout.h`
- `NSView+CHLayout.m`

Then `#import "CHLayout.h"` in any .m file that needs to apply constraints to views.

##Improvements over `CAConstraint`

- `CHLayoutConstraints` support all the features of `CAConstraints`
- `CHLayoutConstraints` allow you to specify an `NSValueTransformer` in order to do more complex transformations.
- `CHLayoutConstraints` allow you to specify a block in order to do more complex transformations.
- `CHLayoutConstraints` allow you to bind point and rect values, in addition to scalar values.

(The included sample application shows how to use a `CHLayoutTransformer` block in order to apply constraints that are not possible via the normal mechanism.)

##Supported Platforms

- Mac OS X 10.5 - 10.6.

`CHLayoutManager` will not be supported beyond 10.6.  `CHLayoutManager` will work on 10.7, but it is recommended that you use the layout system in 10.7 as opposed to this.  While they are compatible, the mechanism in 10.7 is far more flexible.

##Special Considerations

- It's possible to set up circular dependencies on constraints.  Do so at your own risk.
- In order to constrain a view to its superview, create a constraint with the `sourceName` of `@"superview"`.
- It's very easy to create a [retain cycle][retain-cycle] if you use a block transformer that references `self` in a constraint, and then have `self` retain the constraint.  ([Blocks retain objects that they capture][block-retain])
- You may add as many constraints to a view as you like.  If a view has multiple constraints on the same attributed, they will all be evaluated in the order they were added.  Beware.
- If you are manually managing your memory (ie, not using garbage collection), then it is recommend that you use `[myView removeAllConstraints]` before the view is deallocated.  Doing so will ensure that all constraints and value transformers associated with that view are properly cleaned up.  If you are using garbage collection, these will be cleaned up for you.
- Transformations (scale+offset, `NSValueTransformer`, and blocks-based) are only applied to scalar attributes.  They are not applied to point- or rect-based attributes.
- You cannot constrain an attribute to another attribute of a different type.  In other words, you must constrain a scalar to a scalar, a point to a point, and a rect to a rect.

##License

CHLayoutManager is licensed under the MIT license, which is reproduced in its entirety here:

>Copyright (c) 2011 Dave DeLong
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in
>all copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>THE SOFTWARE.


  [retain-cycle]: http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmObjectOwnership.html#//apple_ref/doc/uid/20000043-1000810
  [block-retain]: http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/Blocks/Articles/bxVariables.html#//apple_ref/doc/uid/TP40007502-CH6-SW4