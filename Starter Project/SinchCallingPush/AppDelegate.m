#import "AppDelegate.h"

@interface AppDelegate () <SINClientDelegate, SINCallClientDelegate>
//@property (nonatomic, readwrite, strong) id<SINManagedPush> push;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
      NSLog(@"onUserDidLogin");
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

#pragma mark -

- (void)initSinchClientWithUserId:(NSString *)userId {
  if (!_client) {
    _client = [Sinch clientWithApplicationKey:@"7c44fff7-3037-4f5b-8c6e-253ba2ac1004"
                            applicationSecret:@"XCoUAfw4XEyUhI6WOcAKyw=="
                              environmentHost:@"sandbox.sinch.com"
                                       userId:userId];
      NSLog(@"User id = %@", userId);

    _client.delegate = self;
    _client.callClient.delegate = self;

    [_client setSupportCalling:YES];
      [_client setSupportActiveConnectionInBackground:YES];
    [_client start];
      [_client startListeningOnActiveConnection];
  }
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

- (void)client:(id<SINClient>)client
    logMessage:(NSString *)message
          area:(NSString *)area
      severity:(SINLogSeverity)severity
     timestamp:(NSDate *)timestamp {
  if (severity == SINLogSeverityCritical) {
    NSLog(@"%@", message);
  }
}

@end