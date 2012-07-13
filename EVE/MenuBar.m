/*
 MenuBar.m
 EVE
 
 Created by Tobias Sommer on 6/13/12.
 Copyright (c) 2012 Sommer. All rights reserved.
 
 This file is part of EVE.
 
 EVE is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 EVE is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with EVE.  If not, see <http://www.gnu.org/licenses/>. */

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