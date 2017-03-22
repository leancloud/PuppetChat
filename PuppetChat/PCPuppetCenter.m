//
//  PCPuppetCenter.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/22/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetCenter.h"

@interface PCPuppetCenter ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation PCPuppetCenter

- (instancetype)init {
    self = [super init];

    if (self) {
        [self doInitialize];
    }

    return self;
}

+ (instancetype)sharedInstance {
    static PCPuppetCenter *instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[PCPuppetCenter alloc] init];
    });

    return instance;
}

+ (NSURL *)modelURL {
    NSString *modelName = @"PCPuppetDataModel";
    NSURL *URL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];

    return URL;
}

+ (NSManagedObjectModel *)objectModel {
    NSURL *URL = [self modelURL];

    if (!URL)
        return nil;

    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:URL];

    return model;
}

+ (NSURL *)persistentStoreURL {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];

    if (!path)
        return nil;

    NSURL *URL = [NSURL fileURLWithPath:[path stringByAppendingPathComponent:@"PCPuppetDataModel.sql"]];

    return URL;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSManagedObjectModel *model = [self objectModel];

    if (!model)
        return nil;

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    NSURL *persistentStoreURL = [self persistentStoreURL];

    if (!persistentStoreURL)
        return nil;

    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreURL options:nil error:&error];

    if (error)
        return nil;

    return coordinator;
}

- (void)doInitialize {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [PCPuppetCenter persistentStoreCoordinator];

    if (persistentStoreCoordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    }
}

@end
