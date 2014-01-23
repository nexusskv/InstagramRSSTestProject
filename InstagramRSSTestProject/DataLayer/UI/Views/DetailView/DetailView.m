//
//  DetailView.m
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView


#pragma mark - Share method
+ (DetailView *)shared
{
    static DetailView *sharedInstanse;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{ sharedInstanse = [[self alloc] init]; });
    
    return sharedInstanse;
}
#pragma mark - 


#pragma mark - Constructor
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
    }
    return self;
}
#pragma mark -


#pragma mark - Custom Constructor
- (id)initWithFrame:(CGRect)frame andParams:(NSDictionary *)paramsDic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSString *urlStr            = [paramsDic valueForKey:@"url"];
        NSString *nameStr           = [paramsDic valueForKey:@"name"];
        NSString *userAvaUrlStr     = [paramsDic valueForKey:@"user_ava"];
        NSString *timeStr           = [paramsDic valueForKey:@"time"];
        NSString *themeStr          = [paramsDic valueForKey:@"theme"];
        NSString *likesTitlesStr    = [paramsDic valueForKey:@"likes_titles"];

        
        // ADD USER AVA IMAGE
        CGRect avaRect = CGRectMake(10.0f, 40.0f, 60.0f, 60.0f);
        [self addBigImageFromRect:avaRect andUrl:userAvaUrlStr andImage:nil];
        
        
        float labelWidth = self.bounds.size.width - 100.0f;     // WIDTH FOR ALL TOP LABELS
        
        UIColor *titlesColor = [UIColor colorWithRed:33/255.0f green:102/255.0f blue:228/255.0f alpha:1.0f];
        
        
        // ADD USER_NAME LABEL
        CGRect nameRect = CGRectMake(90.0f, frame.origin.y + 6.0f, labelWidth, 20.0f);
        
        UILabel *userNameLbl = nil;
        if ((nameStr) && (nameStr.length > 0))
        {
            userNameLbl = [self setLabelWithFrame:nameRect withTitle:nameStr andFontSize:16.0f];
            userNameLbl.textColor = titlesColor;
            [self addSubview:userNameLbl];
        }
        
        
        // ADD TIME LABEL
        CGRect timeRect = CGRectMake(90.0f, frame.origin.y + 26.0f, labelWidth, 20.0f);
        
        UILabel *timeLbl = nil;
        if ((timeStr) && (timeStr.length > 0))
        {
            timeLbl = [self setLabelWithFrame:timeRect
                                    withTitle:[[Settings shared] calcTimeDifferenceByTime:timeStr]
                                  andFontSize:15.0f];
            timeLbl.textColor = [UIColor lightGrayColor];
            [self addSubview:timeLbl];
        }
        
        
        // ADD THEME OF POST LABEL
        CGRect themeRect = CGRectMake(90.0f, timeLbl.frame.origin.y + 20.0f, labelWidth, 20.0f);
        
        UILabel *themeLbl = nil;
        if ((themeStr) && (themeStr.length > 0))
        {
            themeLbl = [self setLabelWithFrame:themeRect withTitle:themeStr andFontSize:0.0f];
            themeLbl.textColor = [UIColor blackColor];
            themeLbl.font      = [UIFont systemFontOfSize:13.0f];
            [self addSubview:themeLbl];
        }
        
        
        // ADD SEPARATOR LINE
        CGRect lineRect = CGRectMake(10.0f, avaRect.origin.y + avaRect.size.height + 10.0f, self.bounds.size.width - 20.0f, 0.3f);
        [self addSeparatorLineByFrame:lineRect];

        
        // ADD POSTED IMAGE IN BIG SIZE
        CGRect imgRect = CGRectMake(10.0f, lineRect.origin.y + 15.0f, self.bounds.size.width - 20.0f, self.bounds.size.height / 2.0f);
        [self addBigImageFromRect:imgRect andUrl:urlStr andImage:nil];
        
        
        // ADD SEPARATOR LINE
        CGRect secLineRect = CGRectMake(10.0f, imgRect.origin.y + imgRect.size.height + 10.0f, self.bounds.size.width - 20.0f, 0.3f);
        [self addSeparatorLineByFrame:secLineRect];
        
        
        // ADD LIKES LOGO IMAGE
        CGRect likesRect = CGRectMake(10.0f, imgRect.origin.y + imgRect.size.height + 25.0f, 20.0f, 18.0f);
        [self addBigImageFromRect:likesRect andUrl:nil andImage:@"likes_logo_inactive"];
        
        
        // ADD LIKES LABEL
        float likeLblXIndent = likesRect.origin.x + likesRect.size.width + 10.0f;
        float likeLblWidth   = self.bounds.size.width - (likeLblXIndent + 5.0f);
        CGRect likesTitleRect = CGRectMake(likeLblXIndent, likesRect.origin.y - 8.0f, likeLblWidth, 40.0f);
        
        UILabel *likesTitleLbl = nil;
        if (![EMPTY_STRING:likesTitlesStr])
        {
            likesTitleLbl = [self setLabelWithFrame:likesTitleRect withTitle:likesTitlesStr andFontSize:0.0f];
            likesTitleLbl.textColor = titlesColor;
            likesTitleLbl.font      = [UIFont systemFontOfSize:13.0f];
            likesTitleLbl.numberOfLines = 3;
            [self addSubview:likesTitleLbl];
        }
    }
    return self;
}
#pragma mark -


#pragma mark - addBigImageFromRect:andUrl:
- (void)addBigImageFromRect:(CGRect)imgRect andUrl:(NSString *)urlStr andImage:(NSString *)imgStr
{
    UIImageView *detailImgView = [[UIImageView alloc] initWithFrame:imgRect];
    detailImgView.layer.cornerRadius    = 7.0f;
    detailImgView.layer.masksToBounds   = YES;
    detailImgView.autoresizingMask      = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    detailImgView.contentMode           = UIViewContentModeScaleAspectFit;
    [self addSubview:detailImgView];
    
    if ((urlStr) && (urlStr.length > 0))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [detailImgView setImageWithURL:[NSURL URLWithString:urlStr]
                          placeholderImage:[UIImage imageNamed:@"ava_placeholder"]];
        });
    }
    else
        if ((imgStr) && (imgStr.length > 0))
            detailImgView.image = [UIImage imageNamed:imgStr];
}
#pragma mark - 


#pragma mark - addSeparatorLineByFrame:
- (void)addSeparatorLineByFrame:(CGRect)lineRect
{
    UILabel *lineLbl = [self setLabelWithFrame:lineRect withTitle:nil andFontSize:0];
    lineLbl.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLbl];
}
#pragma mark -


#pragma mark - setLabelWithFrame:withTitle:andTag:andFontSize:
- (UILabel *)setLabelWithFrame:(CGRect)lblRect withTitle:(NSString *)titleStr andFontSize:(NSUInteger)fontSize
{
    UILabel *setLbl = [[UILabel alloc] initWithFrame:lblRect];
    
    if ((titleStr) && (titleStr.length > 0))
    {
        setLbl.text            = titleStr;
    }

    setLbl.backgroundColor = [UIColor clearColor];
    setLbl.textColor       = [UIColor blackColor];
    setLbl.textAlignment   = NSTextAlignmentLeft;
    setLbl.font            = [UIFont boldSystemFontOfSize:fontSize];
    setLbl.lineBreakMode   = NSLineBreakByWordWrapping;
    setLbl.numberOfLines   = 0;
    
    return setLbl;
}
#pragma mark -

@end
