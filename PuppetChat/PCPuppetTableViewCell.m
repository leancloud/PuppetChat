//
//  PCPuppetTableViewCell.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetTableViewCell.h"

@interface PCPuppetTableViewCell ()

@property (weak, nonatomic) IBOutlet UITextField *puppetIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *singleLoginTagTextField;
@property (weak, nonatomic) IBOutlet UISwitch    *forcedLoginSwitch;
@property (weak, nonatomic) IBOutlet UISwitch    *uniqueConversationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch    *transientConversationSwitch;
@property (weak, nonatomic) IBOutlet UILabel     *puppetStatusLabel;

@end

@implementation PCPuppetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self doInitialize];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)doInitialize {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(puppetDidChange:)
                                                 name:PCPuppetDidChangeNotification
                                               object:nil];
}

- (void)puppetDidChange:(NSNotification *)notification {
    id object = notification.object;

    if (object == self.puppet) {
        [self refreshUI];
    }
}

- (void)setPuppet:(PCPuppet *)puppet {
    _puppet = puppet;
    [self refreshUI];
}

- (void)refreshUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.puppetIdTextField.text = self.puppet.puppetId;
        self.singleLoginTagTextField.text = self.puppet.singleLoginTag;
        self.forcedLoginSwitch.on = self.puppet.forcedLogin;
        self.uniqueConversationSwitch.on = self.puppet.uniqueConversation;
        self.transientConversationSwitch.on = self.puppet.transientConversation;
        self.puppetStatusLabel.text = self.puppet.statusDescription;

        [self updateBackgroundColorForClientStatus:self.puppet.client.status];
    });
}

- (void)updateBackgroundColorForClientStatus:(AVIMClientStatus)status {
    if (status == AVIMClientStatusOpened) {
        self.contentView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)forcedLoginSwitchDidChange:(UISwitch *)sender {
    self.puppet.forcedLogin = sender.isOn;
}

- (IBAction)uniqueConversationSwitchDidChange:(UISwitch *)sender {
    self.puppet.uniqueConversation = sender.isOn;
}

- (IBAction)transientConversationSwitchDidChange:(UISwitch *)sender {
    self.puppet.transientConversation = sender.isOn;
}

- (IBAction)login:(UIButton *)sender {
    if ([self.puppetDelegate respondsToSelector:@selector(puppetLogin:)])
        [self.puppetDelegate puppetLogin:self.puppet];
}

- (IBAction)showConversationList:(UIButton *)sender {
    if ([self.puppetDelegate respondsToSelector:@selector(puppetShowConversationList:)])
        [self.puppetDelegate puppetShowConversationList:self.puppet];
}

- (IBAction)chatWithOtherPuppets:(UIButton *)sender {
    if ([self.puppetDelegate respondsToSelector:@selector(puppetChatWithOtherPuppets:)])
        [self.puppetDelegate puppetChatWithOtherPuppets:self.puppet];
}

- (IBAction)logout:(UIButton *)sender {
    if ([self.puppetDelegate respondsToSelector:@selector(puppetLogout:)])
        [self.puppetDelegate puppetLogout:self.puppet];
}

@end
