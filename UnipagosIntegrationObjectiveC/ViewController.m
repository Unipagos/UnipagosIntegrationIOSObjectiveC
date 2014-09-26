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
    
    //it's important that the url callback has the suffix "://"
         [uri appendString:[NSString stringWithFormat:@"%@%@%@",
                       @"&url=",
                       [self getRegisteredURLScheme],
                       @"://"]];

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    if (textField == _recipientText) {
        NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression = @"^([0-9]*)(\\.([0-9]+)?)?$";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger noOfMatches = [regex numberOfMatchesInString:newStr
                                                        options:0
                                                          range:NSMakeRange(0, [newStr length])];
        
        if (newLength > 12) {
            return NO;
        }
        if (noOfMatches==0){
            return NO;
        }
        return YES;
    }
    
    else if (textField == _amountText){
        static NSString *numbers = @"0123456789";
        static NSString *numbersPeriod = @"01234567890.";
        static NSString *numbersComma = @"0123456789,";
                
        //NSLog(@"%d %d %@", range.location, range.length, string);
        if (range.length > 0 && [string length] == 0) {
            // enable delete
            return YES;
        }

            NSString *symbol = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
            if (range.location == 0 && [string isEqualToString:symbol]) {
                // decimalseparator should not be first
                return NO;
            }
            NSCharacterSet *characterSet;
            NSRange separatorRange = [textField.text rangeOfString:symbol];
            if (separatorRange.location == NSNotFound) {
                if ([symbol isEqualToString:@"."]) {
                    characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersPeriod] invertedSet];
                }
                else {
                    characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbersComma] invertedSet];
                }
            }
            else {
                // allow 2 characters after the decimal separator
                if (range.location > (separatorRange.location + 2)) {
                    return NO;
                }
                characterSet = [[NSCharacterSet characterSetWithCharactersInString:numbers] invertedSet];
            }
            return ([[string stringByTrimmingCharactersInSet:characterSet] length] > 0);
    }
    return YES;
}

-(NSString*)getRegisteredURLScheme{
    NSBundle* mainBundle = [NSBundle mainBundle];
    
    NSArray* cfBundleURLTypes = [mainBundle objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    if ([cfBundleURLTypes isKindOfClass:[NSArray class]] && [cfBundleURLTypes lastObject]) {
        NSDictionary* cfBundleURLTypes0 = [cfBundleURLTypes objectAtIndex:0];
        if ([cfBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
            NSArray* cfBundleURLSchemes = [cfBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
            if ([cfBundleURLSchemes isKindOfClass:[NSArray class]]) {
                for (NSString* scheme in cfBundleURLSchemes) {
                    if ([scheme isKindOfClass:[NSString class]]) {
                        return scheme;
                    }
                }
            }
        }
    }
    return nil;
}

@end
