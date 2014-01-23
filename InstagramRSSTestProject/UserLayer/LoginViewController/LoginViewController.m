//
//  LoginViewController.m
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "LoginViewController.h"
#import "RssViewController.h"


@interface LoginViewController ()
{
    BOOL isSubmitted;
    UIWebView *authWebView;
}
@property (strong, nonatomic) NSMutableArray *rssDataArr;
@end


@implementation LoginViewController

@synthesize rssDataArr;


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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addLoginWebView];         // ADD LOGIN WEB_VIEW
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    
    NSNumber *tokenDate = [[Settings shared] objectForKey:dateOfTokenKey];
    
    if ((tokenDate) && ([tokenDate intValue] > 0))          // CHECK SAVED TOKEN
    {
        double savedTokenDate     = [[[Settings shared] objectForKey:dateOfTokenKey] longLongValue];
        NSDate *todayDate  = [NSDate date];
        NSDate *savedDate = [NSDate dateWithTimeIntervalSince1970:savedTokenDate];
        
        NSTimeInterval secondsBetween = [todayDate timeIntervalSinceDate:savedDate];
        
        int minuts = secondsBetween / HALF_HOUR;
        
        if (minuts > 30)                        // CHECK VALID TOKEN
        {
            [self refreshToken];
        }
        else
        {
            if ([[Settings shared] objectForKey:userRSSKey] != nil)     // CHECK & SHOW SAVED RSS
            {
                rssDataArr = [NSKeyedUnarchiver unarchiveObjectWithData:[[Settings shared] objectForKey:userRSSKey]];
                
                if ([rssDataArr count] > 0)
                {
                    [self pushRssControllerWithAnimation];
                }
            }
            else
                if ([[Settings shared] objectForKey:tokenAPIKey] != nil)
                    [self getRSSByToken:[[Settings shared] objectForKey:tokenAPIKey]];  // LOAD NEW RSS
        }
    }
    else
        {
            [self showActivityIndicator];
     
            [self refreshToken];            // REFRESH TOKEN
        }
}
#pragma mark -


#pragma mark - addLoginWebView
- (void)addLoginWebView
{
    authWebView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    authWebView.delegate = self;
    [self.view addSubview:authWebView];
    authWebView.alpha = 0.0;
    authWebView.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    authWebView.alpha = 1.0f;
    authWebView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
}
#pragma mark -


#pragma mark - Token methods
- (void)refreshToken
{
    [self showActivityIndicatorWithTitle:@"Loading Autorization..."];
    [[Settings shared] deleteCoockies];
    
    isSubmitted = NO;       // FALSE FLAG FOR SUBMIT CHECK
    
    NSString *fullURL = [NSString stringWithFormat:@"%@&redirect_uri=%@&response_type=token", OAUTH_URL, RedirectURI];
    
    [authWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullURL]]];
}
#pragma mark -


#pragma mark - Get RSS from Web Services
- (void)getRSSByToken:(NSString *)tokenStr
{
    ApiConnector *ac = [[ApiConnector alloc] init];
    ac.connectDelegate = self;
    [ac getRssByUrl:nil andToken:tokenStr];
}
#pragma mark -


#pragma mark - API connector delegate methods
- (void)rssResponseArray:(NSArray *)respArr
{
    if ([respArr count] > 0)
    {
        [rssDataArr addObjectsFromArray:respArr];                        // ADD OBJECTS FROM RESPONSE ARRAY TO TABLE DATA_SOURCE
        
        [[Settings shared] saveRssFromArray:rssDataArr];                // SAVE RSS TO USER_DEFAULTS
        
        [self pushRssControllerWithAnimation];
    }
    else
        {
            // MESSGAGE ABOUT EMPTY RESPONSE FROM SERVER
        }
}

- (void)errorResponse:(NSString *)errorStr
{
    [self hideActivityIndicator];
    
    [self showAlert:ERROR_MSG_TITLE withMessage:errorStr];
}
#pragma mark -


#pragma mark - pushRssControllerWithAnimation
- (void)pushRssControllerWithAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RssViewController *rssVC = [[RssViewController alloc] init];
        rssVC.rssDataArr  = self.rssDataArr;
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:rssVC animated:NO];
    });
}
#pragma mark -


#pragma mark - Web View Delegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSURL *Url = [request URL];
    NSArray *UrlParts = [Url pathComponents];
    
    
    if ((navigationType == UIWebViewNavigationTypeFormSubmitted) && (!isSubmitted))
    {
        NSString *userNameStr = [webView stringByEvaluatingJavaScriptFromString:@"escape(document.getElementById(\"id_username\").value);"];
        NSString *pwdStr = [webView stringByEvaluatingJavaScriptFromString:@"escape(document.getElementById(\"id_password\").value);"];
        
        if ((userNameStr.length < 2) || (pwdStr.length < 6))
        {
            [self stopLoading];
        }
        
        isSubmitted = YES;
    }
    
    if ([[UrlParts objectAtIndex:1] isEqualToString:@"MAMP"])
    {
        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
        if (tokenParam.location != NSNotFound)
        {
            NSString *token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
            
            NSRange endRange = [token rangeOfString: @"&"];
            if (endRange.location != NSNotFound)
                token = [token substringToIndex: endRange.location];
            
            if ([token length] > 0 )
            {
                double todaySeconds = [[NSDate date] timeIntervalSince1970];
                NSNumber *tokenDate = [NSNumber numberWithDouble:todaySeconds];
                
                [[Settings shared] setObject:token forKey:tokenAPIKey];             // SAVE TOKNE TO USER_DEFAULTS
                [[Settings shared] setObject:tokenDate forKey:dateOfTokenKey];  // SAVE DATE OF SAVE TOKEN FOR CHECK A VALID TOKEN
                
                [self showActivityIndicatorWithTitle:@"Loading RSS..."];
                [self getRSSByToken:token];
            }
        }
        else
            {
                // Handle the access rejected case.               
                [self hideActivityIndicator];
            }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *respStr = [webView stringByEvaluatingJavaScriptFromString:
                         @"document.getElementsByClassName('alert-red')[0].innerHTML;"];
    
    if ([respStr isEqualToString:LOGIN_INCORECT_MSG])
    {
        [self stopLoading];
    }
    else
        {
            if (!isSubmitted)
                [self hideActivityIndicator];
        }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (!isSubmitted)
        [self hideActivityIndicator];
}
#pragma mark -


#pragma mark - stopLoading
- (void)stopLoading
{
    [self showAlert:@"Message" withMessage:@"Please enter a valid user name & password."];
    return;
}
#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
