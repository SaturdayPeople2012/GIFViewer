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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
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
    self.title = kAppName;
    [self.gridView registerClass:[GridCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                            target:self action:@selector(goEdit:)];
    UIBarButtonItem *loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"Load" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(goLoad:)];
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                 UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.navigationItem.rightBarButtonItem = editBtn;
    //////////////////////////////////////////////////////
    //TODO: 추후 AppDelegate로 뺄것!
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Grid",@"List"]];
    segmentedControl.selectedSegmentIndex=0;
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    [segmentedControl addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segBtn = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    

    /////////////////////////////////////////////////////
    self.toolbarItems = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadBtn, nil];
    
    self.gifDataArray = [NSMutableArray array];
    
    [self getDataFromDocumentFolder];
}

- (void) selectedMode:(id)sender{
    UISegmentedControl *control = sender;
    //TODO: 추후 AppDelegate로 뺄것!
    switch (control.selectedSegmentIndex) {
        case kGridMode:   
            break;
        case kListMode:
            break;
        default:
            break;
    }
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
//    cell.gifImgView.image = thumnails;
    cell.button.imageView.image = thumnails;
    [cell.button addTarget:self action:@selector(openGIF:) forControlEvents:UIControlEventTouchUpInside];
    cell.button.tag = indexPath.row;
    
    return cell;
}

- (void)openGIF:(id)sender{
    UIButton *btn = sender;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [docsDir stringByAppendingPathComponent:[self.fileLists objectAtIndex:btn.tag]];
    GIFDetailViewController *detailViewController = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];

}


@end
