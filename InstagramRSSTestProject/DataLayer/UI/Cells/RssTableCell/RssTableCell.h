//
//  RssTableCell.h
//  InstagramRSSTestProject
//
//  Created by rost on 17.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RssTableCell : UITableViewCell

- (void)setAvaImage:(NSString *)imageUrlStr;
- (void)setLabelText:(NSString *)textStr byTag:(NSUInteger)labelTag;

@end
