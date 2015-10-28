//
//  NSObject+SwizzleInterface.h
//  
//
//  Created by Dario Trisciuoglio on 04/10/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SwizzleInterface)

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end
