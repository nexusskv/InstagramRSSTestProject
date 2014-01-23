//
//  RootViewController.h
//  InstagramRSSTestProject
//
//  Created by rost on 19.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

- (void)addNavBarWithTitle:(NSString *)titleStr andFrame:(CGRect)barFrame;

- (UILabel *)setLabelWithFrame:(CGRect)lblRect withTitle:(NSString *)titleStr andTag:(NSUInteger)lblTag;

- (UITableView *)getRssTableByRect:(CGRect)frame;

- (void)showAlert:(NSString *)titleStr withMessage:(NSString *)msgStr;

- (void)showActivityIndicator;
- (void)hideActivityIndicator;
- (void)showActivityIndicatorWithTitle:(NSString *)title;
- (void)changeActivityIndicatorTitleTo:(NSString *)title;

@end
