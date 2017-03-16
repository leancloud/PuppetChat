//
//  PCPuppetTableViewCell.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPuppet.h"

@protocol PCPuppetDelegate <NSObject>

- (void)puppetLogin:(PCPuppet *)puppet;
- (void)puppetShowConversationList:(PCPuppet *)puppet;
- (void)puppetChatWithOtherPuppets:(PCPuppet *)puppet;
- (void)puppetLogout:(PCPuppet *)puppet;

@end

@class PCPuppetTableViewCell;

@interface PCPuppetTableViewCell : UITableViewCell

@property (nonatomic, strong)   PCPuppet                *puppet;
@property (nonatomic,   weak)   id<PCPuppetDelegate>     puppetDelegate;

@end
