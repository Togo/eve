//
//  LearnedWindowController.h
//  EVE
//
//  Created by Tobias Sommer on 7/22/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@class AppDelegate;

@interface LearnedWindowController : NSWindowController {
        AppDelegate     *sharedAppDelegate;
}


-(IBAction) closeButton:(id) sender;

-(IBAction) globalButton:(id) sender;

-(IBAction) applicationButton:(id) sender;

- (void) setAppDelegate:(AppDelegate*) appDelegate;

@end
