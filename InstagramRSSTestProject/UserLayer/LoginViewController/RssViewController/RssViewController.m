//
//  RssViewController.m
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "RssViewController.h"
#import "DetailView.h"
#import "RssTableCell.h"
#import "DetailViewController.h"
#import "AboutViewController.h"


@interface RssViewController ()
{
    NSUInteger scrollCount;
    
}
@property (strong, nonatomic) UITableView *rssTable;
@property (strong, nonatomic) NSString *selectLikeTag;
@property (strong, nonatomic) NSArray *likesDataArr;
@end


@implementation RssViewController

@synthesize rssDataArr;
@synthesize rssTable;
@synthesize selectLikeTag;
@synthesize likesDataArr;


#pragma mark - Constructor
- (id)init
{
    self = [super init];
    if (self)
    {
        rssDataArr = [NSMutableArray array];
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Istagram RSS Test";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // ADD CUSTOM LOGOUT BUTTON
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(0.0f, 12.0f, 30.0f, 30.0f);
    [logoutBtn addTarget:self action:@selector(logoutBtnSelector) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setImage:[UIImage imageNamed:@"logout_btn"] forState:UIControlStateNormal];
    [logoutBtn setImage:[UIImage imageNamed:@"logout_btn_tapped"] forState:UIControlStateSelected];
    UIBarButtonItem *logoutBtnItem = [[UIBarButtonItem alloc] initWithCustomView:logoutBtn];
    self.navigationItem.leftBarButtonItem = logoutBtnItem;
    
    // ADD CUSTOM INFO BUTTON
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(0.0f, 6.0f, 30.0f, 30.0f);
    [infoButton addTarget:self action:@selector(aboutBtnSelector) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBtnItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = infoBtnItem;
    
    
    scrollCount = [rssDataArr count] - 1;       // SET COUNT FOR SCROLL
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        likesDataArr = [NSArray arrayWithArray:[[Settings shared] objectForKey:likesListKey]];
        
        [self addRssTable];                     // ADD RSS TABLE
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = NO;
}
#pragma mark -


#pragma mark - Add Table for RSS
- (void)addRssTable
{
    // CREATE RSS TABLE
    rssTable = [self getRssTableByRect:CGRectMake(0.0f, 64.0f, VIEW_WIDTH, VIEW_HEIGHT)];
    rssTable.delegate       = self;
    rssTable.dataSource     = self;
    rssTable.tag            = RSS_TABLE_TAG;
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, self.navigationController.navigationBar.frame.size.height + 20.0f, 0);
    rssTable.contentInset = insets;

    
    // ADD REFRESH CONTROL TO TABLE
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tag = RSS_REFRESH_CONTROL_TAG;
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Loading next events"];
    [refreshControl addTarget:self action:@selector(getNewRss:) forControlEvents:UIControlEventValueChanged];
    [rssTable addSubview:refreshControl];
    
    [self.view addSubview:rssTable];
    [self scrolTableToPosition:scrollCount];
}
#pragma mark -


#pragma mark - logoutBtnSelector
- (void)logoutBtnSelector
{
    //[self showActivityIndicator];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[Settings shared] setObject:[NSString string] forKey:tokenAPIKey];         // CLEAN OLD VALUES BEFORE LOGOUT
        [[Settings shared] setObject:[NSString string] forKey:dateOfTokenKey];
        
        [[Settings shared] setObject:[NSString string] forKey:userRSSKey];
        [[Settings shared] setObject:[NSString string] forKey:maxIdHistoryKey];
        [[Settings shared] setObject:[NSString string] forKey:nextMaxIdKey];
        [[Settings shared] setObject:[NSString string] forKey:nextUrlKey];

        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController popViewControllerAnimated:NO];
    });
}
#pragma mark -


