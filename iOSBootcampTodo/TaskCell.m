//
//  TodoCell.m
//  iOSBootcampTodo
//
//  Created by Anton Stroganov on 1/26/13.
//  Copyright (c) 2013 Anton Stroganov. All rights reserved.
//

#import "TaskCell.h"

@implementation TaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (IBAction)toggleCheckButton:(id)sender {
    self.doneButton.selected = !self.doneButton.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTaskObject:(NSDictionary*)taskItem {

    self.nameLabel.text = [taskItem objectForKey:@"name"];
    self.descLabel.text = [taskItem objectForKey:@"description"];
    
    [self.doneButton
     setTitle: @"✓"
     forState: UIControlStateSelected];
    
}

@end
