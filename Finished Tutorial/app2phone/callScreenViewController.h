//
//  callScreenViewController.h
//  app2phone
//
//  Created by Zachary Brown on 6/05/2015.
//  Copyright (c) 2015 Zac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
@protocol callScreenDelegate <NSObject>

-(void)mute;
-(void)unMute;
-(void)speaker;
-(void)speakerOff;
-(void)hangup;

@end


@interface callScreenViewController : UIViewController<SINCallDelegate>
@property (nonatomic, readwrite, strong) id<SINCall> call;
@property (nonatomic, weak) id<callScreenDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@end
