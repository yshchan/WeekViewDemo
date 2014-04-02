//
//  WeekView.m
//  WeekViewDemo
//
//  Created by Yashwant Chauhan on 3/31/14.
//  Copyright (c) 2014 Yashwant Chauhan. All rights reserved.
//

#import "WeekView.h"

NSInteger const kDefaultInitialInactiveDays = 8;
NSInteger const kDefaultFinalInactiveDays = 8;

@interface WeekView () {
    @private
        NSDate *_startDate;
        NSDate *_endDate;
        NSInteger _currentDay;
        NSDate *_currentDate;
        NSRange _activeDays;
        NSIndexPath *_currentIndex;
}

@end

@implementation WeekView

@synthesize weekViewDays;

#pragma mark -

- (void)setCurrentDay:(NSInteger)currentDay animated:(BOOL)animated
{
    _currentDay = currentDay;

    _currentIndex = [NSIndexPath indexPathForRow:currentDay+kDefaultInitialInactiveDays-1 inSection:0];

    [self scrollToItemAtIndexPath:_currentIndex atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated]; // TODO: This only scrolls to item...
}

- (void)setCurrentDate:(NSDate *)date animated:(BOOL)animated
{
    if (date) {
        NSInteger components = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);

        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents *componentsFromDate = [currentCalendar components:components
                                                                  fromDate:date];

        [weekViewDays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WeekViewDay *day = obj;

            NSDateComponents *componentsFromDayDate = [currentCalendar components:components
                                                                         fromDate: day.date];

            NSDate *searchingDate = [currentCalendar dateFromComponents:componentsFromDate];
            NSDate *dayDate = [currentCalendar dateFromComponents:componentsFromDayDate];

            NSComparisonResult result = [searchingDate compare:dayDate];

            if (result == NSOrderedSame) {
                _currentDate = date;
                [self setCurrentDay:idx-kDefaultInitialInactiveDays+1 animated:animated];
                *stop = YES;
            }
        }];
    }
}

- (WeekViewCell *)cellForDay:(WeekViewDay *)day
{
    NSInteger dayIndex = [weekViewDays indexOfObject:day];

    return (WeekViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForRow:dayIndex inSection:0]];
}

- (void)setActiveDaysFrom:(NSInteger)fromDay toDay:(NSInteger)toDay
{
    _activeDays = NSMakeRange(fromDay, toDay-fromDay);
}

- (void)setStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    _startDate = [NSDate dateWithNoTime:startDate middleDay:YES];
    _endDate = [NSDate dateWithNoTime:endDate middleDay:YES];

    NSMutableArray *tableData = [NSMutableArray array];

    NSDateFormatter *dateNameFormatter = [[NSDateFormatter alloc] init];
    [dateNameFormatter setDateFormat:@"E"];

    NSDateFormatter *dateNumberFormatter = [[NSDateFormatter alloc] init];
    [dateNumberFormatter setDateFormat:@"dd"];

    for (int i = kDefaultInitialInactiveDays; i >= 1; i--) {
        NSDate *date = [_startDate dateByAddingTimeInterval:-(i * 60.0 * 60.0 * 24.0)];

        WeekViewDay *newDay = [[WeekViewDay alloc] init];
        newDay.day = @([[dateNumberFormatter stringFromDate:date] integerValue]);
        newDay.name = [dateNameFormatter stringFromDate:date];
        newDay.date = date;

        [tableData addObject:newDay];
    }

    NSInteger numberOfActiveDays = 0;

    for (NSDate *date = _startDate; [date compare: _endDate] <= 0; date = [date dateByAddingTimeInterval:24 * 60 * 60] ) {
        WeekViewDay *newDay = [[WeekViewDay alloc] init];
        newDay.day = @([[dateNumberFormatter stringFromDate:date] integerValue]);
        newDay.name = [dateNameFormatter stringFromDate:date];
        newDay.date = date;

        [tableData addObject:newDay];

        numberOfActiveDays++;
    }

    for (int i = 1; i <= kDefaultFinalInactiveDays; i++) {
        NSDate *date = [_endDate dateByAddingTimeInterval:(i * 60.0 * 60.0 * 24.0)];

        WeekViewDay *newDay = [[WeekViewDay alloc] init];
        newDay.day = @([[dateNumberFormatter stringFromDate:date] integerValue]);
        newDay.name = [dateNameFormatter stringFromDate:date];
        newDay.date = date;

        [tableData addObject:newDay];
    }

    weekViewDays = [tableData copy];

    [self setActiveDaysFrom:1 toDay:numberOfActiveDays];
}

@end
