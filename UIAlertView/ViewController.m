//
//  ViewController.m
//  UIAlertView
//
//  Created by Enrico De Michele on 28/10/15.
//  Copyright © 2015 Enrico De Michele. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction) click:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Test" message:@"Test" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"OK 1", @"OK 2", @"OK 3", nil];
    [alertView setTag: 10];
    [alertView show];
}

///

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"clickedButtonAtIndex - alert tag %d", (int)alertView.tag);
    NSLog(@"clickedButtonAtIndex - clicked to alert %d", (int)buttonIndex);
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    
    NSLog(@"alertViewCancel - alert tag %d", (int)alertView.tag);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"willDismissWithButtonIndex - alert tag %d", (int)alertView.tag);
    NSLog(@"willDismissWithButtonIndex - clicked to alert %d", (int)buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSLog(@"didDismissWithButtonIndex - alert tag %d", (int)alertView.tag);
    NSLog(@"didDismissWithButtonIndex - clicked to alert %d", (int)buttonIndex);
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    NSLog(@"willPresentAlertView - alert tag %d", (int)alertView.tag);
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    
    NSLog(@"didPresentAlertView - alert tag %d", (int)alertView.tag);
}

#pragma mark non ancora gestiti da qui in giù

//Tanto comunque non viene gestito
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    
    NSLog(@"alertViewShouldEnableFirstOtherButton - alert tag %d", (int)alertView.tag);
    
    //YES if the button should be enabled, no if the button should be disabled.
    return YES;
}

@end
