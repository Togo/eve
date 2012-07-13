/*
 AppDelegate.m
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


#import <Cocoa/Cocoa.h>
#import <AppKit/NSAccessibility.h>
#import <Carbon/Carbon.h>
#import "AppDelegate.h"
#import "UIElementUtilities.h"

#import "ProcessPerformedAction.h"

NSMutableDictionary  *shortcutDictionary;
NSImage              *eve_icon;
NSString             *preferredLang;
NSInteger            appPause;
NSPopover            *popover;
NSString             *lastSendedShortcut;

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)note {
    
    // We first have to check if the Accessibility APIs are turned on.  If not, we have to tell the user to do it (they'll need to authenticate to do it).  If you are an accessibility app (i.e., if you are getting info about UI elements in other apps), the APIs won't work unless the APIs are turned on.	
    if (!AXAPIEnabled())
    {
    
	NSAlert *alert = [[NSAlert alloc] init];
	
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert setMessageText:@"EVE requires that the Accessibility API be enabled."];
	[alert setInformativeText:@"Would you like to launch System Preferences so that you can turn on \"Enable access for assistive devices\"?"];
	[alert addButtonWithTitle:@"Open System Preferences"];
	[alert addButtonWithTitle:@"Continue Anyway"];
	[alert addButtonWithTitle:@"Quit UI"];
	
	NSInteger alertResult = [alert runModal];
	        
        switch (alertResult) {
            case NSAlertFirstButtonReturn: {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSPreferencePanesDirectory, NSSystemDomainMask, YES);
		if ([paths count] == 1) {
		    NSURL *prefPaneURL = [NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"UniversalAccessPref.prefPane"]];
		    [[NSWorkspace sharedWorkspace] openURL:prefPaneURL];
		}		
	    }
		break;
                
            case NSAlertSecondButtonReturn: // just continue
            default:
                break;
		
            case NSAlertThirdButtonReturn:
                [NSApp terminate:self];
                return;
                break;
        }
        
        
    }
    
    _systemWideElement = AXUIElementCreateSystemWide();
    
    shortcutDictionary = [[NSMutableDictionary alloc] init]; 
    
    // Language
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    preferredLang = [languages objectAtIndex:0];
    DDLogInfo(@"Language: %@", preferredLang);
    
    [self registerGlobalMouseListener];
    [self registerAppFrontSwitchedHandler];
    [self registerAppLaunchedHandler];
    
    
    // Logging Framework
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.maximumFileSize = (3024 * 3024);
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    
    [DDLog addLogger:fileLogger];
    
    
    // Growl
//        [Growl initializeGrowl];
        [GrowlApplicationBridge setGrowlDelegate:self];
            DDLogInfo(@"Load Growl Framework");
       
    
    

    
}


-(void)growlNotificationWasClicked:(id)clickContext{ // a Growl delegate method, called when a notification is clicked. Check the value of the clickContext argument to determine what to do
    if([clickContext isEqualToString:@"launchNotifyClick"]){
        NSLog(@"ClickContext successfully received!");
    }
}

- (BOOL) hasNetworkClientEntitlement {
    return TRUE;
    }


#pragma mark -

// -------------------------------------------------------------------------------
//	setCurrentUIElement:uiElement
// -------------------------------------------------------------------------------
- (void)setCurrentUIElement:(AXUIElementRef)uiElement
{   
    _currentUIElement = uiElement;
}

// -------------------------------------------------------------------------------
//	currentUIElement:
// -------------------------------------------------------------------------------
- (AXUIElementRef)currentUIElement
{
    return _currentUIElement;
}


// -------------------------------------------------------------------------------
//	updateCurrentUIElement:
// -------------------------------------------------------------------------------
- (void)updateCurrentUIElement
{
    
        // The current mouse position with origin at top right.
	   NSPoint cocoaPoint = [NSEvent mouseLocation];
	        
        // Only ask for the UIElement under the mouse if has moved since the last check.
        if (!NSEqualPoints(cocoaPoint, _lastMousePoint)) {

	    CGPoint pointAsCGPoint = [UIElementUtilities carbonScreenPointFromCocoaScreenPoint:cocoaPoint];

           AXUIElementRef newElement;
	    
	    /* If the interaction window is not visible, but we still think we are interacting, change that */
            if (_currentlyInteracting) {
                _currentlyInteracting = ! _currentlyInteracting;
            }

            // Ask Accessibility API for UI Element under the mouse
            // And update the display if a different UIElement
            if (AXUIElementCopyElementAtPosition( _systemWideElement, pointAsCGPoint.x, pointAsCGPoint.y, &newElement ) == kAXErrorSuccess
                && newElement
                && ([self currentUIElement] == NULL || ! CFEqual( [self currentUIElement], newElement ))) {

                [self setCurrentUIElement:newElement];
            }
            
            _lastMousePoint = cocoaPoint;
        }
}

