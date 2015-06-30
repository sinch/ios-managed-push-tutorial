#import "CallViewController.h"
#import "CallViewController+UI.h"
#import "AppDelegate.h"

@interface CallViewController () <SINCallDelegate>
@end

@implementation CallViewController

- (id<SINAudioController>)audioController {
  return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] audioController];
}

- (void)setCall:(id<SINCall>)call {
  _call = call;
  _call.delegate = self;
}

#pragma mark - UIViewController Cycle

- (void)viewDidLoad {
  [super viewDidLoad];

  if ([self.call direction] == SINCallDirectionIncoming) {
    [self setCallStatusText:@""];
    [self showButtons:kButtonsAnswerDecline];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
  } else {
    [self setCallStatusText:@"calling..."];
    [self showButtons:kButtonsHangup];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.remoteUsername.text = [self.call remoteUserId];
}

#pragma mark - Call Actions

- (IBAction)accept:(id)sender {
  [[self audioController] stopPlayingSoundFile];
  [self.call answer];
}

- (IBAction)decline:(id)sender {
  [self.call hangup];
  [self dismiss];
}

- (IBAction)hangup:(id)sender {
  [self.call hangup];
  [self dismiss];
}

- (void)onDurationTimer:(NSTimer *)unused {
  NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
  [self setDuration:duration];
}

#pragma mark - SINCallDelegate

- (void)callDidProgress:(id<SINCall>)call {
  [self setCallStatusText:@"ringing..."];
  [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)callDidEstablish:(id<SINCall>)call {
  [self startCallDurationTimerWithSelector:@selector(onDurationTimer:)];
  [self showButtons:kButtonsHangup];
  [[self audioController] stopPlayingSoundFile];
}

- (void)callDidEnd:(id<SINCall>)call {
    NSLog(@"Call did end");
  [self dismiss];
  [[self audioController] stopPlayingSoundFile];
  [self stopCallDurationTimer];
}

#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName {
  return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName];
}

@end
