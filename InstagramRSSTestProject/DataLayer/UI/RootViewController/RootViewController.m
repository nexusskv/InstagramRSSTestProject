//
//  RootViewController.m
//  InstagramRSSTestProject
//
//  Created by rost on 19.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "RootViewController.h"
#import "DSActivityView.h"


@interface RootViewController ()
@property (weak, nonatomic) DSActivityView *indicatorView;
@end


@implementation RootViewController

@synthesize indicatorView;


#pragma mark - Constructor
- (id)init
{
    self = [super init];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
#pragma mark -


#pragma mark - View Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark -


#pragma mark - Destructor
- (void)dealloc
{
    self.indicatorView = nil;
}
#pragma mark - 


#pragma mark - addNavBarWithTitle:andFrame:
- (void)addNavBarWithTitle:(NSString *)titleStr andFrame:(CGRect)barFrame
{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:barFrame];
    

    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];

    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:titleStr];
    [bar pushNavigationItem:title animated:YES];
    
    [self.view addSubview:bar];
}
#pragma mark -


#pragma mark - setLabelWithFrame:withTitle:andTag:
- (UILabel *)setLabelWithFrame:(CGRect)lblRect withTitle:(NSString *)titleStr andTag:(NSUInteger)lblTag
{
    UILabel *setLbl = [[UILabel alloc] initWithFrame:lblRect];
    
    if ((titleStr) && (titleStr.length > 0))
    {
        setLbl.text            = titleStr;
    }
    
    if (lblTag > 0 )
    {
        setLbl.tag = lblTag;
    }
    setLbl.backgroundColor = [UIColor clearColor];
    setLbl.textColor       = [UIColor blackColor];
    setLbl.textAlignment   = NSTextAlignmentLeft;
    setLbl.font            = [UIFont systemFontOfSize:14.0f];
    setLbl.lineBreakMode   = NSLineBreakByWordWrapping;
    setLbl.numberOfLines   = 0;

    return setLbl;
}
#pragma mark -


#pragma mark - getRssTableByRect:
- (UITableView *)getRssTableByRect:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor   = [UIColor clearColor];
    tableView.scrollEnabled     = YES;
    
    return tableView;
}
#pragma mark -


#pragma mark - showAlert:withMessage:
- (void)showAlert:(NSString *)titleStr withMessage:(NSString *)msgStr
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr
                                                    message:msgStr
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
#pragma mark -


#pragma mark - Activity indicator lib methods
- (void)showActivityIndicatorWithTitle:(NSString *)title
{
    self.indicatorView = [DSBezelActivityView activityViewForView:self.view withLabel:title];
}

- (void)showActivityIndicator
{
	[self showActivityIndicatorWithTitle:nil];
}

- (void)changeActivityIndicatorTitleTo:(NSString *)title
{
	[DSBezelActivityView currentActivityView].activityLabel.text = title;
    self.indicatorView = [DSBezelActivityView currentActivityView];
}

- (void)hideActivityIndicator
{
	[DSBezelActivityView removeViewAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [DSActivityView removeView];
    self.indicatorView = nil;
}
#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
