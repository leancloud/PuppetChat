//
//  PCPuppet+CoreDataClass.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/23/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *PCPuppetDidChangeNotification;

@interface PCPuppet : NSManagedObject

@property (nonatomic, strong, readonly) AVIMClient *client;
@property (nonatomic,   copy, readonly) NSString   *statusDescription;

- (void)save;

@end

NS_ASSUME_NONNULL_END

#import "PCPuppet+CoreDataProperties.h"
