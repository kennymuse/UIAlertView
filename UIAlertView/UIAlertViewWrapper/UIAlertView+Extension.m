//
//  UIAlertView+Extension.h
//  UIAlertView
//
//  Created by Enrico De Michele on 28/10/15.
//  Copyright © 2015 Enrico De Michele. All rights reserved.
//

#import "UIAlertView+Extension.h"
#import "NSObject+SwizzleInterface.h"
#import "UIAlertActionTag.h"
#import <objc/runtime.h>

#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation UIAlertController (Extension)

@dynamic delegate;

- (void)setDelegate:(id<UIAlertViewDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id)delegate {
    return objc_getAssociatedObject(self, @selector(delegate));
}

- (NSUInteger) tag {
    return self.view.tag;
}

- (void) setTag:(NSUInteger)tag {
    [self.view setTag: tag];
}

- (NSInteger)addButtonWithTitle:(nullable NSString *)title {    // returns index of button. 0 based.
    
    UIAlertActionTag *actionButton = [UIAlertActionTag actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertActionTag *alertAction = (UIAlertActionTag *)action;
        
        if([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
            [self.delegate alertView:(UIAlertView *)self clickedButtonAtIndex: alertAction.index];
        
        if([self.delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
            [self.delegate alertView:(UIAlertView *)self willDismissWithButtonIndex: alertAction.index];
        
        if([self.delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
            [self.delegate alertView:(UIAlertView *)self didDismissWithButtonIndex: alertAction.index];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self addAction: actionButton];
    
    NSInteger nButton = [[self actions] count];
    [actionButton setIndex: (int)nButton];
    
    return nButton;
}

- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {

    NSInteger nButton = [[self actions] count];
    
    if (buttonIndex < nButton) {
        return [[[self actions] objectAtIndex: buttonIndex] title];
    }
    
    return nil;
}

- (NSInteger) numberOfButtons {

    NSInteger nButton = [[self actions] count];
    return nButton;
}

- (void)setCancelButtonIndex:(NSInteger)index {

    NSLog(@"setCancelButtonIndex Not handled");
}

- (NSInteger) cancelButtonIndex {

    NSLog(@"cancelButtonIndex Not handled");
    
    return 0;
}

- (NSInteger) firstOtherButtonIndex { // -1 if no otherButtonTitles or initWithTitle:... not used
    
    NSLog(@"firstOtherButtonIndex Not handled");
    
    return -1;
}

- (BOOL) visible {

    return YES;
}

- (UIViewController *)currentTopViewController {
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

- (void) show {
    
    if([self.delegate respondsToSelector:@selector(willPresentAlertView:)])
        [self.delegate willPresentAlertView:(UIAlertView *)self];
    
    UIViewController *viewController = [self currentTopViewController];
    [viewController presentViewController:(UIAlertController *)self animated:YES completion:^{
        
        if([self.delegate respondsToSelector:@selector(didPresentAlertView:)])
            [self.delegate didPresentAlertView:(UIAlertView *)self];
    }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {

    NSLog(@"dismissWithClickedButtonIndex Not handled");
}

@end

///

@implementation UIAlertView (Extension)

#pragma mak - Swizzle Method

+(void)load {
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        
        [self swizzleMethod:@selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:) withMethod:@selector(fllInitWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:) error:NULL];
    });
}

- (instancetype)fllInitWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    
    NSMutableArray *otherButtonTitlesArray = [NSMutableArray array];
    
    if (otherButtonTitles != nil) {
        [otherButtonTitlesArray addObject:otherButtonTitles];
        
        va_list args;
        va_start(args, otherButtonTitles);
        NSString * title = nil;
        
        while ((title = va_arg(args, NSString *))) {
            [otherButtonTitlesArray addObject:title];
        }
        va_end(args);
    }
    
    ///
    
    if (SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        
        UIAlertView *alertView = [self fllInitWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        
        for (NSString *buttonTitle in otherButtonTitlesArray) {
            [alertView addButtonWithTitle:buttonTitle];
        }
        
        return alertView;
        
    } else {
    
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController setDelegate: delegate];
        
        ///
        
        int index = 0;
        UIAlertActionTag *actionCancel = nil;
        
        if (cancelButtonTitle != nil) {
            
            actionCancel = [UIAlertActionTag actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIAlertActionTag *alertAction = (UIAlertActionTag *)action;
                
                if([delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                    [delegate alertView:(UIAlertView *)alertController clickedButtonAtIndex: alertAction.index];
                
                if([delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
                    [delegate alertView:(UIAlertView *)alertController willDismissWithButtonIndex: alertAction.index];
                
                if([delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
                    [delegate alertView:(UIAlertView *)alertController didDismissWithButtonIndex: alertAction.index];
                
                if([delegate respondsToSelector:@selector(alertViewCancel:)])
                    [delegate alertViewCancel:(UIAlertView *)alertController];
                
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [actionCancel setIndex: index++];
        }

        for (NSString *buttonTitle in otherButtonTitlesArray) {
            
            UIAlertActionTag *actionButton = [UIAlertActionTag actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIAlertActionTag *alertAction = (UIAlertActionTag *)action;
                
                if([delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
                    [delegate alertView:(UIAlertView *)alertController clickedButtonAtIndex: alertAction.index];
                
                if([delegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
                    [delegate alertView:(UIAlertView *)alertController willDismissWithButtonIndex: alertAction.index];
                
                if([delegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
                    [delegate alertView:(UIAlertView *)alertController didDismissWithButtonIndex: alertAction.index];
                
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [actionButton setIndex: index++];
            [alertController addAction: actionButton];
        }
        
        if (actionCancel != nil) {
            [alertController addAction: actionCancel];
        }
        
        return (UIAlertView *)alertController;
    }
}

@end
