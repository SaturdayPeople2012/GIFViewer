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

#import "ActivityViewCustomProvider.h"
#import "ActivityViewCustomActivity.h"



@interface MainViewController ()

@end

@implementation MainViewController

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
    GridViewController *gVC = [[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
    [self.navigationController pushViewController:gVC animated:NO];
    
}

- (void)goLoad:(id)sender{
    //기명
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)twitpicDidFinishUpload:(NSDictionary *)response {
    NSLog(@"TwitPic finished uploading: %@", response);
    
    // [response objectForKey:@"parsedResponse"] gives an NSDictionary of the response one of the parsing libraries was available.
    // Otherwise, use [[response objectForKey:@"request"] objectForKey:@"responseString"] to parse yourself.
    
    if ([[[response objectForKey:@"request"] userInfo] objectForKey:@"message"] > 0 && [[response objectForKey:@"parsedResponse"] count] > 0) {
        // Uncomment to update status upon successful upload, using MGTwitterEngine's instance.
        // [twitterEngine sendUpdate:[NSString stringWithFormat:@"%@ %@", [[[response objectForKey:@"request"] userInfo] objectForKey:@"message"], [[response objectForKey:@"parsedResponse"] objectForKey:@"url"]]];
    }
}

- (void)twitpicDidFailUpload:(NSDictionary *)error {
    NSLog(@"TwitPic failed to upload: %@", error);
    
    if ([[error objectForKey:@"request"] responseStatusCode] == 401) {
        // UIAlertViewQuick(@"Authentication failed", [error objectForKey:@"errorDescription"], @"OK");
    }
}

-(IBAction)goActivityButtonPressed:(id)sender{
    
    
    self.twitpicEngine = (GSTwitPicEngine *)[GSTwitPicEngine twitpicEngineWithDelegate:self];
    
    //[twitpicEngine setAccessToken:token];

    
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
