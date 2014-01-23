//
//  CommentsViewController.h
//  InstagramRSSTestProject
//
//  Created by rost on 20.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : RootViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *commentsArr;

@end
