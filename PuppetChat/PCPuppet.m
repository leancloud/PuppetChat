//
//  PCPuppet.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppet.h"

@implementation PCPuppet

- (instancetype)init {
    self = [super init];

    if (self) {
        [self doInitialize];
    }

    return self;
}

- (void)doInitialize {
    _uniqueConversation = YES;
}

- (instancetype)initWithPuppetId:(NSString *)puppetId {
    self = [self init];

    if (self) {
        _puppetId = [puppetId copy];
    }

    return self;
}

- (NSString *)statusDescription {
    return @"Unknown";
}

@end
