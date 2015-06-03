#import "AppDelegate.h"

@interface AppDelegate () <SINClientDelegate, SINCallClientDelegate, SINManagedPushDelegate>
@property (nonatomic, readwrite, strong) id<SINManagedPush> push;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
  self.push.delegate = self;
  [self.push setDesiredPushTypeAutomatically];

  void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
      NSLog(@"onUserDidLogin");
    [self.push registerUserNotificationSettings];
      [self initSinchClientWithUserId:userId];
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Remote notification");
  [self.push application:application didReceiveRemoteNotification:userInfo];
}

#pragma mark -

- (void)initSinchClientWithUserId:(NSString *)userId {
  if (!_client) {
    _client = [Sinch clientWithApplicationKey:@"7c44fff7-3037-4f5b-8c6e-253ba2ac1004"
                            applicationSecret:@"XCoUAfw4XEyUhI6WOcAKyw=="
                              environmentHost:@"sandbox.sinch.com"
                                       userId:userId];

    _client.delegate = self;
    _client.callClient.delegate = self;
    [_client setSupportCalling:YES];
    [_client enableManagedPushNotifications];
    [_client start];
      [_client startListeningOnActiveConnection];
  }
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Handle Remote notificaiton");
  if (!_client) {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if (userId) {
      [self initSinchClientWithUserId:userId];
    }
  }
  [self.client relayRemotePushNotification:userInfo];
}

#pragma mark - SINManagedPushDelegate

- (void)managedPush:(id<SINManagedPush>)unused
    didReceiveIncomingPushWithPayload:(NSDictionary *)payload
                              forType:(NSString *)pushType {
    NSLog(@"Incoming push");
  [self handleRemoteNotification:payload];
}

#pragma mark - SINCallClientDelegate

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
  // Find MainViewController and present CallViewController from it.
    NSLog(@"Incoming call");
  UIViewController *top = self.window.rootViewController;
  while (top.presentedViewController) {
    top = top.presentedViewController;
  }
  [top performSegueWithIdentifier:@"callView" sender:call];
}

- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    NSLog(@"Local notification");
  SINLocalNotification *notification = [[SINLocalNotification alloc] init];
  notification.alertAction = @"Answer";
  notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
  return notification;
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client {
  NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
  NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

@end