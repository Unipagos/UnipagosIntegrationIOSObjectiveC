//
//  ViewController.m
//  UnipagosIntegrationObjectiveC
//
//  Created by Leonardo Cid on 23/09/14.
//  Copyright (c) 2014 Unipagos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property IBOutlet UITextField *recipientText;
@property IBOutlet UITextField *amountText;
@property IBOutlet UITextField *refIdText;
@property IBOutlet UITextField *refText;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyButtonPressed:(UIButton*)button {
    NSMutableString *uri = [[NSMutableString alloc] init];
    NSString *recipientString = _recipientText.text;
    NSString *amountString = _amountText.text;
    NSString *refIdString = _refIdText.text;
    NSString *refString = _refText.text;
    [uri appendFormat:@"unipagos://pay?r=@(mdn:%@)&a=%@", recipientString, amountString];
    if (refIdString.length) {
        [uri appendFormat:@"&i=%@", refIdString];
    }
    if ([refString length]) {
        [uri appendFormat:@"&t=%@", refString];
    }
    [uri appendString:@"&url=unipagosIntegrationTest"];
    NSLog(@"%@", uri);
    NSURL *URL = [NSURL URLWithString: uri];
    NSLog(@"%@", URL);
    [[UIApplication sharedApplication] openURL:URL];
    
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag != 4) {
        UITextField *txtField = (UITextField *)[self.view viewWithTag:textField.tag + 1];
        [txtField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return false;
}

@end
