//
//  ServerManager.h
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerManager : NSObject

+ (instancetype)new NS_UNAVAILABLE;
+ (ServerManager*)sharedManager;

@end
