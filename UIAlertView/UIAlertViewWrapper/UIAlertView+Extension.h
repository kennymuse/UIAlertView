//
//  UIAlertView+Extension.h
//  UIAlertView
//
//  Created by Enrico De Michele on 28/10/15.
//  Copyright © 2015 Enrico De Michele. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extension)

@property(nullable,nonatomic,weak) id /*<UIAlertViewDelegate>*/ delegate;

- (NSUInteger) tag;
- (void) setTag:(NSUInteger)tag;

- (NSInteger)addButtonWithTitle:(nullable NSString *)title;    // returns index of button. 0 based.
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

- (NSInteger) numberOfButtons;

- (void)setCancelButtonIndex:(NSInteger)index;
- (NSInteger) cancelButtonIndex;

- (NSInteger) firstOtherButtonIndex; // -1 if no otherButtonTitles or initWithTitle:... not used

- (BOOL) visible;

- (void) show;

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end

///

@interface UIAlertView (Extension)

@end
