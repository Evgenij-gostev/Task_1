//
//  Information.m
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "Information.h"

@implementation Information

- (instancetype)initWithAccountNumber:(NSString*) accountNumber
                                  sum:(NSString*) sum
                             currency:(NSString*) currency {
  self = [super init];
  if (self) {
    self.accountNumber = accountNumber;
    self.sum = [NSString stringWithFormat:@"%@ %@", sum, currency];
  }
  return self;
}

@end
