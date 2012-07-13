//
//  MenuBarIcon.h
//  EVE
//
//  Created by Tobias Sommer on 6/13/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface MenuBar : NSObject {
    IBOutlet NSMenu  *theMenu;
    NSStatusItem *statusItem;
    IBOutlet NSMenuItem *PauseMenuItem;
}

- (IBAction)exitProgram:(id)sender;
- (IBAction)contactMe:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)showAboutBox:(id)sender;

@end
