//
//  DetailViewController.h
//  InstagramRSSTestProject
//
//  Created by rost on 17.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarDelegate.h"
#import "CommentsViewController.h"


@interface DetailViewController : RootViewController <JTRevealSidebarDelegate>

@property (strong, nonatomic) NSDictionary *detailsDic;
@property (strong, nonatomic) CommentsViewController *commentsView;

@end
