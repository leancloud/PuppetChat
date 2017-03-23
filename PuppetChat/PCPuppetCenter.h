//
//  PCPuppetCenter.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/22/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppet.h"

@interface PCPuppetCenter : NSObject

+ (instancetype)sharedInstance;

- (PCPuppet *)createPuppetWithId:(NSString *)puppetId
                  singleLoginTag:(NSString *)singleLoginTag;

- (NSArray<PCPuppet *> *)fetchAllPuppets;

- (void)deletePuppet:(PCPuppet *)puppet;

@end
