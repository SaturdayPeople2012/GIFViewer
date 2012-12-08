//
//  MainViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "MainViewController.h"
#import "GridViewController.h"
#import "ListViewController.h"
#import "GIFDetailViewController.h"
#import "ELCImagePickerDemoViewController.h"
#import "MessageComposerViewController.h"

#import "SA_OAuthTwitterEngine.h"

#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"



@interface MainViewController ()

@end

@implementation MainViewController
@synthesize twitpicEngine;
@synthesize engine;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goGridView:(id)sender {
    GridViewController *gridVC = [[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
    [self.navigationController pushViewController:gridVC animated:YES];
}



- (IBAction)goSMSView:(id)sender {
   // MessageComposerViewController *gridVC = [[MessageComposerViewController alloc]initWithNibName:@"MessageComposerViewController" bundle:nil];
   // [self.navigationController pushViewController:gridVC animated:YES];
}

- (IBAction)goListView:(id)sender {
    ListViewController *listVC = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)goGIFView:(id)sender {
    GIFDetailViewController *gifVC = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];
    [self.navigationController pushViewController:gifVC animated:YES];
}

- (IBAction)goGIFLoaderViewController:(id)sender {
    ELCImagePickerDemoViewController *elDemoViewController = [[ELCImagePickerDemoViewController alloc]initWithNibName:@"ELCImagePickerDemoViewController" bundle:nil];
    [self presentViewController:elDemoViewController animated:YES completion:nil];
}


//====================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
    
    NSLog(@"DATA: %@",data);
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    NSLog(@"DATA: %@",[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"]);
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//====================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    [twitpicEngine setAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey: @"authData"]];
    [twitpicEngine uploadPicture:[UIImage imageNamed:@"image.jpg"] withMessage:@"my test photo"];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//====================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}



//====================================================================================
#pragma mark GSTwitPicEngineDelegate
- (void)twitpicDidFinishUpload:(NSDictionary *)response {
    NSLog(@"TwitPic finished uploading: %@", response);
    
    // [response objectForKey:@"parsedResponse"] gives an NSDictionary of the response one of the parsing libraries was available.
    // Otherwise, use [[response objectForKey:@"request"] objectForKey:@"responseString"] to parse yourself.
    
    if ([[[response objectForKey:@"request"] userInfo] objectForKey:@"message"] > 0 && [[response objectForKey:@"parsedResponse"] count] > 0) {
        // Uncomment to update status upon successful upload, using MGTwitterEngine's instance.
        [engine sendUpdate:[NSString stringWithFormat:@"%@ %@", [[[response objectForKey:@"request"] userInfo] objectForKey:@"message"], [[response objectForKey:@"parsedResponse"] objectForKey:@"url"]]];
    }
}

- (void)twitpicDidFailUpload:(NSDictionary *)error {
    NSLog(@"TwitPic failed to upload: %@", error);
    
    if ([[error objectForKey:@"request"] responseStatusCode] == 401) {
        // UIAlertViewQuick(@"Authentication failed", [error objectForKey:@"errorDescription"], @"OK");
    }
}
//====================================================================================





-(IBAction)goActivityButtonPressed:(id)sender{
    
    
    self.twitpicEngine = (GSTwitPicEngine *)[GSTwitPicEngine twitpicEngineWithDelegate:self];
    
    //[twitpicEngine setAccessToken:token];

       
    
    
    SA_OAuthTwitterEngine *eng = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	self.engine = eng;
    [eng release];
	engine.consumerKey = "R1BhPnDtKjCFFRsMxzVIcw";
    engine.consumerSecret = "xFoPSV3rjANck3FHN9hSRyLBUH93Cq6DPu35AjsWy4A";
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:engine delegate:self];
	
	if (controller) {
		[self presentModalViewController:controller animated:YES];
	} else {
        [twitpicEngine setAccessToken:[engine getAccessToken]];
        [twitpicEngine uploadPicture:[UIImage imageNamed:@"image.jpg"] withMessage:@"my photo"];
	}

    
    return;
    
    
    ActivityViewCustomProvider *customProvider =
    [[ActivityViewCustomProvider alloc]init];
    
    NSString *text2 = @"'짤방 테스트 입니다'";
    UIImage *image2 = [UIImage imageNamed:@"Test2.gif"];
    
    NSArray *items = [NSArray arrayWithObjects:customProvider,text2,image2,nil];
    
    ActivityViewCustomActivity *ca = [[ActivityViewCustomActivity alloc]init];
    
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc] initWithActivityItems:items
                                      applicationActivities:[NSArray arrayWithObject:ca]];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll];
    
    activityVC.completionHandler = ^(NSString *activityType, BOOL completed)
    {
        NSLog(@" activityType: %@", activityType);
        NSLog(@" completed: %i", completed);
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
      /*  self.presentViewController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        
        [self.presentViewController
         presentPopoverFromRect:rect inView:self.view
         permittedArrowDirections:0
         animated:YES];
       */
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        [controller setInitialText:@"Uploaded by GifViewer App"];
        [controller addURL:[NSURL URLWithString:@"http://www.naver.com"]];
        [controller addImage:[UIImage imageNamed:@"fb.png"]];
        [self presentViewController:activityVC animated:YES completion:nil];

        
        
    } else if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        [self presentViewController:activityVC animated:YES completion:nil];

    } else{
        NSLog(@"UnAvailable");
    }
}

@end
