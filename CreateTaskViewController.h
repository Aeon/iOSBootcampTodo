//
//  CreateTaskViewController.h
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTaskViewController : UITableViewController <UITextFieldDelegate>

// these are the properties that contain pointers to the text fields
@property (nonatomic, retain) IBOutlet UITextField* taskName;
@property (nonatomic, retain) IBOutlet UITextField* taskDescription;

// "id" means that it can be any class type
@property (nonatomic, assign) id delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
