//
//  ViewController.m
//  app2phone
//
//  Created by Zachary Brown on 6/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberLabel;
@property (nonatomic, strong) callScreenViewController *callScreen;
@end

@implementation ViewController

- (id<SINCallClient>)callClient {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] callClient];
}
- (id<SINAudioController>)audioController {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] audioController];
}




- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    
}
- (void)setDisplayName:(NSString *)displayName {
    
}
- (void)setDesiredPushTypeAutomatically {
    
}
- (IBAction)callButton:(id)sender {
    _call = [[self callClient] callUserWithId:self.userToCall.text];
    [self presentCallScreen:self.userToCall.text];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self clearTextBox];
}
- (void)clearTextBox {
    _numberLabel.text = @"";
}
- (void)presentCallScreen:(NSString *)phoneNumber {
    id<SINCall> call = [self call];
    [self performSegueWithIdentifier:@"acceptCall"sender:call];
     
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    incomingCallViewController *callViewController = [segue destinationViewController];
    callViewController.call = sender;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mute {
    id<SINAudioController> audio = [self audioController];
    [audio mute];
}
- (void)unMute {
    id<SINAudioController> audio = [self audioController];
    [audio unmute];
}
- (void)speaker {
    id<SINAudioController> audio = [self audioController];
    [audio enableSpeaker];
}
- (void)speakerOff {
    id<SINAudioController> audio = [self audioController];
    [audio disableSpeaker];
}
- (void)hangup {
    [_call hangup];
    [_callScreen dismissViewControllerAnimated:YES completion:nil];
}
@end
