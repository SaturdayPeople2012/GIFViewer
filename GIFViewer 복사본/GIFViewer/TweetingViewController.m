
#import "TweetingViewController.h"

@implementation TweetingViewController

@synthesize outputTextView, easyTweetButton, customTweetButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.easyTweetButton = nil;
    self.customTweetButton = nil;
    self.outputTextView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self canTweetStatus];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)sendEasyTweet:(id)sender {
  
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    [tweetViewController setInitialText:@"Hello. This is a tweet."];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                output = @"취소버튼 클릭";
                break;
            case TWTweetComposeViewControllerResultDone:
                output = @"트윗 완료.";
                break;
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        [self dismissModalViewControllerAnimated:YES];
    }];
    
  
    [self presentModalViewController:tweetViewController animated:YES];
}


- (IBAction)sendCustomTweet:(id)sender {

	ACAccountStore *accountStore = [[ACAccountStore alloc] init];

    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
	[accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if(granted) {
			
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
			
			if ([accountsArray count] > 0) {
				
				ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
				
				TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1.1/statuses/update.json"] parameters:[NSDictionary dictionaryWithObject:@"Hello. This is a tweet." forKey:@"status"] requestMethod:TWRequestMethodPOST];
				
				[postRequest setAccount:twitterAccount];
				
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
					NSString *output = [NSString stringWithFormat:@"HTTP response status: %i", [urlResponse statusCode]];
					[self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
				}];
			}
        }
	}];
}


- (IBAction)getPublicTimeline:(id)sender {
	
	TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/public_timeline.json"] parameters:nil requestMethod:TWRequestMethodGET];
	
	[postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		NSString *output;
		
		if ([urlResponse statusCode] == 200) {
			NSError *jsonParsingError = nil;
			NSDictionary *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
			output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic timeline:\n%@", [urlResponse statusCode], publicTimeline];
		}
		else {
			output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
		}
		
		[self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
	}];
}


- (void)displayText:(NSString *)text {
	self.outputTextView.text = text;
}

- (void)canTweetStatus {
    if ([TWTweetComposeViewController canSendTweet]) {
        self.easyTweetButton.enabled = YES;
        self.easyTweetButton.alpha = 1.0f;
        self.customTweetButton.enabled = YES;
        self.customTweetButton.alpha = 1.0f;
    } else {
        self.easyTweetButton.enabled = NO;
        self.easyTweetButton.alpha = 0.5f;
        self.customTweetButton.enabled = NO;
        self.customTweetButton.alpha = 0.5f;
    }
}


@end
