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
    
    // Get the learnedShortcut Dictionary
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
    
    finalPath = NULL;
    // Get the disabled Application Dictionary
    finalPath = [[NSFileManager defaultManager] applicationSupportDirectory];
    finalPath = [finalPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", DISABLED_APPLICATIONS, @".plist"]];
    NSMutableDictionary *disabledApplicationDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
    
    // Set the path to save the dictionary if the user disable a Application
    [applicationData setDisabledDictionaryDictionaryPath: finalPath];
    
    if (!disabledApplicationDictionary) { // If you can't find the dictionary create a new one!
        DDLogInfo(@"Can't find disabledApplicationDictionary. I create a new one");
        disabledApplicationDictionary = [[NSMutableDictionary alloc] init];
        
        [disabledApplicationDictionary writeToFile:finalPath atomically: YES];
    }
    
    
    // ADD the Dictionarys to the main dictionary
    [applicationDataDictionary setValue:allAdditionalShortcuts forKey:@"applicationShortcuts"];
    [applicationDataDictionary setValue:learnedShortcutsDictionary forKey:learnedShortcuts];
    [applicationDataDictionary setValue:disabledApplicationDictionary forKey:DISABLED_APPLICATIONS];
    [applicationData setApplicationDataDictionary: applicationDataDictionary];
    
    return applicationData;
}

+ (void) saveDictionary :(NSString*) path :(NSMutableDictionary*) dic  {
    if(path)
    {
     [dic writeToFile:path atomically: YES];
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

- (void) setDisabledDictionaryDictionaryPath :(NSString*) finalPath {
    disabledDictionaryDictionaryPath = finalPath;
}

- (NSString*) getDisabledDictionaryDictionaryPath {
    return disabledDictionaryDictionaryPath;
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
