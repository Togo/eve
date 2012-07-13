//
//  AppDelegate.h
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/9/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HIServices/Accessibility.h>
#import <Growl/Growl.h>

#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"


@class OptionsWindowController;

@interface AppDelegate : NSObject <GrowlApplicationBridgeDelegate>{
    
    IBOutlet NSMenu  *theMenu;
    NSStatusItem *theItem;
    

    AXUIElementRef			    _systemWideElement;
    NSPoint                     _lastMousePoint;

    AXUIElementRef			    _currentUIElement;
    BOOL                        _currentlyInteracting;
    BOOL                        _highlightLockedUIElement;
    
}   

extern NSMutableDictionary            *shortcutDictionary;
extern NSImage                 *eve_icon;
extern NSString                *preferredLang;
extern NSPopover               *popover;
extern NSInteger                appPause;
extern NSString                *lastSendedShortcut;


- (void)setCurrentUIElement:(AXUIElementRef)uiElement;
- (AXUIElementRef)currentUIElement;

- (void) updateCurrentUIElement;

- (void) registerGlobalMouseListener;

- (void) registerAppFrontSwitchedHandler;

- (void) registerAppLaunchedHandler;

- (void) appFrontSwitched;

- (BOOL) hasNetworkClientEntitlement;

@end
