//
//  MailViewController.m
//  GIFViewer
//
//  Created by Beatrice Dalle on 10/28/12.
//  Copyright (c) 2012 양원석. All rights reserved.
//

#import "MailViewController.h"

@interface MailViewController ()
@end

@implementation MailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnComposeEmail:(id)sender {
    MFMailComposeViewController *picker =
    [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Email subject here"];
    [picker setMessageBody:@"Email body here" isHTML:NO];

    //iOS 5.0 이상이면
    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)])
        [self presentViewController:picker animated:YES completion:nil];
    else
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [self presentModalViewController:picker animated:YES];
    
}

- (void) mailComposeController:(MFMailComposeViewController *) controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        [controller dismissViewControllerAnimated:YES completion:nil];
    else
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [controller dismissModalViewControllerAnimated:YES];
}

@end
