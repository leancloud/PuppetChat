//
//  PCPuppetTableViewCell.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetTableViewCell.h"

@implementation PCPuppetTableViewCell

- (void)setPuppet:(PCPuppet *)puppet {
    _puppet = puppet;
    [self refreshUI];
}

- (void)refreshUI {
    /* TODO */
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
