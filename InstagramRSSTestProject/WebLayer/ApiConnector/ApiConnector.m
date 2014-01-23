//
//  ApiConnector.m
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "ApiConnector.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "DSActivityView.h"


@implementation ApiConnector

@synthesize connectDelegate;


#pragma mark - getRssByUrl:andToken:
- (void)getRssByUrl:(NSString *)urlStr andToken:(NSString *)tokenStr
{    
    NSString *webURLStr = nil;
    
    if (urlStr != nil)
        webURLStr = urlStr;                                                     // SET URLS FOR NEXT REQUESTS
    else
        webURLStr = [NSString stringWithFormat:@"%@=%@", RSS_URL, tokenStr];    // SET URL FOR FIRST REQUEST

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webURLStr]
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:60.0];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"GET"];
   
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        if (([responseObject isKindOfClass:[NSDictionary class]]) &&
            ([[responseObject valueForKeyPath:@"meta.code"] intValue] == 200))
        {
            NSDictionary *respDic = (NSDictionary *)responseObject;
            
            __block NSArray *resultArr = nil;
            
            if ((respDic != nil) && ([[respDic allKeys] count] > 0))
            {
                dispatch_queue_t fetchQ = dispatch_queue_create("ResponceSort", NULL);  // CREATE CUSTOM QUEUE
                dispatch_async(fetchQ, ^{
                    
                    if (![EMPTY_STRING:[responseObject valueForKeyPath:@"pagination.next_max_id"]])
                    {
                        __block BOOL maxIdStoredFlag = NO;
                        
                        dispatch_barrier_async(fetchQ, ^{
                            // GET STORED FLAG
                            maxIdStoredFlag = [[Settings shared] validateMaxIdValue:
                                               [responseObject valueForKeyPath:@"pagination.next_max_id"]];
                        });
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            if ((![EMPTY_STRING:[responseObject valueForKeyPath:@"pagination.next_max_id"]]) &&
                                (!maxIdStoredFlag))
                            {
                                // GET OLD MAD_IDS VALUES
                                NSMutableArray *maxIdHistArr =
                                [[NSMutableArray alloc] initWithArray:[[Settings shared] objectForKey:maxIdHistoryKey]];
                                [maxIdHistArr addObject:[responseObject valueForKeyPath:@"pagination.next_max_id"]];
                                [[Settings shared] setObject:maxIdHistArr forKey:maxIdHistoryKey];

                                
                                // SAVE NEXT_MAX_ID TO USER_DEFAULTS
                                [[Settings shared] setObject:[responseObject valueForKeyPath:@"pagination.next_max_id"]
                                                      forKey:nextMaxIdKey];
                                
                                if (![EMPTY_STRING:[responseObject valueForKeyPath:@"pagination.next_url"]])
                                {
                                    // SAVE NEXT_URL
                                    [[Settings shared] setObject:[responseObject valueForKeyPath:@"pagination.next_url"]
                                                          forKey:nextUrlKey];
                                }
                            }
                        });
                    }
                    else
                        {
                            [[Settings shared] setObject:@"STOP" forKey:nextUrlKey];
                        }
                    
                    resultArr = [respDic valueForKey:@"data"];  // SET RESPONSE ARRAY

                    dispatch_async(fetchQ, ^{
                        if ((self.connectDelegate) &&
                            ([self.connectDelegate respondsToSelector:@selector(rssResponseArray:)]))
                        {
                            [self.connectDelegate rssResponseArray:resultArr];   // RETURN ARRAY BY DELEGATE & PROTOCOL
                        }
                    });

                });
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self backErrorMessage:error.description];
    }];
    [operation start];
}
#pragma mark - 


#pragma mark - sendLikeById:andLike:
- (void)sendLikeById:(NSString *)idStr andLike:(BOOL)likeFlag
{
    NSString *urlStr = nil;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *tokenStr = [[Settings shared] objectForKey:tokenAPIKey];

    if (likeFlag)       // SEND LIKE
    {
        urlStr = [NSString stringWithFormat:@"%@/%@/likes?access_token=%@", REQUEST_URL, idStr, tokenStr];

        [manager POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

            [self backLikeResponse:responseObject andLike:likeFlag];    // SEND RESPONSE TO HANDLER
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self backErrorMessage:error.description];
        }];
    }
    else            // SEND DISLIKE
        {
            urlStr = [NSString stringWithFormat:@"%@/%@/likes?access_token=%@", REQUEST_URL, idStr, tokenStr];
            
            [manager DELETE:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

                [self backLikeResponse:responseObject andLike:likeFlag];    // SEND RESPONSE TO HANDLER
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self backErrorMessage:error.description];
            }];
        }
}
#pragma mark -


#pragma mark - backLikeResponse:andLike:
- (void)backLikeResponse:(id)responseObj andLike:(BOOL)likeFlag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (([responseObj isKindOfClass:[NSDictionary class]]) &&
            ([[responseObj valueForKeyPath:@"meta.code"] intValue] == 200))  // CHECK RESPONSE TO SUCCESS
        {
            if ((self.connectDelegate) && ([self.connectDelegate respondsToSelector:@selector(sendLikeResponse:)]))
            {
                [self.connectDelegate sendLikeResponse:likeFlag];   // RETURN SEND RESULT BY DELEGATE & PROTOCOL
            }
        }
    });
}
#pragma mark -


#pragma mark - backErrorMessage:
- (void)backErrorMessage:(NSString *)errMsg
{
    if (![EMPTY_STRING:errMsg])
    {
        if ((self.connectDelegate) && ([self.connectDelegate respondsToSelector:@selector(errorResponse:)]))
        {
            [self.connectDelegate errorResponse:errMsg];        // RETURN SEND ERROR MESSAGE BY DELEGATE & PROTOCOL
        }
    }
}
#pragma mark -

@end