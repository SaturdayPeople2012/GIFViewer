//
//  AlbumPickerController.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kAlertTagEmptyGifFile 1

@interface ELCAlbumPickerController : UITableViewController <UIAlertViewDelegate>
{
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id parent;
    NSInteger groupImageCount;
    
    ALAssetsLibrary *library;
}

@property (nonatomic, assign) id parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;

-(void)selectedAssets:(NSArray*)_assets;

@end

