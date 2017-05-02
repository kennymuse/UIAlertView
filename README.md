# UIAlertView

This class wrap UIAlertView (deprecated from iOS 9) and use the new UIAlertController class if the iOS is major of 8. 

This is transparently to the programmer hence is sufficient import this classes. An example of use is into the project. 



The utility of this classes is when in a old project there are more UIAlertView to change.

I had to replace them on a very large project (many UIAlertViews) because there were unexpected graphic effects (flickering, etc.). The 

warnings remain but they can be hidden forcibly.



HOW TO USE:

Import the classes in the Xcode project; then write #import "UIAlertView+Extension.h":

- once in the pch of the project 
- or in every view controller
