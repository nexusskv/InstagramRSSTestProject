//
//  Settings.m
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "Settings.h"


NSString *const tokenAPIKey     =   @"tokenAPI";
NSString *const dateOfTokenKey  =   @"dateOfToken";

NSString *const userRSSKey      =   @"userRSS";

NSString *const maxIdHistoryKey =   @"maxIdHistory";
NSString *const nextMaxIdKey    =   @"nextMaxId";
NSString *const nextUrlKey      =   @"nextUrl";

NSString *const likesListKey    =   @"likesList";



@interface Settings ()
@property (nonatomic, assign) NSUserDefaults *userDefaults;
@end


@implementation Settings

@synthesize userDefaults;

#pragma mark - Share Settings method
+ (Settings *)shared
{
    static Settings *sharedInstanse;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{ sharedInstanse = [[self alloc] init]; });
    
    return sharedInstanse;
}
#pragma mark -


#pragma mark - Constructor
- (id)init
{
	if ((self = [super init]))
	{
		self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
	
	return self;
}
#pragma mark -


#pragma mark Internal
- (id)objectForKey:(NSString *)key
{
	return [self.userDefaults objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
	[self.userDefaults setObject:object forKey:key];
	[self.userDefaults synchronize];
}
#pragma mark -


#pragma mark - saveRssFromArray:
- (void)saveRssFromArray:(NSArray *)incArr
{
    NSData *rssData = [NSKeyedArchiver archivedDataWithRootObject:incArr];  // ARCHIVED RSS
    
    [[Settings shared] setObject:[NSArray array] forKey:userRSSKey];        // CLEAN OLD RSS
    [[Settings shared] setObject:rssData forKey:userRSSKey];                // SAVE RSS TO USER_DEFAULTS
}
#pragma mark -


#pragma mark - deleteCoockies
- (void)deleteCoockies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -


#pragma mark - setDateEventFromDate:
- (NSString *)setDateEventFromDate:(NSString *)dateStr
{
    if ((![EMPTY_STRING:dateStr]) && ([dateStr longLongValue] > 0))
    {
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[dateStr longLongValue]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy, h:mm a"];
        dateStr = nil;
        dateStr = [dateFormatter stringFromDate:dateTime];
    }
    else
        {
            dateStr = @"";
        }
    
    return dateStr;
}
#pragma mark -


#pragma mark - calcTimeDifferenceByTime:
- (NSString *)calcTimeDifferenceByTime:(NSString *)incStr
{
    NSDate *todayDate  = [NSDate date];
    NSDate *postedDate = [NSDate dateWithTimeIntervalSince1970:[incStr doubleValue]];
    
    NSTimeInterval secondsBetween = [todayDate timeIntervalSinceDate:postedDate];
    
    int numberOfDays = secondsBetween / ONE_DAY;
    
    //double diffInterval = todatInterval - [incStr longLongValue];
    
    NSString *dateTimeStr = nil;
    
    if (numberOfDays > 1)
        dateTimeStr = [NSString stringWithFormat:@"%d d. ago", numberOfDays];
    else
        {
            if ((secondsBetween / ONE_HOUR) > 1)
                dateTimeStr = [NSString stringWithFormat:@"%d h. ago", numberOfDays];
            else
                dateTimeStr = @"less than an hour ago";
        }

    return dateTimeStr;
}
#pragma mark - 


#pragma mark - emptyString:
- (BOOL)emptyString:(NSString *)emptyStr
{
    BOOL emptyFlag = YES;
    
    if (([emptyStr isKindOfClass:[NSString class]]) && (![emptyStr isEqual:[NSNull null]]))
    {
        if ((emptyStr != nil) && ((emptyStr.length > 0) || (![emptyStr isEqualToString:@""])))
            emptyFlag = NO;
    }
    
    return emptyFlag;
}
#pragma mark -


#pragma mark - sortArray:
- (NSArray *)sortArray:(NSArray *)incArr
{
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"created_time" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *reversedArr=[incArr sortedArrayUsingDescriptors:descriptors];
    
    return reversedArr;
}
#pragma mark -


#pragma mark - validateMaxIdValue:
- (BOOL)validateMaxIdValue:(NSString *)idValue
{
    BOOL validateFlag = NO;

    NSArray *idstArr = [[Settings shared] objectForKey:maxIdHistoryKey];
    
    for (NSString *storedIdStr in idstArr)
    {
        if ([storedIdStr isEqualToString:idValue])
        {
            validateFlag = YES;                      // CHECK SAVED ID IN PAST
        }
    }
    
    return validateFlag;
}
#pragma mark -


#pragma mark - setDetailsDictionary:andTitlesString:
- (NSDictionary *)setDetailsDictionary:(NSDictionary *)detailsDic andTitlesString:(NSString *)usersLikeStr
{
    NSMutableDictionary *paramMutDic = [NSMutableDictionary dictionary];
    
    if (![EMPTY_STRING:[detailsDic valueForKeyPath:PICTURE_PATH]])
        [paramMutDic setValue:[detailsDic valueForKeyPath:PICTURE_PATH] forKey:@"url"];
    
    if (![EMPTY_STRING:[detailsDic valueForKeyPath:FULLNAME_PATH]])
        [paramMutDic setValue:[detailsDic valueForKeyPath:FULLNAME_PATH] forKey:@"name"];
    else
        if (![EMPTY_STRING:[detailsDic valueForKeyPath:SELF_NAME_PATH]])
            [paramMutDic setValue:[detailsDic valueForKeyPath:SELF_NAME_PATH] forKey:@"name"];
    
    if (![EMPTY_STRING:[detailsDic valueForKeyPath:USER_AVA_PATH]])
        [paramMutDic setValue:[detailsDic valueForKeyPath:USER_AVA_PATH] forKey:@"user_ava"];
    else
        if (![EMPTY_STRING:[detailsDic valueForKeyPath:SELF_AVA_PATH]])
            [paramMutDic setValue:[detailsDic valueForKeyPath:SELF_AVA_PATH] forKey:@"user_ava"];
    
    if (![EMPTY_STRING:[detailsDic valueForKeyPath:CREATETIME_PATH]])
        [paramMutDic setValue:[detailsDic valueForKeyPath:CREATETIME_PATH] forKey:@"time"];
    else
        if (![EMPTY_STRING:[detailsDic valueForKeyPath:SELF_CREATETIME_PATH]])
            [paramMutDic setValue:[detailsDic valueForKeyPath:SELF_CREATETIME_PATH] forKey:@"time"];
    
    if (![EMPTY_STRING:[detailsDic valueForKeyPath:TEXT_PATH]])
    {
        [paramMutDic setValue:[detailsDic valueForKeyPath:TEXT_PATH] forKey:@"theme"];
    }
    
    NSMutableString *likesStr = [NSMutableString string];
    if (![EMPTY_STRING:usersLikeStr])
    {
        [likesStr appendString:usersLikeStr];
    }
    
    if ([[detailsDic valueForKeyPath:LIKES_COUNT_PATH] longValue] > 0)
    {
        long likes = [[detailsDic valueForKeyPath:LIKES_COUNT_PATH] longValue];
        
        [likesStr appendFormat:@" and %ld others like this.", likes];
    }
    
    if (![EMPTY_STRING:likesStr])
    {
        [paramMutDic setValue:likesStr forKey:@"likes_titles"];
    }
    
    return paramMutDic;
}
#pragma mark -

@end
