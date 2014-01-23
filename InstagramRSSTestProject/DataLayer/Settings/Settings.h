//
//  Settings.h
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <Foundation/Foundation.h>


// INSTAGRAM API ID
#define ClientSecret            @"bba88993365845439bf8db1b4cab8e20"


// INSTAGRAM API URLS
#define OAUTH_URL      @"https://api.instagram.com/oauth/authorize/?client_id=327a373c4582427ab34c8002119102e7&scope=likes"
#define RSS_URL                 @"https://api.instagram.com/v1/users/self/feed?access_token"
#define REQUEST_URL             @"https://api.instagram.com/v1/media"


// MY APP URLS
#define WebsiteURL              @"http://localhost:8888"
#define RedirectURI             @"http://localhost:8888/MAMP/"


// FONT PARAMS
#define LOGIN_PAGE_FONT        @"Noteworthy"


// RSS PAGE TAGS
#define RSS_TABLE_TAG            100
#define RSS_REFRESH_CONTROL_TAG  101


// RSS CELL TAGS
#define RSS_IMG_VIEW_TAG         110
#define NAME_LBL_TAG             111
#define TEXT_LBL_TAG             112
#define TIME_LBL_TAG             113
#define LIKE_BTN_TAG             114


// REQUESTS TO API TAGS
#define GET_RSS_TAG              200
#define SEND_LIKE_TAG            201
#define SEND_DISLIKE_TAG         202


// TIME CONSTANTS
#define HALF_HOUR                1800           // IN SECONDS
#define ONE_HOUR                 3600           // IN SECONDS
#define ONE_DAY                  86400          // IN SECONDS


// UI CONSTANTS
#define VIEW_WIDTH               self.view.bounds.size.width
#define VIEW_HEIGHT              self.view.bounds.size.height

#define LIKED_STATE              300
#define NOT_LIKED_STATE          301


// EVENT PATHS IN JSON
#define ID_PATH                 @"id"
#define RSS_PICTURE_PATH        @"images.low_resolution.url"
#define PICTURE_PATH            @"images.standard_resolution.url"
#define USER_AVA_PATH           @"caption.from.profile_picture"
#define COMMENTS_SOURCE_PATH    @"comments.data"
#define COMMENT_USER_AVA_PATH   @"from.profile_picture"
#define COMMENT_USER_NAME_PATH  @"from.full_name"
#define COMMENT_TEXT_PATH       @"text"
#define COMMENT_TIME_PATH       @"created_time"
#define LIKES_NAMES_PATH        @"likes.data"
#define LIKES_COUNT_PATH        @"likes.count"
#define FULLNAME_PATH           @"caption.from.full_name"
#define TEXT_PATH               @"caption.text"
#define CREATETIME_PATH         @"caption.created_time"
#define SELF_NAME_PATH          @"user.full_name"
#define SELF_AVA_PATH           @"user.profile_picture"
#define SELF_CREATETIME_PATH    @"created_time"


// CHECKER
#define EMPTY_STRING            [Settings shared] emptyString


// AUTH INSTAGRAM STRINGS
#define LOGIN_INCORECT_MSG      @"Please enter a correct username and password. Note that both fields are case-sensitive."


// ERROR TITLES
#define ERROR_MSG_TITLE         @"Error RSS loading"

// KEYS
extern NSString *const tokenAPIKey;
extern NSString *const dateOfTokenKey;
extern NSString *const userRSSKey;

extern NSString *const maxIdHistoryKey;
extern NSString *const nextMaxIdKey;
extern NSString *const nextUrlKey;

extern NSString *const likesListKey;


@interface Settings : NSObject

+ (Settings *)shared;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)saveRssFromArray:(NSArray *)incArr;

- (void)deleteCoockies;

- (NSString *)setDateEventFromDate:(NSString *)dateStr;
- (NSString *)calcTimeDifferenceByTime:(NSString *)incStr;

- (BOOL)emptyString:(NSString *)emptyStr;

- (NSArray *)sortArray:(NSArray *)incArr;
- (BOOL)validateMaxIdValue:(NSString *)idValue;

- (NSDictionary *)setDetailsDictionary:(NSDictionary *)detailsDic andTitlesString:(NSString *)usersLikeStr;
@end
