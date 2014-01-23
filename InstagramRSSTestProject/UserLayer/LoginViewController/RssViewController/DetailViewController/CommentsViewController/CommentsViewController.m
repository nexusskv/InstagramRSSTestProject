//
//  CommentsViewController.m
//  InstagramRSSTestProject
//
//  Created by rost on 20.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "CommentsViewController.h"
#import "RssTableCell.h"

@interface CommentsViewController ()

@end


@implementation CommentsViewController

@synthesize commentsArr;

#pragma mark - Constructor
- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad
{
    //self.view.frame = CGRectMake(VIEW_WIDTH - 250.0f, 0.0f, 250.0f, VIEW_HEIGHT);
    //self.view.frame = CGRectMake(0.0f, 44.0f, VIEW_WIDTH, VIEW_HEIGHT - 44.0f);
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNavBarWithTitle:@"Comments" andFrame:CGRectMake(0.0f, 0.0f, 300.0f, 44.0f)];
    
    UITableView *commentsTable = [self getRssTableByRect:CGRectMake(0.0f, 45.0f, VIEW_WIDTH, VIEW_HEIGHT - 44.0f)];
    commentsTable.delegate       = self;
    commentsTable.dataSource     = self;
    
    [self.view addSubview:commentsTable];
}
#pragma mark -


#pragma mark - TableView Delegate & DataSourse Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsCount = 0;
    
	if ([self.commentsArr count] > 0)
        rowsCount = [self.commentsArr count];        // NUMBER OF ROWS.
    
    return rowsCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *commentsId = @"CommentsIdentifier";
	
	RssTableCell *cell = (RssTableCell *)[tableView dequeueReusableCellWithIdentifier:commentsId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	if(cell == nil)
    {
		cell = [[RssTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentsId];
	}
    
    // SET LINK TO IMAGE FOR IMAGE_VIEW ON CELL
    NSString *avaStr = [[commentsArr objectAtIndex:indexPath.row] valueForKeyPath:COMMENT_USER_AVA_PATH];
    
    if ((avaStr) && (avaStr.length > 0))
        [cell setAvaImage:avaStr];
    
    // SET TITLE TO LABEL ON CUSTOM_CELL
    NSString *titleStr = [[commentsArr objectAtIndex:indexPath.row] valueForKeyPath:COMMENT_USER_NAME_PATH];
    
    if ((titleStr) && (titleStr.length > 0))
        [cell setLabelText:titleStr byTag:NAME_LBL_TAG];
    
    // SET COMMENT TO LABEL ON CELL
    NSString *commentStr = [[commentsArr objectAtIndex:indexPath.row] valueForKeyPath:COMMENT_TEXT_PATH];
    
    if ((commentStr) && (commentStr.length > 0))
        [cell setLabelText:commentStr byTag:TEXT_LBL_TAG];
    
    NSString *timeStr = [[commentsArr objectAtIndex:indexPath.row] valueForKeyPath:COMMENT_TIME_PATH];
    
    if ((commentStr) && (commentStr.length > 0))
        [cell setLabelText:[[Settings shared] setDateEventFromDate:timeStr] byTag:TIME_LBL_TAG];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
