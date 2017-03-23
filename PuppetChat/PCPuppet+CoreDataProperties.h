//
//  PCPuppet+CoreDataProperties.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/23/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppet.h"


NS_ASSUME_NONNULL_BEGIN

@interface PCPuppet (CoreDataProperties)

+ (NSFetchRequest<PCPuppet *> *)fetchRequest;

@property (nonatomic) BOOL forcedLogin;
@property (nullable, nonatomic, copy) NSString *puppetId;
@property (nullable, nonatomic, copy) NSString *singleLoginTag;
@property (nonatomic) BOOL transientConversation;
@property (nonatomic) BOOL uniqueConversation;

@end

NS_ASSUME_NONNULL_END
