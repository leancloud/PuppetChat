//
//  PCPuppetMessageViewController.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/21/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface PCPuppetMessageViewController : JSQMessagesViewController

@property (nonatomic, strong) AVIMConversation *conversaiton;

@end
