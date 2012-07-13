//
//  Dictionary.m
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/5/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "AllApplicationDictionary.h"
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@implementation AllApplicationDictionary

- (id)init {
    
    if(self) {
        [super init];
    }
    return self;
}

- (void)dealloc {
    [allApplicationDictionary dealloc];
    [super dealloc]; 
}

+ (NSMutableDictionary*)getHeadDataDictionary:(NSString*)appName {
    return [[allApplicationDictionary objectForKey:appName] objectForKey:@"HeadData"];
}

+ (NSMutableDictionary*)getShortcutDictionary:(NSString*)appName {
    return [[allApplicationDictionary objectForKey:appName] objectForKey:@"Shortcuts"];
}

+ (void)saveDataToPlist {
    NSString *finalPath = @"AllApplications.plist";
    [allApplicationDictionary writeToFile:finalPath atomically:true];
}

+ (void)initAllApplicationDictionary {
   // NSString *finalPath = @"AllApplications.plist";
    NSString *finalPath = @"/Users/Togo/dev/LearnShortcuts2/app_xcode/AllApplications.plist";
    allApplicationDictionary = [[AllApplicationDictionary alloc] initWithContentsOfFile:finalPath];
}



@end
