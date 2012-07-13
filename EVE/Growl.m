//
//  Growl.m
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/4/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "Growl.h"
#import "AppDelegate.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation Growl

+ (void)showGrowlMessage:(NSString*) theShortcut {
    if (![theShortcut isEqualToString:lastSendedShortcut]) {
    
     [GrowlApplicationBridge notifyWithTitle:@"" description:theShortcut notificationName:@"EVE" iconData:nil priority:1 isSticky:NO clickContext:FALSE];
    
    lastSendedShortcut = theShortcut;

    }
    else {
      DDLogInfo(@"This Shortcut has already been send. Don't bother me!!!");
    }

}

+ (void)initializeGrowl {
NSBundle *bundle = [NSBundle bundleForClass:[Growl class]];
NSString *growlPath = [[bundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];

if(growlBundle && [growlBundle load]){
[GrowlApplicationBridge setGrowlDelegate:nil];
    DDLogInfo(@"Load Growl Framework");
}  else {
	DDLogError(@"Could not load Growl.framework");}
}

@end
