//
//  HelloWorldViewController.m
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import "HelloWorldViewController.h"

@interface HelloWorldViewController ()

@end

@implementation HelloWorldViewController

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

    self.myLabel.text = @"Hello Class!";
    
    
    // how to generate a button in code
    UIButton* newbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newbutton setTitle:@"button" forState:UIControlStateNormal];
    
    [newbutton sizeToFit];
    
    // call buttonCicked method in HelloWorldViewController and pass it self as the sender 
    [newbutton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:newbutton];
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    self.myLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    UIView* grayView = [self.view viewWithTag:555];
    
    grayView.width = self.view.width - 20;
    grayView.left = 10;
    
    grayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {

    NSLog(@"Button clicked!");
    
    UIViewController* newController = [[UIViewController alloc] init];
    
    [self.navigationController presentViewController:newController animated:YES completion:^{
        // do stuff after view transition completion, if we wanted to
    }];

}
- (IBAction)buttonClickedSegue:(id)sender {
    
    NSLog(@"Other Button clicked!");
        
    [self performSegueWithIdentifier:@"NavigateForward" sender: self];
}

-(IBAction)focus:(id)sender {
    UITextField* textField = (UITextField*)[self.view viewWithTag:333];
    
    [textField becomeFirstResponder];
}

-(IBAction)done:(id)sender {
    UITextField* textField = (UITextField*)[self.view viewWithTag:333];
    
    [textField resignFirstResponder];
}
@end
