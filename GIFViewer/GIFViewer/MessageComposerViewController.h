

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MessageComposerViewController : UIViewController <MFMailComposeViewControllerDelegate, 
MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate> {
	
	IBOutlet UILabel *feedbackMsg;
}

@property (nonatomic, retain) IBOutlet UILabel *feedbackMsg;

-(IBAction)showMailPicker:(id)sender;
-(IBAction)showSMSPicker:(id)sender;
-(void)displayMailComposerSheet;
-(void)displaySMSComposerSheet;


@end

