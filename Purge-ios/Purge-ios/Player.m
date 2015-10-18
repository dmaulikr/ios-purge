//
//  Player.m
//  Purge-ios
//
//  Created by Sumit Chaudhary on 18/10/15.
//  Copyright (c) 2015 moldedbits. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithImageNamed:(NSString *)name {
    if (self = [super initWithImageNamed:name]) {
        self.health = 100;
    }
    return self;
}

@end
