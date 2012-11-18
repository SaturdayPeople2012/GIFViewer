//
//  ListViewController.m
//  GIFViewer
//
//  Created by 양원석 on 12. 10. 22..
//  Copyright (c) 2012년 양원석. All rights reserved.
//

#import "ListViewController.h"

#define kListCellHeight 112.0f

@interface ListViewController ()

@end

@implementation ListViewController
@synthesize listData;

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
    
    NSArray *testArray = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",nil];
    self.listData = testArray;
    
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    
    
    
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    loadButton = [[UIBarButtonItem alloc]initWithTitle:@"Load" style:UIBarButtonItemStyleBordered
                                                              target:self action:@selector(load:)];
    loadButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:flexible,loadButton,nil];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)load:(id)sender{
    NSLog(@"Call Load\n");
}
-(void)delete:(id)sender{
    [self buttonPressed];
    NSLog(@"Call Delete\n");
}
-(void)edit:(id)sender{
    NSLog(@"Call Edit\n");
    closeButton = [[UIBarButtonItem alloc] initWithTitle:@"close" style:UIBarButtonItemStyleBordered target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    
    
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    deleteButton =[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(delete:)];
    deleteButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    
    self.toolbarItems = [NSArray arrayWithObjects:flexible,deleteButton,nil];
    
}


-(void)close:(id)sender{
    NSLog(@"Call close\n");
    editButton = [[UIBarButtonItem alloc]initWithTitle:@"편집" style:UIBarButtonItemStyleBordered
                                                target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    loadButton = [[UIBarButtonItem alloc] initWithTitle:@"load" style:UIBarButtonItemStyleBordered target:self action:@selector(load:)];
    loadButton.tintColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    self.toolbarItems = [NSArray arrayWithObjects:flexible,loadButton,nil];
    
}

//액션시트

-(void)buttonPressed{
    NSLog(@"삭제합니까?\n");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"지우시겠습니까?" delegate:self cancelButtonTitle:@"취 소" destructiveButtonTitle:@"삭 제" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSLog(@"삭제합니다.\n");
    if (buttonIndex != [actionSheet cancelButtonIndex]){
        NSString *msg = nil;
        msg = [[NSString alloc] initWithFormat:@"삭제완료\n"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
        [alert show];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	if (!self.tableView.isEditing)
    {
        
        self.viewController.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [[self navigationController] pushViewController:self.viewController animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        NSString *deleteButtonTitle = [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
        
        if (selectedRows.count == self.dataArray.count)
        {
            deleteButtonTitle = kDeleteAllTitle;
        }
        self.deleteButton.title = deleteButtonTitle;
    }
     */
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.isEditing)
    {
        NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
        //self.deleteButton.title = (selectedRows.count == 0) ?
        //kDeleteAllTitle : [NSString stringWithFormat:kDeletePartialTitle, selectedRows.count];
    }

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