#pragma mark - aboutBtnSelector
- (void)aboutBtnSelector
{
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:aboutVC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
#pragma mark -


#pragma mark - btnSelector:
- (void)btnSelector:(id)sender
{
    UIButton *tapBtn = (UIButton *)sender;
    
    self.selectLikeTag = (NSString *)tapBtn.longTag;                            // GET LIKE ID FOR SEND TO API

    if ((tapBtn.selected) || (tapBtn.tag == LIKED_STATE))
    {
        [tapBtn setSelected:NO];
        [tapBtn setBackgroundImage:[UIImage imageNamed:@"like_btn"] forState:UIControlStateNormal];
        tapBtn.tag = NOT_LIKED_STATE;
        [self sendRequestByType:SEND_DISLIKE_TAG];
    }
    else
        {
            [tapBtn setBackgroundImage:[UIImage imageNamed:@"like_btn_tapped"] forState:UIControlStateNormal];
            [tapBtn setSelected:YES];
            tapBtn.tag = LIKED_STATE;
            [self sendRequestByType:SEND_LIKE_TAG];
        }
}
#pragma mark -


#pragma mark - sendRequestByType:
- (void)sendRequestByType:(NSUInteger)requestType
{
    ApiConnector *ac = [[ApiConnector alloc] init];
    ac.connectDelegate = self;
    
    switch (requestType)
    {
        case GET_RSS_TAG:
        {
            [self showActivityIndicatorWithTitle:@"Loading Images..."];
            
            [ac getRssByUrl:[[Settings shared] objectForKey:nextUrlKey]
                   andToken:[[Settings shared] objectForKey:tokenAPIKey]];
        }
            break;
            
        case SEND_LIKE_TAG:
        {
            [ac sendLikeById:self.selectLikeTag andLike:YES];
        }
            break;
            
        case SEND_DISLIKE_TAG:
        {
            [ac sendLikeById:self.selectLikeTag andLike:NO];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - getNewRss:
- (void)getNewRss:(id)sender
{
    // SET OLD URL FOR COMPARE
    NSString *urlStr = [[Settings shared] objectForKey:nextUrlKey];
    
    if (![urlStr isEqualToString:@"STOP"])
    {
        [self sendRequestByType:GET_RSS_TAG];
    }
    else
        {
            [self hideRefreshIndicator];
            [self showAlert:@"Message" withMessage:@"You don't have a new images for loading."];
        }
}


#pragma mark - ApiConnector Delegate methods
- (void)rssResponseArray:(NSArray *)respArr
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSArray *oldValuesArr = [[NSArray alloc] initWithArray:rssDataArr];     // COPY OLD VALUES
        rssDataArr = nil;
            
        scrollCount = [respArr count] - 1;                                 // SET COUNT FOR SCROLL
            
        if ([respArr count] > 0)
        {
            NSMutableArray *tempMutArr = nil;
            tempMutArr = [[NSMutableArray alloc] initWithArray:respArr];        // ADD NEW VALUES TO DATA ARRAY
            [tempMutArr addObjectsFromArray:oldValuesArr];                      // CONCATENATE OLD & NEW VALUES
            oldValuesArr = nil;
            
            rssDataArr = [[NSMutableArray alloc] initWithArray:tempMutArr];
            
            [[Settings shared] saveRssFromArray:rssDataArr];                // SAVE RSS TO USER_DEFAULTS

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rssTable removeFromSuperview];                        // REFRESH TABLE DATA
                self.rssTable = nil;
                [self addRssTable];
                [self scrolTableToPosition:scrollCount];
            });
        }
        
        [self hideRefreshIndicator];                                        // HIDE REFRESH INDICATOR
   });
}

- (void)sendLikeResponse:(BOOL)resultFlag
{
    dispatch_async (dispatch_get_main_queue(), ^{
        
        NSMutableArray *savedLikesArr =
        [[NSMutableArray alloc] initWithArray:[[Settings shared] objectForKey:likesListKey]];  // GET OLD LIKES (IF HAVE)
        
        if (resultFlag)     // SAVE LIKES HERE
        {
            NSMutableArray *likeMutArr = [NSMutableArray array];
            
            if (![EMPTY_STRING:self.selectLikeTag])
                [likeMutArr addObject:self.selectLikeTag];                  // WRITE ID TO ARRAY FOR SAVE
            
            if ([savedLikesArr count] > 0)
            {
                [likeMutArr addObjectsFromArray:savedLikesArr];  // ADD OLD LIKES
            }
            
            // SAVE PASSED LIKE ID TO LOCAL STORE FOR SHOW LIKE/DISLIKE BUTTON
            if ((likeMutArr != nil) && ([likeMutArr count] > 0))
                [[Settings shared] setObject:likeMutArr forKey:likesListKey];
            else
                [[Settings shared] setObject:[NSArray array] forKey:likesListKey];
        }
        else
            {
                if ([savedLikesArr count] > 0)
                {
                    for (int i = 0; i < [savedLikesArr count]; i++)
                    {
                        if ([self.selectLikeTag isEqualToString:[savedLikesArr objectAtIndex:i]])
                            [savedLikesArr removeObjectAtIndex:i];      // REMOVE STORED LIKE ID FROM LOCAL STORE
                    }
                    
                    if ((savedLikesArr != nil) && ([savedLikesArr count] > 0))
                        [[Settings shared] setObject:savedLikesArr forKey:likesListKey];// SAVE CHANGED ARRAY TO USER_DEF
                    else
                        [[Settings shared] setObject:[NSArray array] forKey:likesListKey];
                }
            }
        
        // REFERSH LIKES DATA_SOURCE
        self.likesDataArr = nil;
        self.likesDataArr = [NSArray arrayWithArray:[[Settings shared] objectForKey:likesListKey]];
        
        self.selectLikeTag = nil;                                                   // CLEAN PASSED STRING
    });
}

