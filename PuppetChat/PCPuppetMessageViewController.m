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
#import <CommonCrypto/CommonCrypto.h>

NS_INLINE
NSString *MD5EncodedString(NSString *string) {
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

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

- (NSString *)identiconAvatarURLString {
    NSString *MD5EncodedClientId = MD5EncodedString(self.clientId);
    NSString *URLString = [NSString stringWithFormat:@"https://cn.gravatar.com/avatar/%@?d=identicon", MD5EncodedClientId];

    return URLString;
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

    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[message identiconAvatarURLString]]
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

@end
