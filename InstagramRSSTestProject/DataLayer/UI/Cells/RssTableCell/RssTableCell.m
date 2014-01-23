//
//  RssTableCell.m
//  InstagramRSSTestProject
//
//  Created by rost on 17.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "RssTableCell.h"


@implementation RssTableCell


#pragma mark - Constructor
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *rssImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
        rssImgView.tag          = RSS_IMG_VIEW_TAG;
        [self addSubview:rssImgView];
        
        UILabel *userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 10.0f, self.bounds.size.width - 110.0f, 15.0f)];
        userNameLbl.tag             = NAME_LBL_TAG;
        userNameLbl.backgroundColor = [UIColor clearColor];
        userNameLbl.textColor = [UIColor blackColor];
        userNameLbl.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:userNameLbl];
        
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 27.0f, self.bounds.size.width - 110.0f, 15.0f)];
        textLbl.tag             = TEXT_LBL_TAG;
        textLbl.backgroundColor = [UIColor clearColor];
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = [UIFont boldSystemFontOfSize:14];
        [self addSubview:textLbl];
        
        UILabel *createTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(70.0f, 48.0f, self.bounds.size.width - 110.0f, 12.0f)];
        createTimeLbl.tag             = TIME_LBL_TAG;
        createTimeLbl.backgroundColor = [UIColor clearColor];
        createTimeLbl.textColor = [UIColor darkGrayColor];
        createTimeLbl.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:createTimeLbl];
    }
    return self;
}
#pragma mark - 


#pragma mark - Setters
- (void)setAvaImage:(NSString *)imageUrlStr
{
    UIImageView *rssImgView = nil;
    
    if ((imageUrlStr) && (imageUrlStr.length > 0))
    {
        rssImgView = (UIImageView *)[self viewWithTag:RSS_IMG_VIEW_TAG];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [rssImgView setImageWithURL:[NSURL URLWithString:imageUrlStr]
                       placeholderImage:[UIImage imageNamed:@"ava_placeholder"]];
        });
    }
}

- (void)setLabelText:(NSString *)textStr byTag:(NSUInteger)labelTag
{
    UILabel *setLbl = (UILabel *)[self viewWithTag:labelTag];
    
    if (![EMPTY_STRING:textStr])
    {
        setLbl.text = textStr;
    }
    else
        {
            switch (labelTag)
            {
                case NAME_LBL_TAG:
                    setLbl.text = @"Empty Name";
                    break;
                    
                case TEXT_LBL_TAG:
                    setLbl.text = @"Empty Text";
                    break;
                    
                case TIME_LBL_TAG:
                    setLbl.text = @"Empty Time";
                    break;
                    
                default:
                    break;
            }
            
        }
}
#pragma mark -


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end