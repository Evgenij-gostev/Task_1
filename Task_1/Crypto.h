//
//  Crypto.h
//  Task_1
//
//  Created by Антон Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Crypto : NSObject

 + (NSString*) hash:(NSString*)pass salt:(NSString*)salt algString:(NSString*)hashalgString base64SaltEncode: (BOOL)base64SaltEncode;

@end
