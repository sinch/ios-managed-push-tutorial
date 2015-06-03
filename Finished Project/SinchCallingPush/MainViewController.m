#import "MainViewController.h"
#import "CallViewController.h"
#import "AppDelegate.h"

#import <Sinch/Sinch.h>

@implementation MainViewController

- (id<SINCallClient>)callClient {
  return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] callClient];
}

- (IBAction)call:(id)sender {
  if ([self.destination.text length] > 0) {
    id<SINCall> call = [[self callClient] callUserWithId:self.destination.text];
      NSLog(@"Call client = %@", [self callClient]);
      NSLog(@"Self.destination = %@", self.destination.text);
    [self performSegueWithIdentifier:@"callView" sender:call];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CallViewController *callViewController = [segue destinationViewController];
  callViewController.call = sender;
}

@end
