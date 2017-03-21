//
//  PCPuppetChatTableViewController.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/20/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPuppet.h"

@interface PCPuppetChatTableViewController : UITableViewController

@property (nonatomic, strong) PCPuppet *creator;
@property (nonatomic, strong) NSArray<PCPuppet *> *others;

@end
