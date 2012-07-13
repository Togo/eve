//
//  GrowlLearnShortcuts.m
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/4/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "GrowlLearnShortcuts.h"
#import "AppDelegate.h"


@implementation GrowlLearnShortcuts

+ (void)showGrowlMessage:(NSString*) theShortcut {
  [GrowlApplicationBridge notifyWithTitle:@"Use The Shortcut..." description:theShortcut notificationName:@"EVEMessages" iconData:nil priority:1 isSticky:NO clickContext:NO];
  NSLog(@"Send message with Growl");

}

+ (void)initializeGrowl {
NSBundle *bundle = [NSBundle bundleForClass:[GrowlLearnShortcuts class]];
NSString *growlPath = [[bundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];

if(growlBundle && [growlBundle load]){
    [GrowlApplicationBridge setGrowlDelegate:(NSObject<GrowlApplicationBridgeDelegate>*)self];
}  else {
	NSLog(@"Could not load Growl.framework");}
}

@end
