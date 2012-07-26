//
//  LearnedWindowController.m
//  EVE
//
//  Created by Tobias Sommer on 7/22/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "LearnedWindowController.h"
#import "DDLog.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation LearnedWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction) closeButton:(id) sender {
    [NSApp stopModal];
    DDLogInfo(@"Close the LearnedShortcut Window without doing anything!");
}

- (IBAction) globalButton:(id) sender {

    /* Get the Array with the shortcut from Growl */
    NSArray *clickContext = [sharedAppDelegate getClickContextArray];
    DDLogInfo(@"Got this Value to save: %@", clickContext);
    
    ApplicationData *applicationData = [sharedAppDelegate getApplicationData];
    NSMutableDictionary *applicationDataDictionary = [[sharedAppDelegate getApplicationData] getApplicationDataDictionary];
    NSMutableDictionary *learnedShortcuts = [applicationDataDictionary valueForKey:@"learnedShortcuts"];

    NSMutableDictionary *globalLearnedShortcuts = [learnedShortcuts valueForKey:@"systemWide"];
    
    /* add the Shortcut to the list */
    [globalLearnedShortcuts setValue:@"FALSE" forKey:[clickContext objectAtIndex:1]];
    
    [ApplicationData saveLearnedShortcutDictionary:applicationData :learnedShortcuts];
    
    [NSApp stopModal];
}

- (void) setAppDelegate:(AppDelegate*) appDelegate {
    sharedAppDelegate = appDelegate;
}

@end
