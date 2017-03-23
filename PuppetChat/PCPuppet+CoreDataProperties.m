//
//  PCPuppet+CoreDataProperties.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/23/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppet+CoreDataProperties.h"

@implementation PCPuppet (CoreDataProperties)

+ (NSFetchRequest<PCPuppet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PCPuppet"];
}

@dynamic forcedLogin;
@dynamic puppetId;
@dynamic singleLoginTag;
@dynamic transientConversation;
@dynamic uniqueConversation;

@end
