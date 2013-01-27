//
//  MasterViewController.m
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "CreateTaskViewController.h"

#import "TaskCell.h"

#import <Parse/Parse.h>

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    if(!self.taskItems) {
        PFQuery* query = [PFQuery queryWithClassName:@"TaskItem"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                self.taskItems = [NSMutableArray arrayWithArray:objects];
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not get tasks from cloud" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (void)insertNewObject:(NSDictionary*)newTask
{
    [self.taskItems insertObject:newTask atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell *cell = [tableView
                      dequeueReusableCellWithIdentifier:@"MyTaskCell"
                      forIndexPath:indexPath];

    NSDictionary* taskItem = [self.taskItems objectAtIndex: indexPath.row];
//    NSDictionary* taskItem = self.taskItems[indexPath.row];
    
    cell.delegate = self;
    
    [cell setTaskObject:taskItem];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = self.taskItems[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

#pragma mark - Segue tasks

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.taskItems[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    
    if ([[segue identifier] isEqualToString:@"createTask"]) {
        // we want to set the CreateTaskController's delegate to "self"
        
        UINavigationController* navController = [segue destinationViewController];
        
        CreateTaskViewController* createTaskController = (CreateTaskViewController*)[navController.childViewControllers objectAtIndex:0];
        
        createTaskController.delegate = self;
    }
}

#pragma mark - Todo management tasks

- (void) addNewTask:(NSDictionary*) taskDict {
    NSLog(@"Task info: %@", taskDict);
    [self insertNewObject:taskDict];
}

- (void) markTaskCompleted:(NSIndexPath*)taskPath {
    int row = [taskPath row];
    NSMutableDictionary* taskItem = [self.taskItems objectAtIndex:row];

    NSNumber* complete = [taskItem objectForKey:@"complete"];
    
    complete = [complete boolValue] ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    
    [taskItem setObject:complete forKey:@"complete"];
}


@end
