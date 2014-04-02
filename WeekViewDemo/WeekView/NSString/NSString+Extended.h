//
//  NSString+MoonString.h
//  Tsukimi
//
//  Created by Yashwant Chauhan on 3/8/13.
//  Copyright (c) 2013 Yashwant Chauhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extended)

+(NSString *)dateStringFromFullDate:(NSDate *)fullDate;
-(NSString *)dateTimeSubstringFromString;
-(NSRange)rangeOfDateTimeFromString;
-(NSString*)removeSubstring:(NSString*)substring ;
-(NSString*)stripNewlines;
-(NSString*)stripSpaces;
-(NSString*)replaceSubstring:(NSString*)substringToBeReplaced with:(NSString*)substituteString;
-(NSDate *)asctimeDate;
+(NSString*)randomStringForChar:(int)charnum;
-(NSArray*)lines;
-(NSArray*)words;

@end
