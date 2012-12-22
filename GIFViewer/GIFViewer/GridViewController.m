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
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                            target:self action:@selector(goEdit:)];
    self.navigationItem.rightBarButtonItem = editBtn;
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
    
}

//기명이형 클래스와 연결
- (void)goLoad:(id)sender{
    
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
    /*
     여기가 터치 메소드
     
     if( !edit){
        UIButton *btn = sender;
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        g_gifPath = [docsDir stringByAppendingPathComponent:[self.fileLists objectAtIndex:btn.tag]];
        GIFDetailViewController *detailViewController = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];
         
        detailViewController.filePath = g_gifPath;
         
        [self.navigationController pushViewController:detailViewController animated:YES];
     
     
     }else{
        NSArray *TAGARRAY = [NS]태그번호를 저장
     
        NSMutableArray *deletionArray = [NSMutableArray array];
        for (NSIndexPath *selectionIndex in selectedRows)
        {
            [deletionArray addObject:[self.gifDataArray objectAtIndex:selectionIndex.row]];
        }
     }
     */
    UIButton *btn = sender;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    g_gifPath = [docsDir stringByAppendingPathComponent:[self.fileLists objectAtIndex:btn.tag]];
    GIFDetailViewController *detailViewController = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];
    
    detailViewController.filePath = g_gifPath;

    [self.navigationController pushViewController:detailViewController animated:YES];

}


@end
