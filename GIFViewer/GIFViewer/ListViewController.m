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
    NSLog(@"Call Delete\n");
}
-(void)edit:(id)sender{
    //edit = YES;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    return listCell;
}

- (void) loadView
{
    [super loadView];
    printf("로드뷰\n");

    
}

//todo 삭제 기능

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
 
}
*/
@end
