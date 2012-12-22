//
//  GridViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "GridViewController.h"
#import "GridCell.h"
#import "GIFDetailViewController.h"
#import "MainViewController.h"
#import "ListViewController.h"
#import "GifLoadViewController.h"


#define kGridMode 0
#define kListMode 1
@interface GridViewController ()
@property (strong, nonatomic)NSArray *fileLists;
@end

@implementation GridViewController
static NSString *CellIdentifier = @"Cell";

-(void) getDataFromDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    self.fileLists = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *string in _fileLists) {
        [self.gifDataArray addObject:[string stringByDeletingPathExtension]];
    }//self.gifDataArray는 파일명만 갖고 있도록 했는데... 왜했는지는 까묵음..
}
//각 Cell에 image 뿌리기위한 용도
- (UIImage *) getImageFromDocFolderAtIndex:(NSInteger)index{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *fileLists = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[fileLists objectAtIndex:index]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}


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
    self.navigationController.toolbarHidden = NO;
    
    UIBarButtonItem *loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"Load!!" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goLoad:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Grid",@"List"]];
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    [segmentedControl addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.selectedSegmentIndex=0;
    UIBarButtonItem *segBtn = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadBtn, nil];
    self.navigationItem.hidesBackButton = YES;
    
    
    self.title = @"GridView";
    [self.gridView registerClass:[GridCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    //    self.editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
    //                                                                            target:self action:@selector(goEdit:)];
    self.editBtn = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(goEdit:)];
    self.navigationItem.rightBarButtonItem = _editBtn;
    self.toolbarItems = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadBtn, nil];
    
    self.gifDataArray = [NSMutableArray array];
    
    [self getDataFromDocumentFolder];
}
- (void)selectedMode:(UISegmentedControl *)control{
    ListViewController *lVC = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
    if (control.selectedSegmentIndex == 1) {
        [self.navigationController pushViewController:lVC animated:NO];
    }
    [control setSelectedSegmentIndex:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIBarButton 관련 매서드
- (void)goEdit:(id)sender{

    _editMode  =!_editMode;
    if (_editMode) {
        self.title = @"Edit Mode";
        self.editBtn.title = @"Cancel";
        
    }else{
        self.title = @"Grid VIew";
        self.editBtn.title = @"Edit";
    }
}

//기명이형 클래스와 연결
- (void)goLoad:(id)sender{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}


#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_gifDataArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIImage *thumnails = [self getImageFromDocFolderAtIndex:indexPath.row];
    cell.gifImgView.image = thumnails;
    //    cell.button.imageView.image = thumnails;
    [cell.button addTarget:self action:@selector(openGIF:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = indexPath.row;
    NSLog(@"index :%d   x : %f , y : %f",indexPath.row,cell.button.frame.origin.x,cell.button.frame.origin.y);
    
    return cell;
}





- (void)openGIF:(id)sender{
    if(_editMode == YES){
        //태그저장 + 체크이미지
        /*
         [cell addcheck];
         */
    }else{
        UIButton *btn = sender;
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        g_gifPath = [docsDir stringByAppendingPathComponent:[self.fileLists objectAtIndex:btn.tag]];
        GIFDetailViewController *detailViewController = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];
        
//        detailViewController.filePath = g_gifPath;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - ELC Delegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
	
	[self dismissModalViewControllerAnimated:YES];
    for(NSDictionary *dict in info) {
        
        UIImage *gifImage = [dict objectForKey:UIImagePickerControllerOriginalImage];
        //document 경로
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"123.gif"];
	}
    
    
    //기명처리
    /*
     for (UIView *v in [scrollview subviews]) {
     [v removeFromSuperview];
     }
     
     CGRect workingFrame = scrollview.frame;
     workingFrame.origin.x = 0;
     
     for(NSDictionary *dict in info) {
     
     UIImageView *imageview = [[UIImageView alloc] initWithImage:[dict objectForKey:UIImagePickerControllerOriginalImage]];
     [imageview setContentMode:UIViewContentModeScaleAspectFit];
     imageview.frame = workingFrame;
     
     [scrollview addSubview:imageview];
     
     workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
     }
     
     [scrollview setPagingEnabled:YES];
     [scrollview setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
     */
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    
	[self dismissModalViewControllerAnimated:YES];
}



@end
