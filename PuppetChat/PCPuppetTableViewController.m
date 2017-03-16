//
//  PCPuppetTableViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/15/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetTableViewController.h"
#import "PCPuppetAddingTableViewController.h"
#import "PCPuppetTableViewCell.h"

static NSString *PCPuppetCellReuseIdentifier   = @"Puppet";
static NSString *PCPuppetAddingSegueIdentifier = @"AddPuppet";

@interface PCPuppetTableViewController ()

<PCPuppetDelegate>

@property (nonatomic, strong) NSMutableArray<PCPuppet *> *puppets;

@end

@implementation PCPuppetTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self doInitialize];
}

- (void)doInitialize {
    _puppets = [NSMutableArray array];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)puppetDidCreate:(PCPuppet *)puppet {
    [self.puppets addObject:puppet];

    NSArray<NSIndexPath *> *indexPaths = @[[NSIndexPath indexPathForRow:self.puppets.count - 1 inSection:0]];

    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationTop];

    [self.tableView scrollToRowAtIndexPath:indexPaths.firstObject
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PCPuppetAddingSegueIdentifier]) {
        UINavigationController *navigator = (UINavigationController *)segue.destinationViewController;
        PCPuppetAddingTableViewController *viewController = (PCPuppetAddingTableViewController *)navigator.topViewController;

        viewController.puppetCreatedBlock = ^(PCPuppet *puppet) {
            [self puppetDidCreate:puppet];
        };
    }
}

- (void)puppetLogin:(PCPuppet *)puppet {
    /* TODO */
}

- (void)puppetShowConversationList:(PCPuppet *)puppet {
    /* TODO */
}

- (void)puppetChatWithOtherPuppets:(PCPuppet *)puppet {
    /* TODO */
}

- (void)puppetLogout:(PCPuppet *)puppet {
    /* TODO */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.puppets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCPuppetTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PCPuppetCellReuseIdentifier
                                                                       forIndexPath:indexPath];
    PCPuppet *puppet = self.puppets[indexPath.row];
    cell.puppet = puppet;
    cell.puppetDelegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 370;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
