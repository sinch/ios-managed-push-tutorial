//
//  AppDelegate.m
//  app2phone
//
//  Created by Zachary Brown on 6/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import "AppDelegate.h"
#import <Sinch/Sinch.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
        NSLog(@"onUserDidLogin");
        [self setupSinchClientWithUserId:userId];
    };
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"UserDidLoginNotification"
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         NSString *userId = note.userInfo[@"userId"];
         [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         onUserDidLogin(userId);
     }];

    
    return YES;
}
- (void)setupSinchClientWithUserId:(NSString *)userId {
    _client = [Sinch clientWithApplicationKey:@"744713c1-ed4a-46cc-9f7f-aa8becddc919" applicationSecret:@"pA2X7hk390eMfYr9LjEY5Q==" environmentHost:@"sandbox.sinch.com" userId:userId];
    
    _client.delegate = self;
    _client.callClient.delegate = self;
    
    [_client setSupportCalling:YES];
    [_client setSupportActiveConnectionInBackground:YES];
    [_client start];
    [_client startListeningOnActiveConnection];
    NSLog(@"loggedIn and started client");
}
- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Remote notificaiton");
    if (!_client) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        if (userId) {
            [self setupSinchClientWithUserId:userId];
        }
    }
    [self.client relayRemotePushNotification:userInfo];
}
- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    NSLog(@"Local notification");
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    return notification;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Call delegate
- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    NSLog(@"incoming call");
    UIViewController *top = self.window.rootViewController;
    while (top.presentedViewController) {
        top = top.presentedViewController;
    }
    [top performSegueWithIdentifier:@"callView" sender:call];
}
@end
