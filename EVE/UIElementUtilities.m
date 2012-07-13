/*
 UIElementUtilities.m
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

#import "UIElementUtilities.h"
#import "AppDelegate.h"

NSString *const UIElementUtilitiesNoDescription = @"No Description";

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation UIElementUtilities


#pragma mark -

// Flip coordinates

+ (CGPoint)carbonScreenPointFromCocoaScreenPoint:(NSPoint)cocoaPoint {
    NSScreen *foundScreen = nil;
    CGPoint thePoint;
    
    for (NSScreen *screen in [NSScreen screens]) {
	if (NSPointInRect(cocoaPoint, [screen frame])) {
	    foundScreen = screen;
	}
    }

    if (foundScreen) {
	CGFloat screenHeight = [foundScreen frame].size.height;
	
	thePoint = CGPointMake(cocoaPoint.x, screenHeight - cocoaPoint.y - 1);
    } else {
	thePoint = CGPointMake(0.0, 0.0);
    }

    return thePoint;
}



+ (NSString *)readApplicationName {
    return [[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationName"];
}

+ (NSDictionary*) createApplicationMenuBarShortcutDictionary: (AXUIElementRef) appRef {
    NSMutableDictionary *allMenuBarShortcutDictionary = [[NSMutableDictionary alloc] init];
    
    // Read the menuBar of the actual Application
    CFTypeRef menuBarRef;
    AXUIElementCopyAttributeValue(appRef, kAXMenuBarAttribute, (CFTypeRef*)&menuBarRef);
    
    if (menuBarRef != nil) {
        CFArrayRef menuBarArrayRef;
        AXUIElementCopyAttributeValue(menuBarRef, kAXChildrenAttribute, (CFTypeRef*) &menuBarArrayRef);
        NSArray *menuBarItems = CFBridgingRelease(menuBarArrayRef);
        
        for (id menuBarItemRef in menuBarItems) {
        [self readAllMenuItems :(AXUIElementRef)menuBarItemRef :allMenuBarShortcutDictionary];
        }
    }
    
    if(menuBarRef){
    CFRelease(menuBarRef);        
    }

    return allMenuBarShortcutDictionary;
}
    
+ (void) readAllMenuItems:(AXUIElementRef) menuBarItemRef :(NSMutableDictionary*) allMenuBarShortcutDictionary {
    CFArrayRef childrenArrayRef = NULL;
    AXUIElementCopyAttributeValue(menuBarItemRef, kAXChildrenAttribute, (CFTypeRef*) &childrenArrayRef);
    NSArray *childrenArray = CFBridgingRelease(childrenArrayRef);
    
    if (childrenArray.count > 0) {
        for (id oneChildren in childrenArray) {
            [self readAllMenuItems:(AXUIElementRef)oneChildren :allMenuBarShortcutDictionary ];
        }
    }
    else {
        [self addMenuItemToArray:(AXUIElementRef) menuBarItemRef :allMenuBarShortcutDictionary ];
    }
}

+ (void) addMenuItemToArray:(AXUIElementRef) menuItemRef :(NSMutableDictionary*) allMenuBarShortcutDictionary  {  
    
    NSString *title = [self readkAXAttributeString:menuItemRef :kAXTitleAttribute];
    
    if(title.length > 0 && [self hasHotkey:(AXUIElementRef) menuItemRef])
    {	
        NSString *titleLowercase = [NSString stringWithFormat:[title lowercaseString]];
        if([titleLowercase rangeOfString:@" “"].length > 0) {
            titleLowercase = [titleLowercase substringToIndex:[titleLowercase rangeOfString:@" “"].location];
        } else if([titleLowercase rangeOfString:@" „"].length > 0) {
            titleLowercase = [titleLowercase substringToIndex:[titleLowercase rangeOfString:@" „"].location];
        }
        [allMenuBarShortcutDictionary setValue:(__bridge id)menuItemRef forKey:titleLowercase];
    }
}

+ (Boolean) hasHotkey :(AXUIElementRef) menuItemRef {
    CFNumberRef  cmdCharRef;
    CFNumberRef  cmdVirtualKeyRef;
    
    AXUIElementCopyAttributeValue((AXUIElementRef) menuItemRef, (CFStringRef) kAXMenuItemCmdCharAttribute, (CFTypeRef*) &cmdCharRef);
    AXUIElementCopyAttributeValue((AXUIElementRef) menuItemRef, (CFStringRef) kAXMenuItemCmdVirtualKeyAttribute, (CFTypeRef*) &cmdVirtualKeyRef);

    NSNumber *cmdChar =        (__bridge_transfer NSNumber*) cmdCharRef;
    NSNumber *cmdVirtualKey =  (__bridge_transfer NSNumber*) cmdVirtualKeyRef;
    
 if( cmdChar > 0 || cmdVirtualKey > 0 ) 
 {
     return true;
    }
    else 
    {
        return false;
    }
}

+ (NSString*) titleOfActionUniversal:(AXUIElementRef)element {   
    NSString* actionTitle;
    

        actionTitle = [self readkAXAttributeString:element :kAXTitleAttribute];
        
        if (actionTitle == NULL || actionTitle.length == 0) 
        {
            actionTitle = [self readkAXAttributeString:element :kAXDescriptionAttribute];
        } 
        if (actionTitle == NULL || actionTitle.length == 0) 
        {
            actionTitle = [self readkAXAttributeString:element :kAXHelpAttribute];
        } 
        if (actionTitle == NULL || actionTitle.length == 0) 
        {
            actionTitle = [self readkAXAttributeString:element :kAXRoleDescriptionAttribute];
        }
        
        actionTitle = [actionTitle lowercaseString];
        if(([actionTitle rangeOfString:@" “"].length > 0)) {
            actionTitle = [actionTitle substringToIndex:[actionTitle rangeOfString:@" “"].location];
        }
        else if (([actionTitle rangeOfString:@" „"].length > 0)) {
            actionTitle = [actionTitle substringToIndex:[actionTitle rangeOfString:@" „"].location];
        }
    
    return actionTitle;
}

+ (NSString*) readkAXAttributeString:(AXUIElementRef)element :(CFStringRef) kAXAttribute {
    CFStringRef stringRef;
    
    AXUIElementCopyAttributeValue( element, (CFStringRef) kAXAttribute, (CFTypeRef*) &stringRef );
//    NSString  *attribute = (__bridge_transfer NSString*) stringRef;
    
    //DDLogInfo(@"Read the %@: %@",kAXAttribute,  attribute);
    return (__bridge_transfer NSString*) stringRef;
}


@end
