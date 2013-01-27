//
//  MasterViewController.h
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (nonatomic, retain) NSMutableArray* taskItems;

@end
