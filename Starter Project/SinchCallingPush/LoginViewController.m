#import "LoginViewController.h"
#import "CallViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.nameTextField becomeFirstResponder];
}

- (IBAction)onLoginButtonPressed:(id)sender {
  if ([self.nameTextField.text length] == 0) {
    return;
  }

  [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification"
                                                      object:nil
                                                    userInfo:@{@"userId" : self.nameTextField.text}];

  [self performSegueWithIdentifier:@"mainView" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // If a remote notification was received which led to the application being started, the may have a transition from
  // the login view controller directly to an incoming call view controller.
  if ([[segue identifier] isEqualToString:@"callView"]) {
    CallViewController *callViewController = [segue destinationViewController];
    callViewController.call = sender;
  }
}

@end
