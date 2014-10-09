//
//  AppDelegate.m
//  SBShazamScrobbler
//
//  Created by Stéphane Bruckert on 16/09/14.
//  Copyright (c) 2014 Stéphane Bruckert. All rights reserved.
//

#import "AppDelegate.h"
#import "Song.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSBundle* bundle = [[NSBundle alloc] initWithPath:@"~/Library/Containers/com.shazam.mac.Shazam/Data/Documents/"];
    NSString* filePath = [bundle pathForResource:@"RecentTags" ofType:@"plist"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"File exists");
    } else {
        NSLog(@"File doesn't exist");
    }
    
    int dicInARow = 0;
    bool numberBefore = NO;
    Song *test;
    NSDictionary* plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    for (NSDictionary *obj in [plist objectForKey:@"$objects"]) {
        if ([obj isKindOfClass:[NSString class]]) {
            if (dicInARow >= 2 && dicInARow <= 3) {
                if (dicInARow == 2) {
                    test = [[Song alloc] initWithArtist:[obj description]];
                } else {
                    [test setSong:[obj description]];
                }
                dicInARow++;
            } else {
                dicInARow = 0;
            }
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if (numberBefore) {
                NSTimeInterval timeInterval = [[obj objectForKey:@"NS.time"] doubleValue];
                NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
                [test setDate:newDate];
                NSLog(@"%@", [test description]);
                numberBefore = NO;
            }
            dicInARow++;
        }
        if ([obj isKindOfClass:[NSNumber class]]) {
            dicInARow = 0;
            numberBefore = YES;
        }
    }
}

@end
