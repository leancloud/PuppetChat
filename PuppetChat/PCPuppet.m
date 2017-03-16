//
//  PCPuppet.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppet.h"

NSString *PCPuppetDidChangeNotification = @"PCPuppetDidChangeNotification";

@interface PCPuppet ()

@property (nonatomic, copy) NSString *statusDescription;

@end

@implementation PCPuppet

@synthesize client = _client;

- (instancetype)init {
    self = [super init];

    if (self) {
        [self doInitialize];
    }

    return self;
}

- (void)doInitialize {
    _uniqueConversation = YES;
    _statusDescription = [self descriptionForClientStatus:AVIMClientStatusNone];
}

- (instancetype)initWithPuppetId:(NSString *)puppetId
                  singleLoginTag:(NSString *)singleLoginTag
{
    self = [self init];

    if (self) {
        _puppetId = [puppetId copy];
        _singleLoginTag = [singleLoginTag copy];
    }

    return self;
}

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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context
{
    if (object == self.client) {
        AVIMClientStatus clientStatus = [change[NSKeyValueChangeNewKey] integerValue];
        self.statusDescription = [self descriptionForClientStatus:clientStatus];
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

@end
