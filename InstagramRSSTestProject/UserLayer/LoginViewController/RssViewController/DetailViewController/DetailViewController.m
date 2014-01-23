//
//  DetailViewController.m
//  InstagramRSSTestProject
//
//  Created by rost on 17.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailView.h"
#import "UIViewController+JTRevealSidebar.h"
#import "UINavigationItem+JTRevealSidebar.h"



@interface DetailViewController ()

@end


@implementation DetailViewController

@synthesize detailsDic;
@synthesize commentsView;


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


#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (![EMPTY_STRING:[detailsDic valueForKeyPath:FULLNAME_PATH]])
        self.title = [detailsDic valueForKeyPath:FULLNAME_PATH];
    else
        if (![EMPTY_STRING:[detailsDic valueForKeyPath:SELF_NAME_PATH]])
            self.title = [detailsDic valueForKeyPath:@"user.full_name"];

    UIBarButtonItem *commentsBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(tapCommentsButton:)];
    
    self.navigationItem.rightBarButtonItem = commentsBtn;
    self.navigationItem.revealSidebarDelegate = self;
    
    NSMutableString *usersLikeStr = [NSMutableString string];
    
    NSArray *likesArr = [detailsDic valueForKeyPath:LIKES_NAMES_PATH];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([likesArr count] > 0)
        {
            for (int i = 0; i < [likesArr count]; i++)
            {
                NSString *titleStr = [[likesArr objectAtIndex:i] valueForKey:@"full_name"];
                
                if (![EMPTY_STRING:titleStr])
                {
                    [usersLikeStr appendString:titleStr];
                    
                    if (i < [likesArr count] - 1)
                        [usersLikeStr appendString:@", "];
                    else
                        [usersLikeStr appendString:@"..."];
                }
            }
        }
        
        // SET PARAMS DICTIONARY FROM INCOMING VALUES
        NSDictionary *paramDic = [[Settings shared] setDetailsDictionary:detailsDic andTitlesString:usersLikeStr];
        
        // PASS VALUES TO VIEW & CREATE VIEW
        UIView *detailView = [[DetailView alloc] initWithFrame:CGRectMake(0.0f, 35.0f, VIEW_WIDTH , VIEW_HEIGHT)
                                                     andParams:paramDic];
        
        [self.view addSubview:detailView];
    });
}
#pragma mark -


#pragma mark - tapCommentsButton:
- (void)tapCommentsButton:(id)sender
{
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}
#pragma mark -


#pragma mark - JTRevealSidebarDelegate methods
- (UIView *)viewForRightSidebar
{
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    commentsView = [[CommentsViewController alloc] init];
    commentsView.commentsArr = [detailsDic valueForKeyPath:COMMENTS_SOURCE_PATH];
    CommentsViewController *exempView = self.commentsView;

    if (!exempView)
    {
        exempView = self.commentsView = [[CommentsViewController alloc] init];
    }
    
    exempView.view.frame = CGRectMake(self.navigationController.view.frame.size.width - 270.0f, viewFrame.origin.y, 270.0f, viewFrame.size.height);
    exempView.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    return exempView.view;
}

- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController
{
    // Example to disable userInteraction on content view while sidebar is revealing
    if (viewController.revealedState == JTRevealedStateNo) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}
#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
