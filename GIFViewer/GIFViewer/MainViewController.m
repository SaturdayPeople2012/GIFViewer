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


- (IBAction)activityButtonPressed:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        NSString *text = @"Lime Cat";
        UIImage *image = [UIImage imageNamed:@"lime-cat"];
        NSArray *activityItems = [NSArray arrayWithObjects:text,image , nil];
        UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems: activityItems applicationActivities:nil];
        [self presentViewController:avc animated:YES completion:nil];
    }
}

-(IBAction)goActivityButtonPressed:(id)sender{
    
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        NSString *text = @"'짤방 테스트 입니다'";
        
        UIImage *image = [UIImage imageNamed:@"Test2.gif"];
        NSArray *activityItems = [NSArray arrayWithObjects:text,image , nil];
        UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems: activityItems applicationActivities:nil];
        [self presentViewController:avc animated:YES completion:nil];
    }

    
    
    return;
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
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
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }
}

@end
