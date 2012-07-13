//
//  GrowlLearnShortcuts.h
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/4/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Growl/Growl.h>

@interface Growl : NSObject <GrowlApplicationBridgeDelegate> 

+ (void)showGrowlMessage:(NSString*) theShortcut;

+ (void)initializeGrowl;

@end
