//
//  PCPuppetTableViewCell.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetTableViewCell.h"

@implementation PCPuppetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

    // Configure the view for the selected state
}

@end
