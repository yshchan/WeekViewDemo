//
//  NSString+MoonString.m
//  Tsukimi
//
//  Created by Yashwant Chauhan on 3/8/13.
//  Copyright (c) 2013 Yashwant Chauhan. All rights reserved.
//

#import "NSString+Extended.h"
#import "NSDate+TimeAgo.h"

#import <time.h>
#import <xlocale.h>

@implementation NSString (Extended)

+(NSString*)randomStringForChar:(int)charnum {
    char data[charnum];
    for (int x=0;x<charnum;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *random = [[NSString alloc] initWithBytes:data length:charnum encoding:NSUTF8StringEncoding];
    return random;
}

-(NSArray*)words {
    NSArray *words = [self componentsSeparatedByString:@" "];
    return words;
}

-(NSArray*)lines {
    NSArray *lines = [self componentsSeparatedByString:@"\n"];
    return lines;
}

-(NSDate *)asctimeDate; {
    NSString *dateStr = [self description];
    static NSDateFormatter *asctime = nil;
    if (asctime == nil)
    {
        asctime = [[NSDateFormatter alloc] init];
        asctime.locale = [NSLocale systemLocale];
        asctime.timeZone = [NSTimeZone defaultTimeZone];
        asctime.dateFormat = @"EEE MMM  d HH:mm:ss yyyy";
    }
    NSDate *result = [asctime dateFromString:dateStr];
    if (result) { return result; } else { return nil; };
}

+(NSString *)dateStringFromFullDate:(NSDate *)fullDate {
    // Specify which units we would like to use
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:fullDate];
    
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    return [NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day];
}

-(NSString *)dateTimeSubstringFromString {
    NSString *originalString = (NSString*)self;
    NSDataDetector *dateTimeDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeDate error:nil];
    NSRange rangeOfDateTime = [dateTimeDetector rangeOfFirstMatchInString:originalString options:NSMatchingReportCompletion range:NSMakeRange(0, [originalString length])];
    NSString *dateTimeSubstring = nil;
    if (rangeOfDateTime.location != NSNotFound) {
        dateTimeSubstring = [originalString substringWithRange:rangeOfDateTime];
        return dateTimeSubstring;
    }
    return nil;
}

-(NSRange)rangeOfDateTimeFromString {
    NSString *originalString = (NSString*)self;
    NSDataDetector *dateTimeDetector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeDate error:nil];
    NSRange rangeOfDateTime = [dateTimeDetector rangeOfFirstMatchInString:originalString options:NSMatchingReportCompletion range:NSMakeRange(0, [originalString length])];
    if (rangeOfDateTime.location != NSNotFound) {
        return rangeOfDateTime;
    }
    return NSMakeRange(NSNotFound, 0);
}

-(NSString*)replaceSubstring:(NSString*)substringToBeReplaced with:(NSString*)substituteString {
    NSMutableString *newString = (NSMutableString*)[self removeSubstring:substringToBeReplaced];
    [newString appendString:substituteString];
    return (NSString*)newString;
}

-(NSString*)removeSubstring:(NSString*)substring {
    NSString *stringWithoutSubstring = [(NSString*)self stringByReplacingOccurrencesOfString:substring withString:@""];
    return stringWithoutSubstring;
}

-(NSString*)stripNewlines {
    NSMutableString *mstring = [NSMutableString stringWithString:(NSString*)self];
    NSRange wholeShebang = NSMakeRange(0, [mstring length]);
    [mstring replaceOccurrencesOfString: @"" withString: @"" options: 0 range: wholeShebang];
    return [NSString stringWithString: mstring];
}

-(NSString*)stripSpaces {
    return [(NSString*)self stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
