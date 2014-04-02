//
//  WeekView.h
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//

#import "WeekViewDay.h"
#import "WeekViewCell.h"

@interface WeekView : UICollectionView

@property (nonatomic, strong) NSMutableArray *weekViewDays;

- (void)setCurrentDay:(NSInteger)currentDay animated:(BOOL)animated;
- (void)setCurrentDate:(NSDate *)date animated:(BOOL)animated;
- (WeekViewCell *)cellForDay:(WeekViewDay *)day;
- (void)setActiveDaysFrom:(NSInteger)fromDay toDay:(NSInteger)toDay;
- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end