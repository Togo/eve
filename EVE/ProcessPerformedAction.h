//
//  ProcessPerformedAction.h
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/3/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ProcessPerformedAction.h"
#import "UIElementUtilities.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface ProcessPerformedAction : NSObject {

}

// Methods*
+ (void)treatPerformedAction: (NSEvent*)mouseEvent:(AXUIElementRef)currentUIElement;

+ (NSString*) composeShortcut: (AXUIElementRef) elementRef;

+ (void)showGrowlMessage:(NSString*) theShortcut;

@end
