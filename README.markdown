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

##Supported Platforms

- Mac OS X 10.5+

##Special Considerations

- It's possible to set up circular dependencies on constraints.  Do so at your own risk.
- In order to constrain a view to its superview, create a constraint with the `sourceName` of `@"superview"`.

##Improvements over `CAConstraint` objects

- `CHLayoutConstraints` support all the features of `CAConstraints`
- `CHLayoutConstraints` allow you to specify an `NSValueTransformer` in order to do more complex transformations.
- `CHLayoutConstraints` allow you to specify a block in order to do more complex transformations.

(The included sample application shows how to use a `CHLayoutTransformer` block in order to apply constraints that are not possible via the normal mechanism.)

##License

CHLayoutManager is licensed under the MIT license, which is reproduced in its entirety here:

>Copyright (c) 2010 Dave DeLong
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
