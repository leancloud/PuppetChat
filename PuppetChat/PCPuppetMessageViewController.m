//
//  PCPuppetMessageViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/21/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetMessageViewController.h"
#import "JSQMessages.h"
#import "JSQMessage.h"

@interface AVIMMessage (PCPuppet)

@property (nonatomic, strong, readonly) JSQMessage *JSQMessage;

@end

@implementation AVIMMessage (PCPuppet)

- (JSQMessage *)JSQMessage {
    return [JSQMessage messageWithSenderId:self.clientId
                               displayName:self.clientId
                                      text:self.content ?: @""];
}

@end

@implementation AVIMTextMessage (PCPuppet)

- (JSQMessage *)JSQMessage {
    return [JSQMessage messageWithSenderId:self.clientId
                               displayName:self.clientId
                                      text:self.text ?: @""];
}

@end

@interface PCPuppetMessageViewController ()

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.keyboardController endListeningForKeyboard];
}

- (void)setConversaiton:(AVIMConversation *)conversaiton {
    _conversaiton = conversaiton;

    NSString *clientId = conversaiton.clientId;

    self.senderId = clientId;
    self.senderDisplayName = clientId;
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
        NSLog(@"hello, world");
    }];

    [self.messages addObject:message];

    [self finishSendingMessage];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.messages.count;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    AVIMMessage *message = self.messages[indexPath.item];
    return message.JSQMessage;
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

@end
