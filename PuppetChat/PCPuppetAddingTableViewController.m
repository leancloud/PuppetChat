//
//  PCPuppetAddingTableViewController.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/16/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetAddingTableViewController.h"
#import "PCPuppetCenter.h"

@interface PCPuppetAddingTableViewController ()

<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *puppetIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *singleLoginTagTextField;

@end

@implementation PCPuppetAddingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.puppetIdTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [self finish];
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.puppetIdTextField ||
        textField == self.singleLoginTagTextField)
    {
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
    NSString *singleLoginTag = self.singleLoginTagTextField.text;

    PCPuppet *puppet = [[PCPuppetCenter sharedInstance] createPuppetWithId:puppetId
                                                            singleLoginTag:singleLoginTag];

    if (!puppet)
        return;

    [self dismissViewControllerAnimated:YES completion:^{
        if (self.puppetCreatedBlock)
            self.puppetCreatedBlock(puppet);
    }];
}

@end
