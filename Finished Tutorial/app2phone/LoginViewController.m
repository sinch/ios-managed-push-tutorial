//
//  LoginViewController.m
//  app2phone
//
//  Created by Zachary Brown on 29/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)go:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"object:nil userInfo:@{@"userId" : self.user.text}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
