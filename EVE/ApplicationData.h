//
//  ApplicationData.h
//  EVE
//
//  Created by Tobias Sommer on 7/25/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ApplicationData : NSObject {
    NSString            *learnedShortcutDictionaryPath;
    NSMutableDictionary *applicationDataDictionary;
}

+ (NSMutableDictionary*) loadApplicationData;

+ (void) saveLearnedShortcutDictionary :(ApplicationData*) applicationData :(NSMutableDictionary*) applicationDataDictionary;

- (void) setLearnedShortcutDictionaryPath: (NSString*) finalPath;

- (NSString*) getLearnedShortcutDictionaryPath;

- (void) setApplicationDataDictionary: (NSMutableDictionary*) id;

- (NSMutableDictionary*) getApplicationDataDictionary;

@end
