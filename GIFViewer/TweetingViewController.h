

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface TweetingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *easyTweetButton;
@property (strong, nonatomic) IBOutlet UIButton *customTweetButton;
@property (strong, nonatomic) IBOutlet UITextView *outputTextView;

- (IBAction)sendEasyTweet:(id)sender;
- (IBAction)sendCustomTweet:(id)sender;
- (IBAction)getPublicTimeline:(id)sender;
- (void)displayText:(NSString *)text;
- (void)canTweetStatus;

@end
