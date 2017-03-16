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

- (void)setPuppet:(PCPuppet *)puppet {
    _puppet = puppet;
    [self refreshUI];
}

- (void)refreshUI {
    self.puppetIdTextField.text = self.puppet.puppetId;
    self.singleLoginTagTextField.text = self.puppet.singleLoginTag;
    self.forcedLoginSwitch.enabled = self.puppet.forcedLogin;
    self.uniqueConversationSwitch.enabled = self.puppet.uniqueConversation;
    self.transientConversationSwitch.enabled = self.puppet.transientConversation;
    self.puppetStatusLabel.text = self.puppet.statusDescription;
}

- (IBAction)loginButtonDidClick:(id)sender {
    if (self.loginAction)
        self.loginAction(self);
}

- (IBAction)forcedLoginButtonDidClick:(id)sender {
    if (self.forcedLoginAction)
        self.forcedLoginAction(self);
}

- (IBAction)logoutButtonDidClick:(id)sender {
    if (self.logoutAction)
        self.logoutAction(self);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
