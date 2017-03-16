//
//  PCPuppetAddingTableViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetAddingTableViewController.h"

@interface PCPuppetAddingTableViewController ()

<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *puppetIdTextField;

@end

@implementation PCPuppetAddingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.puppetIdTextField becomeFirstResponder];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [self finish];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.puppetIdTextField) {
        [self finish];
        return NO;
    }

    return YES;
}

- (BOOL)validateBeforeFinish {
    if (!self.puppetIdTextField.text.length) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Invalid Puppet ID"
                                    message:@"Puppet ID cannot be empty."
                                    preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];

        [self presentViewController:alert animated:YES completion:nil];

        return NO;
    }

    return YES;
}

- (void)finish {
    if (![self validateBeforeFinish])
        return;

    NSString *puppetId = self.puppetIdTextField.text;

    PCPuppet *puppet = [[PCPuppet alloc] initWithPuppetId:puppetId];

    [self.puppetIdTextField resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.puppetCreatedBlock)
            self.puppetCreatedBlock(puppet);
    }];
}

@end
