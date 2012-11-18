//
//  ListViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

static NSString *kDeleteAllTitle = @"Delete All";
static NSString *kDeletePartialTitle = @"Delete (%d)";

#import "ListViewController.h"

#define kListCellHeight 112.0f

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize  listData, editButton, cancelButton, deleteButton;

- (void)resetUI
{
    
    NSLog(@"resetui");
    // leave edit mode for our table and apply the edit button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = self.editButton;
    [self.tableView setEditing:NO animated:YES];
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    loadButton = [[UIBarButtonItem alloc] initWithTitle:@"load" style:UIBarButtonItemStyleBordered target:self action:@selector(load:)];
    loadButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:flexible,loadButton,nil];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"diddeselect\n");
    if (self.tableView.isEditing)
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        self.deleteButton.title = (selectedRows.count == 0) ?
        kDeleteAllTitle : [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselectatindexpath\n");
	if (!self.tableView.isEditing)
    {
        self.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        //[[self navigationController] pushViewController:self.viewController animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        NSString *deleteButtonTitle = [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
        
        if (selectedRows.count == self.listData.count)
        {
            deleteButtonTitle = kDeleteAllTitle;
        }
        self.deleteButton.title = deleteButtonTitle;
    }
}

- (void)viewDidUnload
{
    NSLog(@"view did unload");
	[super viewDidUnload];
    
    
    self.editButton = nil;
    self.cancelButton = nil;
    self.deleteButton = nil;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    printf("Call NibName\n");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *testArray = [[NSMutableArray alloc] initWithObjects:@"a",@"b",@"c",nil];
    self.listData = testArray;
    
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered
                                                target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    
    
    
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    loadButton = [[UIBarButtonItem alloc]initWithTitle:@"Load" style:UIBarButtonItemStyleBordered
                                                target:self action:@selector(load:)];
    loadButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:flexible,loadButton,nil];
    
    
    NSLog(@"view did load");
	[super viewDidLoad];
	
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    self.deleteButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    [self resetUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

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
    
    
    cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    deleteButton =[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(delete:)];
    deleteButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    
    
    
    
    
    
    
    
    
    
    NSLog(@"editAction\n");
    // setup our UI for editing
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    
    self.deleteButton.title = kDeleteAllTitle;
    
    // self.navigationItem.leftBarButtonItem = self.deleteButton;
    
    [self.tableView setEditing:YES animated:YES];
    self.toolbarItems = [NSArray arrayWithObjects:flexible,deleteButton,nil];
    
}


-(void)close:(id)sender{
    NSLog(@"cancle action\n");
    [self resetUI]; // reset our UI

}
/*
 //액션시트
 
 -(void)buttonPressed{
 NSLog(@"삭제합니까?\n");
 UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"지우시겠습니까?" delegate:self cancelButtonTitle:@"취 소" destructiveButtonTitle:@"삭 제" otherButtonTitles:nil];
 [actionSheet showInView:self.view];
 
 }
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet\n");
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		// delete the selected rows
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        if (selectedRows.count > 0)
        {
            // setup our deletion array so they can all be removed at once
            NSMutableArray *deletionArray = [NSMutableArray array];
            for (NSIndexPath *selectionIndex in selectedRows)
            {
                [deletionArray addObject:[self.listData objectAtIndex:selectionIndex.row]];
            }
            [self.listData removeObjectsInArray:deletionArray];
            
            // then delete the only the rows in our table that were selected
            [self.tableView deleteRowsAtIndexPaths:selectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            [self.listData removeAllObjects];
            
            // since we are deleting all the rows, just reload the current table section
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self resetUI]; // reset our UI
        [self.tableView setEditing:NO animated:YES];
        
        self.editButton.enabled = (self.listData.count > 0) ? YES : NO;
	}
    

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    printf("셀 리턴\n");
    
    
    static NSString *CellIdentifier = @"Cell";
    ListCell *listCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (listCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListCell" owner:self options:nil];
        
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[ListCell class]])
                listCell = (ListCell *)oneObject;
    }
    listCell.time.text = @"시간라벨";
    
    UIImage *image = [UIImage imageNamed:@"apple_logo_animated.gif"];
    listCell.gifImage.image = image;
    
    NSUInteger row = [indexPath row];
    listCell.title.text = [listData objectAtIndex:row];
    //[self.view reloadInputViews];
    
    return listCell;
}

- (void) loadView
{
    //수신 노티피케이션
    NSNotificationCenter *nc = [ NSNotificationCenter defaultCenter ];
    [nc addObserver:self selector:@selector(viewchange:) name:@"cellInfo" object:nil];
    
    [super loadView];
    printf("로드뷰\n");
}

-(void)viewChange:(id)sender{
    NSLog(@"뷰전환 메소드 구현해야됨\n");
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
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
