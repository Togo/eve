//
//  LearnedWindowController.h
//  EVE
//
//  Created by Tobias Sommer on 7/22/12.
//  Copyright (c) 2012 Sommer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LearnedWindowController : NSWindowController {
        NSArray *clickContextArray;
}


-(IBAction) closeButton:(id) sender;

-(IBAction) globalButton:(id) sender;


- (void) setClickContextArray:(NSArray*) id ;
@end
