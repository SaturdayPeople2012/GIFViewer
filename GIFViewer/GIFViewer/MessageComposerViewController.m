

#import "MessageComposerViewController.h"

@implementation MessageComposerViewController
@synthesize feedbackMsg;


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[feedbackMsg release];
	[super dealloc];
}


#pragma mark -
#pragma mark Views lifecycle

- (void)viewDidUnload {
	self.feedbackMsg = nil;
}


// Support all orientations except for portrait upside-down.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark Show Mail/SMS picker

-(IBAction)showMailPicker:(id)sender {
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device 
	// can send emails.	Display feedback message, otherwise.
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));

	if (mailClass != nil) {
			//[self displayMailComposerSheet];
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail]) {
			[self displayMailComposerSheet];
		}
		else {
			feedbackMsg.hidden = NO;
			feedbackMsg.text = @"Device not configured to send mail.";
		}
	}
	else	{
		feedbackMsg.hidden = NO;
		feedbackMsg.text = @"Device not configured to send mail.";
	}
}


-(IBAction)showSMSPicker:(id)sender {
//	The MFMessageComposeViewController class is only available in iPhone OS 4.0 or later. 
//	So, we must verify the existence of the above class and log an error message for devices
//		running earlier versions of the iPhone OS. Set feedbackMsg if device doesn't support 
//		MFMessageComposeViewController API.
	Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
	
	if (messageClass != nil) { 			
		// Check whether the current device is configured for sending SMS messages
		if ([messageClass canSendText]) {
			[self displaySMSComposerSheet];
		}
		else {	
			feedbackMsg.hidden = NO;
			feedbackMsg.text = @"Device not configured to send SMS.";

		}
	}
	else {
		feedbackMsg.hidden = NO;
		feedbackMsg.text = @"Device not configured to send SMS.";
	}
}


#pragma mark -
#pragma mark Compose Mail/SMS

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayMailComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:@"Hello from California!"];
	
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"]; 
	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];	
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"It is raining in sunny California!";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}


// Displays an SMS composition interface inside the application. 
-(void)displaySMSComposerSheet 
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
}


#pragma mark -
#pragma mark Dismiss Mail/SMS view controller

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the 
// message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			feedbackMsg.text = @"Result: Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			feedbackMsg.text = @"Result: Mail saved";
			break;
		case MFMailComposeResultSent:
			feedbackMsg.text = @"Result: Mail sent";
			break;
		case MFMailComposeResultFailed:
			feedbackMsg.text = @"Result: Mail sending failed";
			break;
		default:
			feedbackMsg.text = @"Result: Mail not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


// Dismisses the message composition interface when users tap Cancel or Send. Proceeds to update the 
// feedback message field with the result of the operation.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
			  didFinishWithResult:(MessageComposeResult)result {
	
	feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			feedbackMsg.text = @"Result: SMS sending canceled";
			break;
		case MessageComposeResultSent:
			feedbackMsg.text = @"Result: SMS sent";
			break;
		case MessageComposeResultFailed:
			feedbackMsg.text = @"Result: SMS sending failed";
			break;
		default:
			feedbackMsg.text = @"Result: SMS not sent";
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}


@end
