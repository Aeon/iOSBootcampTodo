//
//  CreateTaskViewController.h
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTaskViewController : UITableViewController

@property (nonatomic, retain) IBOutlet UITextField* taskName;
@property (nonatomic, retain) IBOutlet UITextField* taskDescription;

- (IBAction)cancel:(id)sender;

@end
