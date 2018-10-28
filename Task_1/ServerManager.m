//
//  ServerManager.m
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "ServerManager.h"
#import "Crypto.h"
#import <CommonCrypto/CommonDigest.h>


static NSString *baseUrlString = @"https://demo.isimplelab.com";
static NSString *URI = @"/rest/personal/ping";

@implementation ServerManager

+ (ServerManager*)sharedManager {
  static ServerManager* manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ServerManager alloc] init];
  });
  return manager;
}

- (void)loginWithLogin:(NSString *)login
              password:(NSString *)password
               handler:(void (^)(NSError * _Nullable error))completionHandler {
   
    NSString *authorizationValue = [NSString stringWithFormat:@"SP Digest username=\"%@\"", login];

    [self sendRequestWith:authorizationValue completion:^(NSHTTPURLResponse *response, NSError *error) {
         int nc = 0;
        
        NSString *authenticateHeadersString = response.allHeaderFields[@"Www-Authenticate"];

        authenticateHeadersString = [authenticateHeadersString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        authenticateHeadersString = [authenticateHeadersString stringByReplacingOccurrencesOfString:@"SP Digest " withString:@""];
        
        //parse values
        NSArray *objects = [authenticateHeadersString componentsSeparatedByString:@", "];
        NSMutableDictionary *authenticateHeaders = [[NSMutableDictionary alloc] init];
        for (NSString *str in objects)
        {
            NSArray *keyValue = [str componentsSeparatedByString:@"="];

            [authenticateHeaders setObject:keyValue[1]
                                    forKey:keyValue[0]];
        }

        authenticateHeaders[@"cnonce"] = [self generateCnonce];
        
//        authenticateHeaders[@"realm"] = @"SD Digest Authentication Realm";
//        authenticateHeaders[@"qop"] = @"auth";
//        authenticateHeaders[@"nonce"] = @"MTUyMjU1NzE4NTkzNzozN2JmZWQ3NmViMDgyMWFhZDM2NzAyN2YxM2Y4NGY2NA==";
//        authenticateHeaders[@"salt"] = @"MXksME1YblBHMkYyWH4rVytTeD9iaT9GJnE2dW0j";
//        authenticateHeaders[@"hashalg"] = @"md5";
//        authenticateHeaders[@"cnonce"] = @"46b7d23cb36efac10bb5662f8d673c7f";
        
        nc++;
        
        NSString *responseString =
            [self generateResponseStringWithHeaders:authenticateHeaders
                                              login:login
                                           password:password
                                          digestURI:URI
                                                 nc:nc];
        NSString *authValue =
            [NSString stringWithFormat:@"SP Digest username=\"%@\", realm=\"%@\", nonce=\"%@\", uri=\"%@\", response=\"%@\", qop=\"%@\", nc=\"%@\", cnonce=\"%@\"",
             login,
             authenticateHeaders[@"realm"],
             authenticateHeaders[@"nonce"],
             URI,
             responseString,
             authenticateHeaders[@"qop"],
             [NSString stringWithFormat:@"%08lx", (unsigned long)nc],
             authenticateHeaders[@"cnonce"]];
        
        
        [self sendRequestWith:authValue completion:^(NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Response2: %@", response);
        }];
    }];
}

- (void)sendRequestWith:(NSString *)authorizationValue completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completionHandler {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseUrlString, URI];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:authorizationValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    //тут написано почему NSURLResponse -> NSHTTPURLResponse https://developer.apple.com/documentation/foundation/nsurlresponse
                    completionHandler ? completionHandler((NSHTTPURLResponse *)response, error) : nil;
                    
                }] resume];
}

//Генерируем запрос
- (NSString *)generateResponseStringWithHeaders:(NSMutableDictionary*)headers
                                          login:(NSString *)login
                                       password:(NSString *)password
                                      digestURI:(NSString *)digestURI
                                             nc:(int)nc{
    NSString* saltedPass = [Crypto hash:password salt:headers[@"salt"] algString:headers[@"hashalg"] base64SaltEncode:YES];
    //Получаем HА1
    NSString* a1 = [NSString stringWithFormat:@"%@:%@:%@", login, headers[@"realm"], saltedPass];
    a1 = [self md5String:a1];
    // Получаем HА2
    NSString* a2 = [self md5String:[NSString stringWithFormat:@"GET:%@", digestURI]];

    //Собираем все вместе
    NSString *resp = [NSString stringWithFormat:@"%@:%@:%@:%@:%@",
                      a1,
                      headers[@"nonce"],
                      [NSString stringWithFormat:@"%08lx",
                       (unsigned long)nc],
                      headers[@"cnonce"],
                      headers[@"qop"]];
    
    resp = [resp stringByAppendingFormat:@":%@", a2];
    resp = [self md5String:resp];
    return resp;
}

//Случайный 128-знаковый код
- (NSString *)generateCnonce {
    NSString *randomString=@"";
    for (int i=0; i<128; i++)
    {
        randomString = [randomString stringByAppendingString:[[NSString alloc] initWithFormat:@"%ld",random()%9]];
    }
    
    NSData* randomData = [randomString dataUsingEncoding:NSStringEncodingConversionAllowLossy];
    return [self md5StringForData:randomData];
}

//------------For hashalg md5
- (NSString *)md5StringForData:(NSData *) data {
    unsigned char result[16];
    CC_MD5([data bytes], (CC_LONG)[data length], result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

- (NSString *)md5String:(NSString*)string {
    const char *cstr = [string UTF8String];
    return [self md5StringForData:[[NSData alloc] initWithBytes:cstr length:strlen(cstr)]];
}
//------------------------------

@end