- (void)errorResponse:(NSString *)errorStr
{
    self.selectLikeTag = nil;                                                   // CLEAN PASSED STRING
    [self showAlert:ERROR_MSG_TITLE withMessage:errorStr];
}
#pragma mark -


#pragma mark - TableView Helpers
- (void)hideRefreshIndicator
{
    // HIDE REFRESH CONTROL TO TABLE
    UIRefreshControl *refreshControl = (UIRefreshControl *)[self.view viewWithTag:RSS_REFRESH_CONTROL_TAG];
    [refreshControl endRefreshing];
}

- (void)scrolTableToPosition:(NSUInteger)rowPostion
{
    NSIndexPath *endIndex = [NSIndexPath indexPathForRow:rowPostion inSection:0];

    [self.rssTable selectRowAtIndexPath:endIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
    [self.rssTable deselectRowAtIndexPath:endIndex animated:NO];
    
    [self hideActivityIndicator];
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = 0;

	if ([self.rssDataArr count] > 0)
        rowsCount = [self.rssDataArr count];        // NUMBER OF ROWS.
    
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *rssId = @"RssIdentifier";
	
	RssTableCell *cell = nil;
    //(RssTableCell *)[tableView dequeueReusableCellWithIdentifier:rssId];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
	if(cell == nil)
    {
		cell = [[RssTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rssId];
  
        NSString *idStr = [[rssDataArr objectAtIndex:indexPath.row] valueForKeyPath:ID_PATH];
        
        
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];                               // ADD LIKE BUTTON
        likeBtn.frame = CGRectMake(cell.bounds.size.width - 40.0f, 20.0f, 30.0f, 30.0f);
        
        NSString *likeImageTitle = @"like_btn";         // SET TITLE FOR NORMAL STATE
        likeBtn.tag              = NOT_LIKED_STATE;
        
        if (![EMPTY_STRING:idStr])
        {
            likeBtn.longTag = idStr;
            
            for (NSString *searchIdStr in self.likesDataArr)        // SEARCH LIKED PHOTOS
            {
                if ([searchIdStr isEqualToString:idStr])
                {
                    likeImageTitle = @"like_btn_tapped";            // SET LIKED STATE
                    likeBtn.tag    = LIKED_STATE;
                }
            }
        }
        
        [likeBtn setBackgroundImage:[UIImage imageNamed:likeImageTitle] forState:UIControlStateNormal];
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"like_btn_tapped"] forState:UIControlStateHighlighted];
        [likeBtn addTarget:self action:@selector(btnSelector:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:likeBtn];
	}
    
	[cell setAvaImage:[[rssDataArr objectAtIndex:indexPath.row]         // SET LINK TO IMAGE FOR IMAGE_VIEW ON CUSTOM_CELL
                                 valueForKeyPath:RSS_PICTURE_PATH]];
    
	[cell setLabelText:[[rssDataArr objectAtIndex:indexPath.row] valueForKeyPath:FULLNAME_PATH]
                 byTag:NAME_LBL_TAG];                                   // SET TITLE FOR LABEL ON CUSTOM_CELL
    
	[cell setLabelText:[[rssDataArr objectAtIndex:indexPath.row] valueForKeyPath:TEXT_PATH]
                 byTag:TEXT_LBL_TAG];                                   // SET TEXT FOR LABEL ON CUSTOM_CELL
    
    NSString *timeStr = [[rssDataArr objectAtIndex:indexPath.row] valueForKeyPath:CREATETIME_PATH];
    [cell setLabelText:[[Settings shared] setDateEventFromDate:timeStr]
                 byTag:TIME_LBL_TAG];                                   // SET DATE/TIME FOR LABEL ON CUSTOM_CELL
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.detailsDic = [rssDataArr objectAtIndex:indexPath.row];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:detailVC animated:NO];
    });
}
#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
