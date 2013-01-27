//
//  TodoCell.h
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/26/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* descLabel;

@property (nonatomic, retain) IBOutlet UIButton* doneButton;

@end
