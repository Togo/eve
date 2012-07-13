//
//  MenuBarIcon.m
//  EVE
//
//  Created by Tobias Sommer on 6/13/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "MenuBar.h"
#import "AppDelegate.h"
#import "Constants.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation MenuBar


-(void)awakeFromNib{
    // Init Global Icon
    eve_icon = [NSImage imageNamed:@"eve_icon.icns"];
    [eve_icon setSize:NSMakeSize(18, 18)];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:theMenu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:eve_icon];
    
    [PauseMenuItem setState:NSOffState];
}

// Actions
- (IBAction)exitProgram:(id)sender {
    DDLogInfo(@"exit Program");
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}

- (IBAction)contactMe:(id)sender {
    DDLogInfo(@"Contact Me!");
    NSString* subject = [NSString stringWithFormat:@"Found a bug, or have suggestions?"];
    NSString* body = [NSString stringWithFormat:@""];
    NSString* to = eveEmailAddresse;
    
    NSString *encodedSubject = [NSString stringWithFormat:@"SUBJECT=%@", [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedBody = [NSString stringWithFormat:@"BODY=%@", [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *encodedTo = [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedURLString = [NSString stringWithFormat:@"mailto:%@?%@&%@", encodedTo, encodedSubject, encodedBody];
    NSURL *mailtoURL = [NSURL URLWithString:encodedURLString];
    
    [[NSWorkspace sharedWorkspace] openURL:mailtoURL];
}

- (IBAction)pause:(id)sender {
    DDLogInfo(@"Pause EVE");
    if ([sender state] == NSOffState) {
        [sender setState:NSOnState];
    } else {
        [sender setState:NSOffState];
    }
    appPause = [sender state];
}

- (IBAction)showAboutBox:(id)sender {
    DDLogInfo(@"show About Box");
    [NSApp orderFrontStandardAboutPanel:sender];
}

@end