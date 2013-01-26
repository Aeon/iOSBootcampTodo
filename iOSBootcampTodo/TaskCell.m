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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
