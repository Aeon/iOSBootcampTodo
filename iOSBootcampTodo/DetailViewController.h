//
//  DetailViewController.h
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/25/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;

@property (nonatomic,retain) CLLocationManager* locationManager;

- (IBAction)doubleTapped:(UIGestureRecognizer*)recognizer;

@end
