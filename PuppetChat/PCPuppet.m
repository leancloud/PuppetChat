//
//  PCPuppet+CoreDataClass.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/23/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppet.h"

NSString *PCPuppetDidChangeNotification = @"PCPuppetDidChangeNotification";

@implementation PCPuppet

@synthesize client = _client;
@synthesize statusDescription = _statusDescription;

- (void)dealloc {
    [_client removeObserver:self forKeyPath:@"status"];
}

- (void)observeStatusOfClient:(AVIMClient *)client {
    [client addObserver:self
             forKeyPath:@"status"
                options:NSKeyValueObservingOptionNew
                context:NULL];
}

- (AVIMClient *)client {
    if (_client)
        return _client;

    @synchronized (self) {
        if (_client)
            return _client;

        _client = [[AVIMClient alloc] initWithClientId:self.puppetId
                                                   tag:self.singleLoginTag];

        [self observeStatusOfClient:_client];
    }

    return _client;
}

- (NSString *)statusDescription {
    return [self descriptionForClientStatus:self.client.status];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (object == self.client) {
        [self postChangeNotification];
    }
}

- (void)postChangeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:PCPuppetDidChangeNotification object:self];
}

- (NSString *)descriptionForClientStatus:(AVIMClientStatus)clientStatus {
    switch (clientStatus) {
    case AVIMClientStatusNone:
        return @"None";
    case AVIMClientStatusOpening:
        return @"Opening";
    case AVIMClientStatusOpened:
        return @"Opened";
    case AVIMClientStatusPaused:
        return @"Paused";
    case AVIMClientStatusResuming:
        return @"Resuming";
    case AVIMClientStatusClosing:
        return @"Closing";
    case AVIMClientStatusClosed:
        return @"Closed";
    }
}

- (void)save {
    [self.managedObjectContext save:NULL];
}

@end
