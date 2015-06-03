//
//  incomingCallViewController.h
//  app2phone
//
//  Created by Zachary Brown on 29/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "callScreenViewController.h"
@protocol incomingCallProtocol <NSObject>
- (void)answer;
@end
@interface incomingCallViewController : UIViewController <SINCallDelegate>
@property (nonatomic, readwrite, strong) id<SINCall> call;
@property (nonatomic, strong) id<incomingCallProtocol> delegate;
@end
