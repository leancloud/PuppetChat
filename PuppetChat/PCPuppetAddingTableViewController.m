//
//  PCPuppetAddingTableViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetAddingTableViewController.h"

@interface PCPuppetAddingTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *puppetIdTextField;

@end

@implementation PCPuppetAddingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.puppetIdTextField becomeFirstResponder];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    /* TODO */
}

@end
