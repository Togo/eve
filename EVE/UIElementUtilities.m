/*
     File: UIElementUtilities.m 
 Abstract: Utility methods to manage AXUIElementRef instances.
  
  Version: 1.4 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

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
