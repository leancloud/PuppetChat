//
//  PCPuppetAddingTableViewController.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPuppet.h"

@interface PCPuppetAddingTableViewController : UIViewController

@property (nonatomic, copy) void(^puppetCreatedBlock)(PCPuppet *puppet);

@end
