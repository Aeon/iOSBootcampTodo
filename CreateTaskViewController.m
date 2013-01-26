//
//  CreateTaskViewController.m
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import "CreateTaskViewController.h"

@interface CreateTaskViewController ()

@end

@implementation CreateTaskViewController

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
	// Do any additional setup after loading the view.

    self.taskName.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(id)sender {
    NSLog(@"Cancel button pressed");
    
    // this is okay
    /*
    [self dismissViewControllerAnimated:YES completion:^{}];
     */
     
    // apple convention is to have the parent view
    // reponsible for dismissal of the child views
    [self.navigationController.presentingViewController
        dismissViewControllerAnimated:YES completion:^{
    }];
}

-(IBAction)done:(id)sender {
    NSLog(@"Done button pressed: %@", self.delegate);
    
    // apple convention is to have the parent view
    // reponsible for dismissal of the child views
    [self.navigationController.presentingViewController
     dismissViewControllerAnimated:YES completion:^{
     }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField == self.taskName) {
        [self.taskDescription becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;

}

@end
