//
//  Crypto.m
//  Task_1
//
//  Created by Антон Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "Crypto.h"
#import <CommonCrypto/CommonDigest.h>


@implementation Crypto

+ (NSString*) hash:(NSString*)pass salt:(NSString*)salt algString:(NSString*)hashalgString base64SaltEncode: (BOOL)base64SaltEncode
{
    if (salt && base64SaltEncode) {
        salt = [self base64DecodedUTF8StringWithString:salt];
    }
    
    return [self hash:pass salt:salt algString:hashalgString];
}

+ (NSString*) base64DecodedUTF8StringWithString:(NSString*)string {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString*) hash:(NSString*)pass salt:(NSString*)salt algString:(NSString*)hashalgString {
    if ([hashalgString isEqualToString:@"none"]) {
        return [self none:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"simple"]) {
        return [self plain_text:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"md2"]) {
        return [self md2:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"md5"]) {
        return [self md5:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"double_md5"]) {
        return [self double_md5:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"sha1"]) {
        return [self sha1:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"sha256"]) {
        return [self sha256:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"sha384"]) {
        return [self sha384:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"sha512"]) {
        return [self sha512:pass withSalt:salt];
    } else if ([hashalgString isEqualToString:@"ldap-sha"]) {
        return [self ldap_sha1:pass withSalt:salt];
    } else {
        return nil;
    }
}

+ (NSString*) none:(NSString*)pass withSalt:(NSString*)salt {
    // pass (salt - не учитывается)
    return pass;
}

+ (NSString*) plain_text:(NSString*)pass withSalt:(NSString*)salt {
    // pass+{salt}
    NSMutableString* output = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [output appendFormat:@"{%@}", salt];
    return output;
}

+ (NSString*) md2:(NSString*)pass withSalt:(NSString*)salt {
    // md2 [pass+{salt}]
    NSMutableString* saltedInput = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [saltedInput appendFormat:@"{%@}", salt];
    NSData *data = [saltedInput dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD2_DIGEST_LENGTH];
    CC_MD2([data bytes], (CC_LONG)[data length], digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH*2]; for(int i = 0; i<CC_MD2_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",digest[i]];
    return output;
}

+ (NSString*) md5:(NSString*)pass withSalt:(NSString*)salt {
    // md5 [pass+{salt}]
    NSMutableString* saltedInput = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [saltedInput appendFormat:@"{%@}", salt];
    NSData *data = [saltedInput dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2]; for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",digest[i]];
    return output;
}

+ (NSString*) double_md5:(NSString*)pass withSalt:(NSString*)salt {
    // md5 (md5 [pass+{salt}] + salt])
    return [self md5:[self md5:pass withSalt:salt] withSalt:salt];
}

+ (NSString*) sha1:(NSString*)pass withSalt:(NSString*)salt {
    // sha1 [pass+{salt}]
    NSMutableString* saltedInput = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [saltedInput appendFormat:@"{%@}", salt];
    NSData *data = [saltedInput dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH*2]; for(int i = 0; i<CC_SHA1_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",digest[i]];
    return output;
}

+ (NSString*) sha256:(NSString*)pass withSalt:(NSString*)salt {
    // sha256 [pass+{salt}]
    NSMutableString* saltedInput = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [saltedInput appendFormat:@"{%@}", salt];
    NSData *data = [saltedInput dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2]; for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",digest[i]];
    return output;
}

+ (NSString*) sha384:(NSString*)pass withSalt:(NSString*)salt {
    // sha384 [pass+{salt}]
    NSMutableString* saltedInput = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [saltedInput appendFormat:@"{%@}", salt];
    NSData *data = [saltedInput dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA384_DIGEST_LENGTH];
    CC_SHA384(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA384_DIGEST_LENGTH*2]; for(int i = 0; i<CC_SHA384_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",digest[i]];
    return output;
}

+ (NSString*) sha512:(NSString*)pass withSalt:(NSString*)salt {
    // sha512 [pass+{salt}]
    NSMutableString* saltedInput = [NSMutableString stringWithFormat:@"%@", pass]; if (salt && salt.length > 0) [saltedInput appendFormat:@"{%@}", salt];
    NSData *data = [saltedInput dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH*2]; for(int i = 0; i<CC_SHA512_DIGEST_LENGTH; i++) [output appendFormat:@"%02x",digest[i]];
    return output;
}

+ (NSString*) ldap_sha1:(NSString*)pass withSalt:(NSString*)salt {
    // "{SSHA}" + (sha1 [pass+salt] + salt)]
    NSData *saltData = [[NSData alloc] initWithBase64EncodedString:salt options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (!saltData) {
        saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSData *passData = [pass dataUsingEncoding:NSUTF8StringEncoding]; NSMutableData *saltedInputData = [NSMutableData dataWithData:passData]; [saltedInputData appendData:saltData];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(saltedInputData.bytes, (CC_LONG)saltedInputData.length, digest);
    NSMutableData *hashSaltedInput = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH].mutableCopy;
    [hashSaltedInput appendData:saltData];
    
    NSString* output = [NSString stringWithFormat:@"{SSHA}%@", [hashSaltedInput base64EncodedStringWithOptions:0]];
    return output;
}
    
@end
