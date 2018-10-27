//
//  ServerManager.m
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager

+ (ServerManager*)sharedManager {
  static ServerManager* manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ServerManager alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self sendRequestToServer];
  }
  return self;
}

- (void)sendRequestToServer {
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:@"https://t20.isimplelab.com"]];
  [request setHTTPMethod:@"GET /rest/personal/ping"];
  [request setValue:@"SP Digest username=retail" forHTTPHeaderField:@"Authorization"];
  
  
  NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    NSLog(@"Response: %@", response);
    NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"Data: %@", requestReply);
  }] resume];
}

- (void)start {
  
  
}

@end
