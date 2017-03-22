//
//  PCPuppetAvatarGenerator.m
//  PuppetChat
//
//  Created by Tang Tianyong on 3/22/17.
//  Copyright © 2017 Tianyong Tang. All rights reserved.
//

#import "PCPuppetAvatarGenerator.h"
#import <CommonCrypto/CommonDigest.h>

NS_INLINE
NSString *MD5EncodedString(NSString *string) {
    const char* input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}

@implementation PCPuppetAvatarGenerator

+ (NSString *)identiconURLStringForId:(NSString *)anId {
    NSString *MD5EncodedClientId = MD5EncodedString(anId);
    NSString *URLString = [NSString stringWithFormat:@"https://cn.gravatar.com/avatar/%@?d=identicon", MD5EncodedClientId];

    return URLString;
}

@end
