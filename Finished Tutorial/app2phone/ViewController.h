//
//  ViewController.h
//  app2phone
//
//  Created by Zachary Brown on 6/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "callScreenViewController.h"
#import "incomingCallViewController.h"
#import <Sinch/SINManagedPush.h>
@interface ViewController : UIViewController <callScreenDelegate, incomingCallProtocol>
//sinclientdelegate added
@property (weak, nonatomic) IBOutlet UITextField *userToCall;
@property (nonatomic, strong) id<SINCall> call;
@end

