//
//  PCPuppetMessageViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/21/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetMessageViewController.h"

@interface PCPuppetMessageViewController ()

@end

@implementation PCPuppetMessageViewController

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

@end
