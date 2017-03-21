//
//  PCPuppetChatTableViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/20/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetChatTableViewController.h"
#import "PCPuppetMessageViewController.h"

const static CGFloat PCPuppetChatCellHeight = 200;

@interface AVIMClient ()

- (AVIMConversation *)conversationWithId:(NSString *)conversationId;

@end

@interface PCPuppetChatTableViewController ()

@property (nonatomic, strong) PCPuppetMessageViewController *creatorMessageVC;
@property (nonatomic, strong) NSArray<PCPuppetMessageViewController *> *otherMessageVCs;

@end

@implementation PCPuppetChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self startChat];
}

- (void)startChat {
    [self loginCreator];
}

- (void)loginCreator {
    AVIMClient *creator = self.creator.client;

    [creator openWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            /* TODO */
            return;
        }

        [self creatorDidLogin];
    }];
}

- (void)creatorDidLogin {
    [self createConversation];
}

- (void)createConversation {
    AVIMConversationOption options;
    NSMutableArray *members = [NSMutableArray array];

    for (PCPuppet *other in self.others) {
        [members addObject:other.client.clientId];
    }

    if (self.creator.uniqueConversation)
        options |= AVIMConversationOptionUnique;

    if (self.creator.transientConversation)
        options |= AVIMConversationOptionTransient;

    [self.creator.client createConversationWithName:@"Puppet Chat"
                                          clientIds:members
                                         attributes:nil
                                            options:options
                                           callback:
    ^(AVIMConversation * _Nullable conversation, NSError * _Nullable error) {
        if (error) {
            /* TODO */
            return;
        }

        [self firstConversationDidCreate:conversation];
    }];
}

- (void)firstConversationDidCreate:(AVIMConversation *)conversation {
    self.creatorMessageVC = [self messageViewControllerWithConversation:conversation];

    NSString *conversationId = conversation.conversationId;
    NSMutableArray<PCPuppetMessageViewController *> *otherMessageVCs = [NSMutableArray arrayWithCapacity:self.others.count];

    for (PCPuppet *other in self.others) {
        AVIMConversation *conversation = [other.client conversationWithId:conversationId];
        [otherMessageVCs addObject:[self messageViewControllerWithConversation:conversation]];
    }

    self.otherMessageVCs = otherMessageVCs;

    [self.tableView reloadData];
}

- (PCPuppetMessageViewController *)messageViewControllerWithConversation:(AVIMConversation *)conversation {
    PCPuppetMessageViewController *messageVC = [PCPuppetMessageViewController messagesViewController];
    messageVC.conversaiton = conversation;
    return messageVC;
}

- (void)layoutMessageView:(UIView *)messageView {
    if (!messageView)
        return;

    UIView *superview = messageView.superview;

    if (!superview)
        return;

    messageView.translatesAutoresizingMaskIntoConstraints = NO;

    [superview addConstraints:@[
        [NSLayoutConstraint constraintWithItem:messageView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:superview
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0],

        [NSLayoutConstraint constraintWithItem:messageView
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:superview
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0
                                      constant:0.0],

        [NSLayoutConstraint constraintWithItem:messageView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:superview
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:1.0
                                      constant:0.0],

        [NSLayoutConstraint constraintWithItem:messageView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:superview
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1.0
                                      constant:0.0]
    ]];
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return @"Creator";
    case 1:
        return @"Other Puppets";
    default:
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
    case 0:
        return 1;
    case 1:
        return self.others.count;
    default:
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PCPuppetChatCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCPuppetMessageViewController *messageVC;

    switch (indexPath.section) {
    case 0:
        messageVC = self.creatorMessageVC;
        break;
    case 1:
        messageVC = self.otherMessageVCs[indexPath.row];
        break;
    default:
        break;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView *messageView = messageVC.view;

    [cell.contentView addSubview:messageView];
    [self layoutMessageView:messageView];

    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end