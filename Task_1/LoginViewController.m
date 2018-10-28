//
//  LoginViewController.m
//  Task_1
//
//  Created by Евгений Гостев on 27.10.2018.
//  Copyright © 2018 Evgenij Gostev. All rights reserved.
//

#import "LoginViewController.h"
#import "InformationViewController.h"
#import "ServerManager.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"LOG IN";
    self.view.backgroundColor = [UIColor grayColor];
    
    // Add userNameLabel
    UILabel* userNameLabel = [[UILabel alloc] init];
    userNameLabel.frame = CGRectMake(30, 200, 100, 28);
    userNameLabel.text = @"User name";
    [self.view addSubview:userNameLabel];
    
    // Add userNameTextField
    UITextField* userNameTextField = [[UITextField alloc] init];
    userNameTextField.frame = CGRectMake(30, 230, self.view.frame.size.width - 60, 30);
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.secureTextEntry = YES;
    [self.view addSubview:userNameTextField];
    
    // Add userNameLabel
    UILabel* passwordLabel = [[UILabel alloc] init];
    passwordLabel.frame = CGRectMake(30, 260, 100, 28);
    passwordLabel.text = @"Password";
    [self.view addSubview:passwordLabel];
    
    // Add userNameTextField
    UITextField* passwordTextField = [[UITextField alloc] init];
    passwordTextField.frame = CGRectMake(30, 290, self.view.frame.size.width - 60, 30);
    passwordTextField.backgroundColor = [UIColor whiteColor];
    passwordTextField.secureTextEntry = YES;
    [self.view addSubview:passwordTextField];
    
    // Add loginButton
    UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake((self.view.frame.size.width / 2) - 50, 500, 100, 30);
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor blueColor];
    loginButton.titleLabel.textColor = [UIColor whiteColor];
    [loginButton addTarget:self
                    action:@selector(actionLogin:)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void) loadView {
      [super loadView];
    
//      self.navigationItem.title = @"LOG IN";
//      self.view.backgroundColor = [UIColor grayColor];
//
//
//      // Add userNameLabel
//      UILabel* userNameLabel = [[UILabel alloc] init];
//      userNameLabel.frame = CGRectMake(30, 200, 100, 28);
//      userNameLabel.text = @"User name";
//      [self.view addSubview:userNameLabel];
//      // Add userNameTextField
//      UITextField* userNameTextField = [[UITextField alloc] init];
//      userNameTextField.frame = CGRectMake(30, 230, self.view.frame.size.width - 60, 30);
//      userNameTextField.backgroundColor = [UIColor whiteColor];
//      userNameTextField.secureTextEntry = YES;
//      [self.view addSubview:userNameTextField];
//      // Add userNameLabel
//      UILabel* passwordLabel = [[UILabel alloc] init];
//      passwordLabel.frame = CGRectMake(30, 260, 100, 28);
//      passwordLabel.text = @"Password";
//      [self.view addSubview:passwordLabel];
//      // Add userNameTextField
//      UITextField* passwordTextField = [[UITextField alloc] init];
//      passwordTextField.frame = CGRectMake(30, 290, self.view.frame.size.width - 60, 30);
//      passwordTextField.backgroundColor = [UIColor whiteColor];
//      passwordTextField.secureTextEntry = YES;
//      [self.view addSubview:passwordTextField];
//      // Add loginButton
//      UIButton* loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//      loginButton.frame = CGRectMake((self.view.frame.size.width / 2) - 50, 500, 100, 30);
//      [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
//      loginButton.backgroundColor = [UIColor blueColor];
//      loginButton.titleLabel.textColor = [UIColor whiteColor];
//      [loginButton addTarget:self
//                      action:@selector(actionLogin:)
//            forControlEvents:UIControlEventTouchUpInside];
//      [self.view addSubview:loginButton];
}

- (void)actionLogin:(UIButton *)sender {
    ServerManager *serverManager = [ServerManager sharedManager];
    
    [serverManager loginWithLogin:@"retail"
                         password:@"retail"
                          handler:^(NSError * _Nullable error) {
        if (!error) {
            InformationViewController* informationVC = [[InformationViewController alloc] init];
            [self.navigationController pushViewController:informationVC animated:YES];
        } else {
            //show error with alert
        }
    }];
}

@end
