/*
 ProcessPerformedAction.m
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


#import "AppDelegate.h"
#import "ProcessPerformedAction.h"
#import "UIElementUtilities.h"
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Constants.h"
#import <Carbon/Carbon.h>
#import <HIServices/AXUIElement.h>

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ProcessPerformedAction


+ (void)treatPerformedAction: (NSEvent*)mouseEvent:(AXUIElementRef)currentUIElement {
    NSString *actionTitle;
    NSString *applicationName = [NSString stringWithFormat:[UIElementUtilities readApplicationName]];
    NSString *theShortcutName = nil;
    
        
    DDLogInfo(@"Try to find a ActionName for the mouseClick in the Application: %@", applicationName);
    actionTitle = [UIElementUtilities titleOfActionUniversal:currentUIElement];

    DDLogInfo(@"ActionName: %@", actionTitle);
    
    if (actionTitle.length > 0) {
       
    NSDictionary *additionalApplicationShortcuts = [[shortcutDictionary valueForKey:applicationName] valueForKey:@"additionalShortcuts"];
    NSDictionary *globalAdditionalShortcuts = [[shortcutDictionary valueForKey:applicationName] valueForKey:@"global"];
    
    if ([additionalApplicationShortcuts valueForKey:actionTitle]){
        theShortcutName = [additionalApplicationShortcuts valueForKey:actionTitle];
        DDLogInfo(@"I found a Shortcut in the AdditionialDictionary: %@", actionTitle);
    }
    else if([globalAdditionalShortcuts valueForKey:actionTitle])
    {
        theShortcutName = [globalAdditionalShortcuts valueForKey:actionTitle];
        DDLogInfo(@"I found a Shortcut in the Global Dictionary: %@", actionTitle);
    }
    else 
    {
        NSDictionary *applicationShortcuts = [NSDictionary dictionaryWithDictionary:[[shortcutDictionary valueForKey:applicationName] valueForKey:@"menuBarShortcuts"]];
        AXUIElementRef elementRef = (__bridge AXUIElementRef)[applicationShortcuts valueForKey:actionTitle];
        
        if (elementRef != nil) {            
            theShortcutName = [NSString stringWithFormat:[self composeShortcut:elementRef]];
            DDLogInfo(@"I found a Shortcut in the MenuBarDictionary: %@", actionTitle);
        }
        else {
            DDLogError(@"No Shortcut in MenuBarDictionaryFound or additionalShortcuDictionary found: %@", actionTitle);
    //       DDLogInfo(@"menuBar Shortcuts %@", applicationShortcuts);
    //       DDLogInfo(@"additional Application Shortcuts %@", additionalApplicationShortcuts);
    //       DDLogInfo(@"global Shortcuts %@", globalAdditionalShortcuts);
    //       DDLogInfo(@"ActionName: %@", actionTitle);
        }
    }
    
    if (theShortcutName.length > 0) {
        DDLogInfo(@"Matched Shortcut: %@", theShortcutName);
        [self showGrowlMessage:theShortcutName];
    }
  }
    else 
    {
        DDLogError(@"I can't find anything for: %@", actionTitle);
    }
}


+ (NSString*) composeShortcut: (AXUIElementRef) elementRef {
    enum {
        kMenuNoModifiers              = 0,    /* Mask for no modifiers*/
        kMenuShiftModifier            = (1 << 0), /* Mask for shift key modifier*/
        kMenuOptionModifier           = (1 << 1), /* Mask for option key modifier*/
        kMenuControlModifier          = (1 << 2), /* Mask for control key modifier*/
        kMenuNoCommandModifier        = (1 << 3) /* Mask for no command key modifier*/
    };

    NSString *theShortcut = [NSString stringWithFormat:@""];
    CFStringRef cmdCharRef;
    CFStringRef cmdVirtualKeyRef;
    CFNumberRef cmdModifiersRef;
    

    AXUIElementCopyAttributeValue((AXUIElementRef) elementRef, (CFStringRef) kAXMenuItemCmdVirtualKeyAttribute, (CFTypeRef*) &cmdVirtualKeyRef);
    AXUIElementCopyAttributeValue((AXUIElementRef) elementRef, (CFStringRef) kAXMenuItemCmdModifiersAttribute, (CFTypeRef*) &cmdModifiersRef);    
    AXUIElementCopyAttributeValue((AXUIElementRef) elementRef, (CFStringRef) kAXMenuItemCmdCharAttribute,  (CFTypeRef*) &cmdCharRef);
    
    NSString *cmdChar =       (__bridge_transfer NSString*) cmdCharRef;
    NSString *cmdVirtualKey = (__bridge_transfer NSString*) cmdVirtualKeyRef;
    NSNumber *cmdModifiers =  (__bridge_transfer NSNumber*) cmdModifiersRef;
    
    
    if ( ([cmdModifiers intValue] & kMenuNoCommandModifier) == 0 )
    {
        DDLogInfo(@"No Command Modifier");
        theShortcut = [theShortcut stringByAppendingString:@"Command "];
    }
    
    if (cmdChar != nil || cmdVirtualKey != nil ) {
        if ( ([cmdModifiers intValue] & kMenuControlModifier) != 0 )
        {
            DDLogInfo(@"Control Modifier");
            theShortcut = [theShortcut stringByAppendingString:@"Control "];
        }
    
        if ( ([cmdModifiers intValue] & kMenuOptionModifier) != 0 )
        {
            DDLogInfo(@"Option Modifier");
            theShortcut = [theShortcut stringByAppendingString:@"Option "];
        }
    
        if ( ([cmdModifiers intValue] & kMenuShiftModifier) != 0 )
        {
            DDLogInfo(@"Shift Modifier");
            theShortcut = [theShortcut stringByAppendingString:@"Shift "];
        }

    
    
    if (cmdVirtualKey != 0) {
        NSString *virtualCmdChar = nil;
        switch ([cmdVirtualKey intValue]) {
            case 48: virtualCmdChar = @" Tab"; break;
            case 49: virtualCmdChar = @" Space"; break;
            case 50: virtualCmdChar = @" `"; break;
            case 51: virtualCmdChar = @" Delete"; break;
            case 52: virtualCmdChar = @" Enter"; break;
            case 53: virtualCmdChar = @" Escape"; break;
            default:
            break;
        }
        theShortcut = [theShortcut stringByAppendingString:virtualCmdChar];
        DDLogInfo(@"Virtual Command Key: %@", virtualCmdChar);
    }
    else 
    {
        theShortcut = [theShortcut stringByAppendingString:cmdChar];
    }
    }
        
    return theShortcut;
}

+ (void)showGrowlMessage:(NSString*) theShortcut {
    if (![theShortcut isEqualToString:lastSendedShortcut]) {
        
        [GrowlApplicationBridge notifyWithTitle:@"" description:theShortcut notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:@"launchNotifyClick"];
        
        lastSendedShortcut = theShortcut;
        
    }
    else {
        DDLogInfo(@"This Shortcut has already been send. Don't bother me!!!");
    }
    
}

@end

