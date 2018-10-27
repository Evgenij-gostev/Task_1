//
//  AppDelegate.m
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
                            didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  LoginViewController* controller = [[LoginViewController alloc] init];
  UINavigationController* navController = [[UINavigationController alloc]
                                           initWithRootViewController:controller];
  
  self.window.rootViewController = navController;
  
  return YES;
}

@end
