//
//  Information.h
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Information : NSObject

@property (strong, nonatomic) NSString* accountNumber;
@property (strong, nonatomic) NSString* sum;

- (instancetype)initWithAccountNumber:(NSString*) accountNumber
                                  sum:(NSString*) sum
                             currency:(NSString*) currency;

@end