// -------------------------------------------------------------------------------
//
// -------------------------------------------------------------------------------
- (void)registerGlobalMouseListener
{
    [NSEvent addGlobalMonitorForEventsMatchingMask:(NSLeftMouseUp)
                                                           handler:^(NSEvent *incomingEvent) {   
                            
                                                               if(!appPause) {
                                                            
                                                                   
                                                                   // listing important
                                                                  
                                                                   [self updateCurrentUIElement];
                                                                 
                                                                   
                                                                   if([self currentUIElement])
                                                                 {
                                                                   // Filter to do not to much work
                                                                   
                                                                     NSString* role = [UIElementUtilities readkAXAttributeString:[self currentUIElement] :kAXRoleAttribute];
                                                                     if ( [role isEqualToString:(NSString*)kAXButtonRole] 
                                                                       || [role isEqualToString:(NSString*)kAXTextFieldRole] 
                                                                       || [role isEqualToString:(NSString*)kAXCheckBoxRole] 
                                                                       || [role isEqualToString:(NSString*)kAXMenuButtonRole] 
                                                                       || [role isEqualToString:(NSString*)kAXMenuItemRole]) 
                                                                   {
                                                                   [ProcessPerformedAction treatPerformedAction:incomingEvent :_currentUIElement];
                                                                   }
                                                                   else 
                                                                   {
                                                                       DDLogInfo(@"UIElement not in the Filter: %@", role);
                                                               }
                                                            }
                                                          }
                                                        }];
    
}

- (void) registerAppFrontSwitchedHandler {
    EventTypeSpec spec = { kEventClassApplication,  kEventAppFrontSwitched };
    OSStatus err = InstallApplicationEventHandler(NewEventHandlerUPP(AppFrontSwitchedHandler), 1, &spec, (__bridge void*)self, NULL);
    
    if (err)
        DDLogError(@"Could not install event handler");
}


- (void) registerAppLaunchedHandler {
    EventTypeSpec spec = { kEventClassApplication,  kEventAppLaunched };
    OSStatus err = InstallApplicationEventHandler(NewEventHandlerUPP(AppLaunchedHandler), 1, &spec, (__bridge void*)self, NULL);    
    if (err)
        DDLogError(@"Could not install event handler");
}


- (void) appFrontSwitched {
      if(!appPause) {
        // Release the Memory
        [[shortcutDictionary valueForKey:@"menuBarShortcuts"] removeAllObjects];
        [[shortcutDictionary valueForKey:@"additionalShortcuts"] removeAllObjects];
       
          
          NSString     *activeApplicationName = [NSString stringWithFormat:[UIElementUtilities readApplicationName]];
        DDLogInfo(@"Active Application: %@", activeApplicationName); 
    
          // Clear all Object to reload data
        [shortcutDictionary removeAllObjects];
        NSMutableDictionary *applicationShortcuts = [[NSMutableDictionary alloc] init];
        
        AXUIElementRef appRef = AXUIElementCreateApplication( [[[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationProcessIdentifier"] intValue] );
        
          
        NSDictionary *menuBarShortcuts   = [NSDictionary dictionaryWithDictionary:[UIElementUtilities createApplicationMenuBarShortcutDictionary:appRef]];
        NSString     *finalPath =  [[NSBundle mainBundle] pathForResource:@"AdditionalShortcuts"  ofType:@"plist" inDirectory:@""];
        NSDictionary *allAdditionalShortcuts = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
        
        NSDictionary *appAddinitionalShortcuts = [NSDictionary dictionaryWithDictionary:[[allAdditionalShortcuts valueForKey:preferredLang]  valueForKey:activeApplicationName]];
        NSDictionary *globalAddintionalShortcuts = [NSDictionary dictionaryWithDictionary:[[allAdditionalShortcuts valueForKey:preferredLang]  valueForKey:@"global"]];
        
          
        [applicationShortcuts setValue:menuBarShortcuts forKey:@"menuBarShortcuts"];
        [applicationShortcuts setValue:appAddinitionalShortcuts forKey:@"additionalShortcuts"];
        [applicationShortcuts setValue:globalAddintionalShortcuts forKey:@"global"];
        [shortcutDictionary setValue:applicationShortcuts forKey:activeApplicationName];
        
          
        DDLogInfo(@"ShortcutDictionary for %@ created", activeApplicationName); 
        DDLogInfo(@"I create a menuBarShortcutDictionary   with %lu Items", menuBarShortcuts.count);
        DDLogInfo(@"I read the app additional   Shortcuts  with %lu Items", appAddinitionalShortcuts.count);
        DDLogInfo(@"I read the global additional Shortcuts with %lu Items", globalAddintionalShortcuts.count);
        CFRelease(appRef);
    }
}

static OSStatus AppLaunchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData) {
    [(__bridge id)inUserData appFrontSwitched];
    return 0;
}


static OSStatus AppFrontSwitchedHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData) {
   [(__bridge id)inUserData appFrontSwitched];
    return 0;
}


@end