//
//  AppDelegate.h
//  app2phone
//
//  Created by Zachary Brown on 6/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, SINClientDelegate, SINCallClientDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) id<SINClient> client;

@end

