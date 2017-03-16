//
//  PCPuppet.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCPuppet : NSObject

@property (nonatomic,   copy, readonly)     NSString    *puppetId;
@property (nonatomic,   copy)               NSString    *singleLoginTag;
@property (nonatomic, assign)               BOOL         forcedLogin;
@property (nonatomic, assign)               BOOL         uniqueConversation;
@property (nonatomic, assign)               BOOL         transientConversation;
@property (nonatomic,   copy, readonly)     NSString    *statusDescription;

- (instancetype)initWithPuppetId:(NSString *)puppetId;

@end
