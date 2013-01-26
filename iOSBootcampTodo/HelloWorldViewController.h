//
//  HelloWorldViewController.h
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloWorldViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UILabel* myLabel;

- (IBAction)buttonClicked:(id)sender;

- (IBAction)buttonClickedSegue:(id)sender;

- (IBAction)focus:(id)sender;

- (IBAction)done:(id)sender;


@end
