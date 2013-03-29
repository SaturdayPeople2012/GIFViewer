//
//  ListViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

static NSString *kDeletePartialTitle = @"Delete (%d)";
static NSString *kDeleteAllTitle = @"Delete";

#import "ListViewController.h"
#import "GIFDetailViewController.h"

#define kListCellHeight 65.0f

@interface ListViewController ()
@property (strong, nonatomic)NSArray *fileLists;

@end

@implementation ListViewController
@synthesize  listData, editButton, cancelButton, deleteButton,gifDataArray,loadButton;

-(void) getDataFromDocumentFolder{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    self.fileLists = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *string in _fileLists) {
        [self.gifDataArray addObject:[string stringByDeletingPathExtension]];
    }
}//self.gifDataArray는 파일명만 갖고 있도록 했는데... 왜했는지는 까묵음..
- (UIImage *) getImageFromDocFolderAtIndex:(NSInteger)index{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *fileLists = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[fileLists objectAtIndex:index]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}



- (void)resetUI
{
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain
                                                target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *gridImage = [UIImage imageNamed:@"grid.png"];
    UIImage *listImage = [UIImage imageNamed:@"list.png"];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[gridImage,listImage]];
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    [segmentedControl addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.selectedSegmentIndex=1;
    segBtn = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];


    loadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goLoad:)];
//    loadButton.style = UIBarButtonSystemItemAdd;
//    loadButton.target = self;
//    loadButton.action = @selector(goLoad:);
//    
//    loadButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadButton, nil];
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.deleteButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    NSLog(@"resetui");
    // leave edit mode for our table and apply the edit button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.editButton;
    [self.tableView setEditing:NO animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"diddeselect\n");
    if (self.tableView.isEditing)
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        self.deleteButton.title = (selectedRows.count == 0) ?
        kDeleteAllTitle : [NSString stringWithFormat:kDeletePartialTitle,selectedRows.count];
        self.deleteButton.enabled = NO;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselectatindexpath\n");
    
    
    
    
	if (!self.tableView.isEditing)
    {
        
        GIFDetailViewController *detailViewController = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        g_gifPath =[documentsDirectory stringByAppendingPathComponent:[[manager contentsOfDirectoryAtPath:documentsDirectory error:nil]objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        
    }
    else
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        NSString *deleteButtonTitle = [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
        /*
        if (selectedRows.count == self.gifDataArray.count)
        {
            deleteButtonTitle = kDeleteAllTitle;
        }*/
        self.deleteButton.enabled = YES;
        if (selectedRows.count == 0) {
            self.deleteButton.enabled = NO;
            
        }
        self.deleteButton.title = deleteButtonTitle;
        
//        [manager removeItemAtPath: error:<#(NSError *__autoreleasing *)#>
    }
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    printf("Call NibName\n");
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    self.title = @"ListView";
    self.tableView.delegate = self;
    self.tableView.dataSource  =self;
    
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered
                                                target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.hidesBackButton = YES;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Grid",@"List"]];
    segmentedControl.frame = CGRectMake(0, 0, 130, 30);
    [segmentedControl addTarget:self action:@selector(selectedMode:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.selectedSegmentIndex=1;
    segBtn = [[UIBarButtonItem alloc]initWithCustomView:segmentedControl];
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    loadButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(load:) ];
    
    loadButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:flexible, segBtn,flexible, loadButton, nil];
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    
    //self.deleteButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    [self resetUI];
    /*
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    
    [self.tableView addGestureRecognizer:swipeGesture];
    */
    
    self.gifDataArray = [NSMutableArray array];
    [self getDataFromDocumentFolder];
    NSLog(@"EXIT VIEWDIDLOAD");
}
- (void)selectedMode:(UISegmentedControl *)control{
    if (control.selectedSegmentIndex == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    [control setSelectedSegmentIndex:1];
}
/*
-(void)swipe:(id)sender{
    NSLog(@"swipe\n");
    GridViewController *gridVC = [[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
    [self.navigationController popToViewController:self animated:YES];
    NSLog(@"dd");
    [self.navigationController pushViewController:gridVC animated:YES];
}
 */
-(void)load:(id)sender{
    NSLog(@"Call Load\n");
}
-(void)delete:(id)sender{
    NSLog(@"deleteaction\n");
    // open a dialog with just an OK button
	NSString *actionTitle = ([[self.tableView indexPathsForSelectedRows] count] == 1) ?
    @"Are you sure you want to remove this item?" : @"Are you sure you want to remove these items?";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showInView:self.view];	// show from our table view (pops up in the middle of the table)
    NSLog(@"Call Delete\n");
}

-(void)edit:(id)sender{
    

    
    self.toolbarItems = [NSArray arrayWithObjects:nil];
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    
    
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    deleteButton =[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(delete:)];
   // deleteButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.navigationItem.leftBarButtonItem = deleteButton;
    
    NSLog(@"editAction\n");
    // setup our UI for editing
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    

    
    // self.navigationItem.leftBarButtonItem = self.deleteButton;
    NSLog(@"editAction\n");
    // setup our UI for editing
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    
    self.deleteButton.title = @"Delete";
    self.deleteButton.enabled = NO;
    
    // self.navigationItem.leftBarButtonItem = self.deleteButton;
    
    [self.tableView setEditing:YES animated:YES];
    //self.toolbarItems = [NSArray arrayWithObjects:flexible,deleteButton,nil];
    
}


-(void)close:(id)sender{
    
    NSLog(@"cancle action\n");
    [self resetUI]; // reset our UI
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *arr = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    NSLog(@"actionSheet\n");
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
        
                NSLog(@"FFF");

        [self.tableView beginUpdates];
		// delete the selected rows
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        if (selectedRows.count > 0)
        {
            // setup our deletion array so they can all be removed at once
            NSMutableArray *deletionArray = [NSMutableArray array];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [deletionArray addObject:[self.gifDataArray objectAtIndex:selectionIndex.row]];
            }
            [self.gifDataArray removeObjectsInArray:deletionArray];
            
            
            
            
            if ([manager fileExistsAtPath:documentsDirectory]) {
                for (int i=0; i<[deletionArray count]; i++) {
                    [manager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:[arr objectAtIndex:i]] error:nil];
                }
            }
            
        }else{
            if ([manager fileExistsAtPath:documentsDirectory]) {
                for (int i=0; i<[gifDataArray count]; i++) {
                    [manager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:[arr objectAtIndex:i]] error:nil];
                }
            }
            [self.gifDataArray removeAllObjects];
            [self.tableView deleteRowsAtIndexPaths:gifDataArray withRowAnimation:UITableViewRowAnimationAutomatic];
            //[self.tableView endUpdates];
            // since we are deleting all the rows, just reload the current table section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
        // then delete the only the rows in our table that were selected
    }

    
    [self resetUI]; // reset our UI
    [self.tableView setEditing:NO animated:YES];
    
    self.editButton.enabled = (self.gifDataArray.count > 0) ? YES : NO;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowIndex");
    return kListCellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [self.gifDataArray count];
    //return 1;
}


