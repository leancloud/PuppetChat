//
//  PCPuppetTableViewCell.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCPuppetTableViewCell;

typedef void(^PCPuppetAction)(PCPuppetTableViewCell *puppetTableViewCell);

@interface PCPuppetTableViewCell : UITableViewCell

@property (nonatomic, copy) PCPuppetAction loginAction;
@property (nonatomic, copy) PCPuppetAction forcedLoginAction;
@property (nonatomic, copy) PCPuppetAction logoutAction;

@end
