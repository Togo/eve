//
//  Dictionary.h
//  LearnShortcuts
//
//  Created by Tobias Sommer on 6/5/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AllApplicationDictionary : NSMutableDictionary  {

}

+ (NSMutableDictionary*)getHeadDataDictionary:(NSString*)appName;

+ (NSMutableDictionary*)getShortcutDictionary:(NSString*)appName;

+ (void)saveDataToPlist;

+ (void)initAllApplicationDictionary;
@end
