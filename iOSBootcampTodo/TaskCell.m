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


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(longTouchDetected:)];
        [self addGestureRecognizer:longPress];
        
        /*
        UIScrollView* scroller = [[UIScrollView alloc]
                                  initWithFrame:self.bounds];
        
        [self addSubview:scroller];

        scroller.alwaysBounceHorizontal = YES;
        scroller.showsHorizontalScrollIndicator = NO;
        
        scroller.delegate = self;
        
        // move the contents of this cell into the content view of the scroller
        [scroller addSubview:self.contentView];    
 */
    }
    return self;
}

- (void) longTouchDetected:(UILongPressGestureRecognizer*)recognizer {
    NSLog(@"Long press detected on a todo cell");
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"Finished scrolling cell at offset %f", scrollView.contentOffset.x);
    if (scrollView.contentOffset.x < -50) {
        [self toggleCheckButton:scrollView];
    }
}

- (IBAction)toggleCheckButton:(id)sender {
    self.doneButton.selected = !self.doneButton.selected;

    NSIndexPath* indexPath = [(UITableView *)self.superview indexPathForCell:self];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(markTaskCompleted:)]) {
        [self.delegate performSelector:@selector(markTaskCompleted:) withObject:indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTaskObject:(NSDictionary*)taskItem {

//    self.nameLabel.text = taskItem[@"name"];
    self.nameLabel.text = [taskItem objectForKey:@"name"];
    self.descLabel.text = [taskItem objectForKey:@"description"];
    self.doneButton.selected = [[taskItem objectForKey:@"complete"] boolValue];
    
    [self.doneButton
     setTitle: @"✓"
     forState: UIControlStateSelected];
    
}

@end
