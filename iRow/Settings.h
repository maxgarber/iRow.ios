//
//  Settings.h
//  iRow
//
//  Created by David van Leeuwen on 26-09-11.
//  Copyright 2011 strApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject {
    NSUserDefaults * ud;

}

+(Settings*)sharedInstance;
-(void)setObject:(id)object forKey:(NSString*)key;
-(id)loadObjectForKey:(NSString*)key;

@end