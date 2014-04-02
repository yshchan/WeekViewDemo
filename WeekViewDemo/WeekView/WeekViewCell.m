//
//  WeekViewCell.m
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//

#import "WeekViewCell.h"

@implementation WeekViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];

        // TODO: Label adding isn't memory efficient
        float heightOfLabel = self.frame.size.height/2-8;
        float widthOfLabel = self.frame.size.width;

        self.dayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, widthOfLabel, heightOfLabel)];
        self.dayNameLabel.font = [UIFont systemFontOfSize:15];
        self.dayNameLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:self.dayNameLabel];

        self.dayDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, widthOfLabel, heightOfLabel)];
        self.dayDateLabel.font = [UIFont boldSystemFontOfSize:17];
        self.dayDateLabel.textAlignment = NSTextAlignmentCenter;

        [self addSubview:self.dayDateLabel];
    }
    return self;
}

@end
