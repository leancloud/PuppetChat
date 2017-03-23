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
#import "PCPuppetChatTableViewController.h"
#import "PCPuppetCenter.h"

static NSString *PCPuppetCellReuseIdentifier   = @"Puppet";
static NSString *PCPuppetAddingSegueIdentifier = @"AddPuppet";
static NSString *PCPuppetChattingWithOthersSegueIdentifier = @"ChatWithOthers";
static NSString *PCPuppetKeyCreator = @"PCPuppetKeyCreator";
static NSString *PCPuppetKeyOthers = @"PCPuppetKeyOthers";

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
    NSArray<PCPuppet *> *puppets = [[PCPuppetCenter sharedInstance] fetchAllPuppets];
    _puppets = [NSMutableArray arrayWithArray:puppets];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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
    } else if ([segue.identifier isEqualToString:PCPuppetChattingWithOthersSegueIdentifier]) {
        NSDictionary *userInfo = sender;

        PCPuppet *creator = userInfo[PCPuppetKeyCreator];
        NSArray<PCPuppet *> *others = userInfo[PCPuppetKeyOthers];

        PCPuppetChatTableViewController *viewController = (PCPuppetChatTableViewController *)segue.destinationViewController;

        viewController.creator = creator;
        viewController.others = others;
    }
}

- (void)puppetLogin:(PCPuppet *)puppet {
    AVIMClient *client = puppet.client;
    AVIMClientOpenOption *option = [[AVIMClientOpenOption alloc] init];

    option.force = puppet.forcedLogin;

    [client openWithOption:option callback:^(BOOL succeeded, NSError * _Nullable error) {
        /* TODO */
    }];
}

- (void)puppetShowConversationList:(PCPuppet *)puppet {
    /* TODO */
}

- (void)puppetChatWithOtherPuppets:(PCPuppet *)puppet {
    PCPuppet *creator = puppet;
    NSMutableArray<PCPuppet *> *others = [self.puppets mutableCopy];
    [others removeObject:creator];

    [self performSegueWithIdentifier:PCPuppetChattingWithOthersSegueIdentifier sender:@{
        PCPuppetKeyCreator: creator,
        PCPuppetKeyOthers: others
    }];
}

- (void)puppetLogout:(PCPuppet *)puppet {
    AVIMClient *client = puppet.client;

    [client closeWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        /* TODO */
    }];
}

- (void)deletePuppetAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    PCPuppet *puppet = self.puppets[row];

    [self.puppets removeObjectAtIndex:row];
    [[PCPuppetCenter sharedInstance] deletePuppet:puppet];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deletePuppetAtIndexPath:indexPath];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
