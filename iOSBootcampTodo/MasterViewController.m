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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadTasks) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    PFUser* currentUser = [PFUser currentUser];

    if(currentUser) {
        NSLog(@"User is logged in with info: %@", currentUser);

        if(!self.taskItems) {
            [self loadTasks];
        }

    } else {
        // login/signup screen
        PFLogInViewController* loginController = [[PFLogInViewController alloc] init];
        loginController.fields = PFLogInFieldsFacebook | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsUsernameAndPassword;

        // tell parse framework to use the master controller as delegate for signup/login methods
        loginController.delegate = self;
        loginController.signUpController.delegate = self;

        [self presentViewController:loginController animated:YES completion:^{
        }];
    }
}

- (void)loadTasks {
    PFQuery* query = [PFQuery queryWithClassName:@"TaskItem"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.taskItems = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not get tasks from cloud" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (void)insertNewObject:(NSDictionary*)newTask
{
    // copy item data from the task NSDict into the Parse object that lets us save/load data from cloud
    PFObject* parseTaskItem = [PFObject objectWithClassName:@"TaskItem"];
    [parseTaskItem setObject:[newTask objectForKey:@"name"] forKey:@"name"];
    [parseTaskItem setObject:[newTask objectForKey:@"description"] forKey:@"description"];
    [parseTaskItem setObject:[newTask objectForKey:@"complete"] forKey:@"complete"];
    [parseTaskItem setObject:[PFUser currentUser] forKey:@"user"];
    
    PFACL* acl = [[PFACL alloc] init];
    [acl setPublicReadAccess:NO];
    [acl setPublicWriteAccess:NO];
    [acl setWriteAccess:YES forUser:[PFUser currentUser]];
    [acl setReadAccess:YES forUser:[PFUser currentUser]];
    [parseTaskItem setACL:acl];

    [self.taskItems insertObject:parseTaskItem atIndex:0];
    [parseTaskItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error) {
            NSLog(@"Could not save object to parse: error %@", error);
        } else {
            NSLog(@"Saved object to parse: %@", parseTaskItem);
        }
    }];

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

        // delete task from cloud storage
        PFObject* taskToDelete = [self.taskItems objectAtIndex:[indexPath row]];
        [taskToDelete deleteInBackground];
        
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
    PFObject* taskItem = [self.taskItems objectAtIndex:row];

    NSNumber* complete = [taskItem objectForKey:@"complete"];
    
    complete = [complete boolValue] ? [NSNumber numberWithInt:0] : [NSNumber numberWithInt:1];
    
    [taskItem setObject:complete forKey:@"complete"];
    [taskItem saveInBackground];
}

#pragma mark - Signup methods
-(void) signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Signed up user with info: %@", user);
}

-(void) signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up user with error: %@", error);
}

#pragma mark - Login methods

-(void) logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"Logged in user with info: %@", user);
    if(!self.taskItems) {
        [self loadTasks];
    }
}

-(void) logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in user with error: %@", error);
}
@end
