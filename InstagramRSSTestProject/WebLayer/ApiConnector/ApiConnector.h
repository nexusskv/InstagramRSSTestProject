//
//  ApiConnector.h
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApiConnectorDelegate;


@interface ApiConnector : AFHTTPSessionManager

@property (weak) id<ApiConnectorDelegate> connectDelegate;

- (void)getRssByUrl:(NSString *)urlStr andToken:(NSString *)tokenStr;
- (void)sendLikeById:(NSString *)idStr andLike:(BOOL)likeFlag;

@end


@protocol ApiConnectorDelegate <NSObject>

- (void)rssResponseArray:(NSArray *)respArr;
- (void)errorResponse:(NSString *)errorStr;

@optional
- (void)sendLikeResponse:(BOOL)resultFlag;
@end