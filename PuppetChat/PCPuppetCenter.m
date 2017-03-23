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

    NSDictionary *options = @{
        NSMigratePersistentStoresAutomaticallyOption: @(YES),
        NSInferMappingModelAutomaticallyOption: @(YES)
    };

    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreURL options:options error:&error];

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

- (void)save {
    [self.managedObjectContext save:NULL];
}

- (PCPuppet *)createPuppetWithId:(NSString *)puppetId
                  singleLoginTag:(NSString *)singleLoginTag
{
    NSString *entityName = NSStringFromClass([PCPuppet class]);
    PCPuppet *puppet = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:self.managedObjectContext];

    puppet.puppetId = puppetId;
    puppet.singleLoginTag = singleLoginTag;

    [self save];

    return puppet;
}

- (NSArray<PCPuppet *> *)fetchAllPuppets {
    NSFetchRequest *fetchRequest = [PCPuppet fetchRequest];
    NSArray<PCPuppet *> *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:NULL];

    return results;
}

- (void)deletePuppet:(PCPuppet *)puppet {
    [self.managedObjectContext deleteObject:puppet];
    [self save];
}

@end
