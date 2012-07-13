/*
 UIElementUtilities.h
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


extern NSString *const UIElementUtilitiesNoDescription;

@interface UIElementUtilities : NSObject {}

#pragma mark -
// Screen geometry conversions
+ (CGPoint)carbonScreenPointFromCocoaScreenPoint:(NSPoint)cocoaPoint;

+ (Boolean) hasHotkey :(AXUIElementRef) menuItemRef;

+ (NSString*) readkAXAttributeString:(AXUIElementRef)element :(CFStringRef) kAXAttribute;

+ (NSString *)readApplicationName;

+ (NSString*) titleOfActionUniversal:(AXUIElementRef)element;

+ (NSDictionary*) createApplicationMenuBarShortcutDictionary: (AXUIElementRef) appRef;

+ (void) readAllMenuItems:(AXUIElementRef) menuBarItemRef :(NSMutableDictionary*) allMenuBarShortcutDictionary;

+ (void) addMenuItemToArray:(AXUIElementRef) menuItemRef :(NSMutableDictionary*) allMenuBarShortcutDictionary;
@end
