//
//  ApplicationData.m
//  EVE
//
//  Created by Tobias Sommer on 7/25/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import "ApplicationData.h"
#import "DDLog.h"
#import "NSFileManager+DirectoryLocations.h"
#import "Constants.h"

static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation ApplicationData

+ (ApplicationData*) loadApplicationData {
    ApplicationData *applicationData = [ApplicationData  alloc];
    
    NSMutableDictionary *applicationDataDictionary = [[NSMutableDictionary alloc] init];
    
    NSString     *finalPath =  [[NSBundle mainBundle] pathForResource:@"AdditionalShortcuts"  ofType:@"plist" inDirectory:@""];
    NSDictionary *allAdditionalShortcuts = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    finalPath = NULL;
    
    finalPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    finalPath = [finalPath stringByAppendingPathComponent:@"learnedShortcuts.plist"];
    NSMutableDictionary *learnedShortcutsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    [applicationData setLearnedShortcutDictionaryPath: finalPath];
    
    if (!learnedShortcutsDictionary) { // If you can't find the dictionary create a new one!
        DDLogInfo(@"Can't find learnedShortcut Dictionary. I create a new one");
        learnedShortcutsDictionary = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *globalLearnedShortcutDictionary      = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *applicationLearnedShortcutDictionary = [[NSMutableDictionary alloc] init];
        
        [learnedShortcutsDictionary setValue:globalLearnedShortcutDictionary forKey:globalLearnedShortcut];
        [learnedShortcutsDictionary setValue:applicationLearnedShortcutDictionary forKey:applicationLearnedShortcut];
        
        [learnedShortcutsDictionary writeToFile:finalPath atomically: YES];
    }
    
    [applicationDataDictionary setValue:allAdditionalShortcuts forKey:@"applicationShortcuts"];
    [applicationDataDictionary setValue:learnedShortcutsDictionary forKey:learnedShortcuts];
    [applicationData setApplicationDataDictionary: applicationDataDictionary];
    
    return applicationData;
}

+ (void) saveLearnedShortcutDictionary :(ApplicationData*) applicationData :(NSMutableDictionary*) applicationDataDictionary {
    NSString *path =    [applicationData getLearnedShortcutDictionaryPath];
    if(path)
    {
     [applicationDataDictionary writeToFile:path atomically: YES];
    }
    else
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Sorry can't save the File"];
        [alert setInformativeText:@"Please check the File Path"];
        [alert setAlertStyle:NSWarningAlertStyle];
    }

}


- (void) setLearnedShortcutDictionaryPath :(NSString*) finalPath {
    learnedShortcutDictionaryPath = finalPath;
}

- (NSString*) getLearnedShortcutDictionaryPath {
    return learnedShortcutDictionaryPath;
}

- (void) setApplicationDataDictionary: (NSMutableDictionary*) id {
    applicationDataDictionary = id;
}

- (NSMutableDictionary*) getApplicationDataDictionary {
    return applicationDataDictionary;
}

@end
