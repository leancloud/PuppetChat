//
//  PCClientTableViewCell.h
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCClientTableViewCell;

typedef void(^PCClientAction)(PCClientTableViewCell *clientTableViewCell);

@interface PCClientTableViewCell : UITableViewCell

@property (nonatomic, copy) PCClientAction loginAction;
@property (nonatomic, copy) PCClientAction forcedLoginAction;
@property (nonatomic, copy) PCClientAction logoutAction;

@end
