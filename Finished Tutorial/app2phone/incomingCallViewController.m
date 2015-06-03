//
//  incomingCallViewController.m
//  app2phone
//
//  Created by Zachary Brown on 29/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import "incomingCallViewController.h"

@interface incomingCallViewController ()

@end

@implementation incomingCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)setCall:(id<SINCall>)call {
    _call = call;
    _call.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)answer:(id)sender {
    //gogo
    [self performSegueWithIdentifier:@"acceptCall" sender:_call];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    callScreenViewController *acceptedCall = [segue destinationViewController];
    acceptedCall.call = sender;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)hangUp:(id)sender {
    [_call hangup];
    [self dismissViewControllerAnimated:YES completion:nil];
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
