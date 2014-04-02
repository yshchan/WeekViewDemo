//
//  NSDate+RelativeString.m
//  OneWithNoTitle
//
//  Created by Yashwant Chauhan on 31/07/13.
//  Copyright (c) 2013 Yashwant Chauhan. All rights reserved.
//

#import "NSDate+RelativeString.h"
#import "NSDate+DateRange.h"
#import "NSString+Extended.h"

@implementation NSDate (RelativeString)

-(NSString*)unicodeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/mm/yyyy"];
    return [dateFormatter stringFromDate:self];
}

-(NSString*)weekdayName {
    NSString *weekDay = nil;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    weekDay = [dateFormatter stringFromDate:[NSDate date]];
    
    return weekDay;
}

-(NSString*)monthDayNoYear {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    NSString *relativeString = [[dateFormatter stringFromDate:self] removeSubstring:[NSString stringWithFormat:@", %ld",(long)[self year]]];
    
    NSCharacterSet *notAllowedChars = [NSCharacterSet characterSetWithCharactersInString:@".!@#$%^&*()_+|"]; 
    NSString *filteredString = relativeString;
    if ([relativeString rangeOfCharacterFromSet:notAllowedChars].location != NSNotFound) {
        filteredString = [[relativeString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    }
    return [filteredString capitalizedString];
}

-(NSString*)shortWeekday {
//    NSString *weekdayString = [self weekday];
//    NSString *newString = [weekdayString substringWithRange:NSMakeRange(0, weekdayString.length-3)];
//    if (!newString) { NSLog(@"Shortened weekday is nil."); }
//    return newString;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EE"];
    return [dateFormatter stringFromDate:self];
}

-(NSString*)relativeDate; {
    if ([(NSDate*)self isToday]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"h:mm a"];
        return [formatter stringFromDate:(NSDate*)self];
    } else if ([(NSDate*)self isTomorrow]) {
        return @"Tommorow";
    } else if ([(NSDate*)self isThisWeek]) {
        return [(NSDate*)self weekdayName];
    } else {
        return [(NSDate*)self monthDayNoYear];
    }
}

-(NSString*)monthName; {
    NSDate *date = (NSDate*)self;
    
    int monthNumber = (int)[date month];
    NSString *dateString = [NSString stringWithFormat: @"%i", monthNumber];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate *myDate = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *stringFromDate = [formatter stringFromDate:myDate];
        
    return stringFromDate;
}

@end
