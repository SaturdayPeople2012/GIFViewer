//
//  AlbumPickerController.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"

@implementation ELCAlbumPickerController

@synthesize parent, assetGroups;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Loading..."];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
	[cancelButton release];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    [tempArray release];
    
    library = [[ALAssetsLibrary alloc] init];      

    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // Group enumerator Block
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
        {
            if (group == nil) 
            {
                return;
            }
            
            [self.assetGroups addObject:group];

            // Reload albums
            [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
        };
        
        // Group Enumerator Failure Block
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            NSLog(@"A problem occured %@", [error description]);	                                 
        };	
                
        // Enumerate Albums
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:assetGroupEnumerator 
                             failureBlock:assetGroupEnumberatorFailure];
        
        [pool release];
    });    
}

-(void)reloadTableView {
	
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Select an Album"];
}

-(void)selectedAssets:(NSArray*)_assets {
	
	[(ELCImagePickerController*)parent selectedAssets:_assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
#if 0 //wonbon
    NSInteger gCount = [g numberOfAssets];
#endif
    
    //TTT lkm- 이곳에서 그룹 카운트와 그룹이름을 표시한다.{
    NSString *imgGroupName = [g valueForProperty:ALAssetsGroupPropertyName];
    NSLog(@"imgGroupName: %@", imgGroupName);
    
    [g enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result == nil)
         {
<<<<<<< HEAD
=======
#warning Need work localized strings.
//lkm bug.
             //             UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"알림" message:@"사진첩에 로드할 GIF가 없습니다." delegate:self cancelButtonTitle:@"닫기" otherButtonTitles:nil, nil] autorelease];
//             alert.tag = kAlertTagEmptyGifFile;
//             [alert show];
>>>>>>> 6f60c5d6a780eed729db39d18f7847c3af93f697
             return;
         }
         //lkm - get data info
         NSLog(@"prepare result:%@", result);
         NSString* originalFileName = [[result defaultRepresentation] filename];
         NSURL *url = [[result defaultRepresentation] url];
         NSString * surl = [url absoluteString];
         NSString * ext = [surl substringFromIndex:[surl rangeOfString:@"ext="].location + 4];
         NSLog(@"org:%@, url:%@, surl:%@ ext:%@", originalFileName, url, surl, ext);
         
         //lkm - extract gif
         if ([[ext uppercaseString] isEqualToString:@"GIF"]) {
             groupImageCount++;
//             cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
             cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], groupImageCount];
             [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
             [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
         }
     }];
    groupImageCount = 0;
    
    //TTT }
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ELCAssetTablePicker *picker = [[ELCAssetTablePicker alloc] initWithNibName:@"ELCAssetTablePicker" bundle:[NSBundle mainBundle]];
	picker.parent = self;

    // Move me    
    picker.assetGroup = [assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
	[self.navigationController pushViewController:picker animated:YES];
	[picker release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{	
    [assetGroups release];
    [library release];
    [super dealloc];
}

@end

