//
//  ApplicationData.h
//  EVE
//
//  Created by Tobias Sommer on 7/25/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ApplicationData : NSObject {
    NSString                *learnedShortcutDictionaryPath;
    NSString                * disabledDictionaryDictionaryPath;
    NSMutableDictionary     *applicationDataDictionary;
}

+ (ApplicationData*) loadApplicationData;

+ (void) saveDictionary :(NSString*) path :(NSMutableDictionary*) dic;

- (void) setLearnedShortcutDictionaryPath: (NSString*) finalPath;

- (void) setDisabledDictionaryDictionaryPath :(NSString*) finalPath;

- (NSString*) getDisabledDictionaryDictionaryPath;

- (NSString*) getLearnedShortcutDictionaryPath;

- (void) setApplicationDataDictionary: (NSMutableDictionary*) id;

- (NSMutableDictionary*) getApplicationDataDictionary;

@end
