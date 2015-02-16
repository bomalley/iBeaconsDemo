//
//  Data.m
//  iBeaconsDemo
//
//  Created by Bryan O'Malley on 2/15/15.
//  Copyright (c) 2015 Axeva. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (NSString *)proximityUUID {
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"uuid_preference"]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey: @"uuid_preference"];
    } else {
        return @"1986dc82-b1b6-4029-b4e3-64fc6c876feb";
    }
}

+ (NSInteger)majorNumber {
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"major_preference"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey: @"major_preference"] integerValue];
    } else {
        return 0;
    }
}

+ (NSInteger)minorNumber {
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"minor_preference"]) {
        return [[[NSUserDefaults standardUserDefaults] objectForKey: @"minor_preference"] integerValue];
    } else {
        return 0;
    }
}


@end
