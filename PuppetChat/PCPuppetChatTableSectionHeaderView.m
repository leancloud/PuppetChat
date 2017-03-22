//
//  PCPuppetChatTableSectionHeaderView.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/22/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetChatTableSectionHeaderView.h"

@implementation PCPuppetChatTableSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        _avatarImageView = [self addAvatarImageView];
    }

    return self;
}

- (UIImageView *)addAvatarImageView {
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];

    avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:avatarImageView];

    [self addConstraints:@[
        [NSLayoutConstraint constraintWithItem:avatarImageView
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1.0
                                      constant:0.0],

        [NSLayoutConstraint constraintWithItem:avatarImageView
                                     attribute:NSLayoutAttributeRight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeRight
                                    multiplier:1.0
                                      constant:-4.0],

        [NSLayoutConstraint constraintWithItem:avatarImageView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:1.0
                                      constant:30.0],

        [NSLayoutConstraint constraintWithItem:avatarImageView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:nil
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1.0
                                      constant:30.0]
    ]];

    return avatarImageView;
}

@end