- (void)goLoad:(id)sender{
    ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
	[elcPicker setDelegate:self];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    [self.tableView reloadData];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *arr = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSDictionary *dic = [[NSDictionary alloc] init];
    dic =[manager attributesOfItemAtPath:[documentsDirectory stringByAppendingPathComponent:[self.fileLists objectAtIndex:indexPath.row]] error:nil];
    ;
    NSLog(@"arr: %@ \n\n\n\n dic: %@",arr,dic);
    static NSString *CellIdentifier = @"BaseCell";
    ListCell *listCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (listCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[ListCell class]])
                listCell = (ListCell *)oneObject;
    }
    listCell.time.text = @"시간라벨";
    UIImage *thumnails = [self getImageFromDocFolderAtIndex:indexPath.row];
    listCell.title.text = [arr objectAtIndex:indexPath.row];
    listCell.gifImage.image = thumnails;
    NSString *tt = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:NSFileModificationDate ]];
    NSString *tt2 = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:NSFileSize]];
    NSRange range = [tt rangeOfString:@" "];

    if (range.location != NSNotFound) {
        NSString *str = [tt substringToIndex:range.location];
        listCell.date.text = str;
    }
    if ([tt2 floatValue] > 1024*64) {
        listCell.time.text = [NSString stringWithFormat:@"%.2fMB",tt2.floatValue/(1024*1024)];
        
    }else{
        listCell.time.text = [NSString stringWithFormat:@"%.2fKB",tt2.floatValue/(1024)];
    }
   [listCell.button addTarget:self action:@selector(openGIF:) forControlEvents:UIControlEventTouchUpInside];
    listCell.button.tag = indexPath.row;
    
    return listCell;
}


//todo 삭제 기능

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"titleForDelete\n");
    return @"Delete";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}




- (void)openGIF:(id)sender{
    UIButton *btn = sender;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    g_gifPath = [docsDir stringByAppendingPathComponent:[self.fileLists objectAtIndex:btn.tag]];
    GIFDetailViewController *detailViewController = [[GIFDetailViewController alloc]initWithNibName:@"GIFDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
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
