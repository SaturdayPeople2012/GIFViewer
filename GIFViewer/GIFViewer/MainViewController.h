//
//  MainViewController.h
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Accounts/Accounts.h>
#import "MessageComposerViewController.h"
#import "GSTwitPicEngine.h"

#import "SA_OAuthTwitterController.h"


@class SA_OAuthTwitterEngine;

@class ListViewController,GridViewController;

@interface MainViewController : UIViewController <GSTwitPicEngineDelegate>

@property (strong, nonatomic) ListViewController *listVC;
@property (strong, nonatomic) GridViewController *gridVC;


- (IBAction)goActivityButtonPressed:(id)sender;
- (IBAction)SMSTest:(id)sender;
- (IBAction)goGridView:(id)sender;
- (IBAction)goListView:(id)sender;
- (IBAction)goGIFView:(id)sender;
- (IBAction)goGIFLoaderViewController:(id)sender;
- (IBAction)goSMSView:(id)sender;




   
- (IBAction)activityButtonPressed:(id)sender;


@property (nonatomic, retain) GSTwitPicEngine *twitpicEngine;
@property (nonatomic, retain) SA_OAuthTwitterEngine *engine;

@end
