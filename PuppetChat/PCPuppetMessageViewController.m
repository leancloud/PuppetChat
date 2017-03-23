//
//  PCPuppetMessageViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/21/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetMessageViewController.h"
#import "JSQMessages.h"
#import "UIImageView+WebCache.h"
#import "PCPuppetAvatarGenerator.h"

const static NSUInteger PCPuppetMessageQueryBatchSize = 20;

@interface AVIMMessage (PCPuppet)

@property (nonatomic, strong, readonly) JSQMessage *JSQMessage;

@end

@implementation AVIMMessage (PCPuppet)

- (JSQMessage *)JSQMessage {
    NSString *text = self.content ?: @"";

    return [JSQMessage messageWithSenderId:self.clientId
                               displayName:self.clientId
                                      text:text];
}

@end

@implementation AVIMTextMessage (PCPuppet)

- (JSQMessage *)JSQMessage {
    NSString *text = self.text ?: @"";

    return [JSQMessage messageWithSenderId:self.clientId
                               displayName:self.clientId
                                      text:text];
}

@end

@interface PCPuppetMessageViewController () <AVIMClientDelegate>

@property (nonatomic, strong) NSMutableArray<AVIMMessage *> *messages;

@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (nonatomic, strong) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation PCPuppetMessageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        [self doInitialize];
    }

    return self;
}

- (void)doInitialize {
    _messages = [NSMutableArray array];

    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];

    _outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    _incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showLoadEarlierMessagesHeader = YES;
    self.view.clipsToBounds = YES;

    [self loadLatestMessages];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.keyboardController endListeningForKeyboard];
}

- (void)setConversaiton:(AVIMConversation *)conversaiton {
    _conversaiton = conversaiton;
    _conversaiton.imClient.delegate = self;

    NSString *clientId = conversaiton.clientId;

    self.senderId = clientId;
    self.senderDisplayName = clientId;
}

- (void)loadLatestMessages {
    [self loadLatestMessagesFromCache];
    [self fetchLatestMessages];
}

- (void)loadLatestMessagesFromCache {
    NSArray *messages = [self.conversaiton queryMessagesFromCacheWithLimit:PCPuppetMessageQueryBatchSize];
    [self latestMessagesDidLoad:messages];
}

- (void)fetchLatestMessages {
    [self.conversaiton queryMessagesWithLimit:PCPuppetMessageQueryBatchSize
                                     callback:^(NSArray * _Nullable messages, NSError * _Nullable error) {
                                         if (!error && messages)
                                             [self latestMessagesDidLoad:messages];
                                     }];
}

- (void)latestMessagesDidLoad:(NSArray<AVIMMessage *> *)messages {
    self.messages = [NSMutableArray arrayWithArray:messages];
    [self finishReceivingMessage];
}

- (void)loadEarlierMessagesBeforeMessage:(AVIMMessage *)message {
    [self.conversaiton queryMessagesBeforeId:message.messageId
                                   timestamp:message.sendTimestamp
                                       limit:PCPuppetMessageQueryBatchSize
                                    callback:^(NSArray * _Nullable messages, NSError * _Nullable error) {
                                        if (!error && messages)
                                            [self earlierMessagesDidFetch:messages before:message];
                                    }];
}

- (void)earlierMessagesDidFetch:(NSArray<AVIMMessage *> *)messages before:(AVIMMessage *)message {
    NSIndexSet *indexSet;
    NSUInteger index = [self.messages indexOfObject:message];

    if (index != NSNotFound) {
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, messages.count)];
    } else {
        indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, messages.count)];
    }

    [self.messages insertObjects:messages atIndexes:indexSet];

    [self finishReceivingMessageWithoutScrollingToBottom];
}

- (void)finishReceivingMessageWithoutScrollingToBottom {
    self.automaticallyScrollsToMostRecentMessage = NO;
    [self finishReceivingMessage];
    self.automaticallyScrollsToMostRecentMessage = YES;
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:text attributes:nil];

    [self.conversaiton sendMessage:message callback:^(BOOL succeeded, NSError * _Nullable error) {
        /* TODO */
    }];

    [self.messages addObject:message];

    [self finishSendingMessage];
}

- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    [self.messages addObject:message];

    [self finishReceivingMessage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messages.count;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    AVIMMessage *message = self.messages[indexPath.item];
    return message.JSQMessage;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *) [super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    AVIMMessage *message = self.messages[indexPath.item];

    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[PCPuppetAvatarGenerator identiconURLStringForId:message.clientId]]
                            placeholderImage:nil
                                   completed:nil];

    return cell;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    AVIMMessage *message = self.messages[indexPath.item];

    switch (message.ioType) {
    case AVIMMessageIOTypeIn:
        return self.incomingBubbleImageData;
    case AVIMMessageIOTypeOut:
        return self.outgoingBubbleImageData;
    }
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    AVIMMessage *earlistMessage = [self.messages firstObject];

    if (earlistMessage) {
        [self loadEarlierMessagesBeforeMessage:earlistMessage];
    } else {
        [self loadLatestMessages];
    }
}

@end
