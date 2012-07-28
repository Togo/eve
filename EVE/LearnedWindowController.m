//
//  LearnedWindowController.m
//  EVE
//
//  Created by Tobias Sommer on 7/22/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "LearnedWindowController.h"
#import "DDLog.h"
#import "Constants.h"

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
    DDLogInfo(@"Closed the LearnedShortcut Window without doing anything!");
}

- (IBAction) globalButton:(id) sender {

    /* Get the Array with the shortcut from Growl */
    NSArray *clickContext = [sharedAppDelegate getClickContextArray];
    DDLogInfo(@"Got this Value to save in learnedShortcut(global): %@", clickContext);
    
    ApplicationData *applicationData = [sharedAppDelegate getApplicationData];
    NSMutableDictionary *applicationDataDictionary = [[sharedAppDelegate getApplicationData] getApplicationDataDictionary];
    NSMutableDictionary *learnedShortcutDictionary = [applicationDataDictionary valueForKey:learnedShortcuts];

    NSMutableDictionary *globalLearnedShortcuts = [learnedShortcutDictionary valueForKey:globalLearnedShortcut];
    
    /* add the Shortcut to the list */
    [globalLearnedShortcuts setValue:@"TRUE" forKey:[clickContext objectAtIndex:1]];
    
    [ApplicationData saveLearnedShortcutDictionary:applicationData :learnedShortcutDictionary];
    
    [NSApp stopModal];
}

- (IBAction) applicationButton:(id) sender {
    
    /* Get the Array with the shortcut from Growl */
    NSArray *clickContext = [sharedAppDelegate getClickContextArray];
    DDLogInfo(@"Got this Value to save in learnedShortcut(application): %@", clickContext);
    
    ApplicationData *applicationData = [sharedAppDelegate getApplicationData];
    NSMutableDictionary *applicationDataDictionary = [[sharedAppDelegate getApplicationData] getApplicationDataDictionary];
    NSMutableDictionary *learnedShortcutDictionary = [applicationDataDictionary valueForKey:learnedShortcuts];
    
    NSMutableDictionary *applicationLearnedShortcutDictionary = [learnedShortcutDictionary valueForKey:applicationLearnedShortcut];
    
    // If the Application not in the Dictionary add this, else load the Dictionary for this Application
    if (![applicationLearnedShortcutDictionary valueForKey:[clickContext objectAtIndex:2]]) {
        NSMutableDictionary *newApplicationDictionary = [[NSMutableDictionary alloc] init];
        [applicationLearnedShortcutDictionary setValue:newApplicationDictionary forKey:[clickContext objectAtIndex:2]];
    }

    NSMutableDictionary *theLearnedApplicationDictonary = [applicationLearnedShortcutDictionary valueForKey:[clickContext objectAtIndex:2]];
    /* add the Shortcut to the list */
    [theLearnedApplicationDictonary setValue:@"TRUE" forKey:[clickContext objectAtIndex:1]];
    
    [ApplicationData saveLearnedShortcutDictionary:applicationData :learnedShortcutDictionary];
    
    [NSApp stopModal];
}



- (void) setAppDelegate:(AppDelegate*) appDelegate {
    sharedAppDelegate = appDelegate;
}

@end
