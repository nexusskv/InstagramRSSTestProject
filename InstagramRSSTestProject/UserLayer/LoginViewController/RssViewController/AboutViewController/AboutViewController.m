//
//  AboutViewController.m
//  InstagramRSSTestProject
//
//  Created by rost on 23.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()

@end


@implementation AboutViewController


#pragma mark - Constructor
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -


#pragma mark - View life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    dispatch_async(dispatch_get_main_queue(), ^{
        [self createUI];        // CREATE ALL UI
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark -


#pragma mark - createUI
- (void) createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect viewRect = [[UIScreen mainScreen] applicationFrame];
    
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, viewRect.origin.y, self.view.bounds.size.width, 44.0f)];
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"About"];
    [bar pushNavigationItem:titleItem animated:YES];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(5.0f, 7.0f, 60.0f, 32.0f)];
    [backBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"back_tapped_btn"] forState:UIControlStateHighlighted];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
     [backBtn setTitle:@"Back" forState:UIControlStateHighlighted];
    [backBtn setTitleColor:[UIColor colorWithRed:10/255.0f green:143/255.0f blue:231/255.0f alpha:1.0f]
                  forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
     backBtn.titleLabel.font     = [UIFont fontWithName:@"Helvetica" size:16.0];
     backBtn.titleEdgeInsets     = UIEdgeInsetsMake(2.0, 10.0, 0.0, 0.0);
    backBtn.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    [backBtn addTarget:self action:@selector(backBtnSelector) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:backBtn];
    [self.view addSubview:bar];
    

    CGRect webFrame = CGRectMake(0.0f, viewRect.origin.y + bar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height - bar.frame.size.height);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:webFrame];
    webView.delegate = self;
    webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [webView setBackgroundColor:[UIColor clearColor]];
	[webView setOpaque:NO];
    
    NSURL *pathUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"About" ofType:@"html"] isDirectory:NO];
    [webView loadRequest:[NSURLRequest requestWithURL:pathUrl]];
    [self.view addSubview:webView];

}
#pragma mark -


#pragma mark - backBtnSelector
- (void) backBtnSelector
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
        [self.navigationController popViewControllerAnimated:NO];
    });
}
#pragma mark -


#pragma mark - webView delegate method
- (void) webViewDidStartLoad:(UIWebView *)webview
{
	[self showActivityIndicator];
}
#pragma mark -


#pragma mark - webView delegate method
- (void) webViewDidFinishLoad:(UIWebView *)webview
{
	[self hideActivityIndicator];
}
#pragma mark -


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
