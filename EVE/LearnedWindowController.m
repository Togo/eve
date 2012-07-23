//
//  LearnedWindowController.m
//  EVE
//
//  Created by Tobias Sommer on 7/22/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "LearnedWindowController.h"
#import "AppDelegate.h"


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
}


- (IBAction) globalButton:(id) sender {
    NSLog(@"%@", clickContextArray);
    NSMutableDictionary *globalLearnedShortcuts = [[applicationData valueForKey:@"learnedShortcuts"] valueForKey:@"systemWide"];
    
    [globalLearnedShortcuts setValue:[clickContextArray objectAtIndex:1] forKey:[clickContextArray objectAtIndex:0]];
    
    // TODO Save the modified dictionary
    
    [NSApp stopModal];
}


- (void) setClickContextArray:(NSArray*) id {
    clickContextArray = id;
}

@end
