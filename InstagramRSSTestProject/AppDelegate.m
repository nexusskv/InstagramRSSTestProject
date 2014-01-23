//
//  AppDelegate.m
//  InstagramRSSTestProject
//
//  Created by rost on 16.01.14.
//  Copyright (c) 2014 rost. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"


@implementation AppDelegate

@synthesize nc;


#pragma mark - application:didFinishLaunchingWithOptions:
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{  
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    nc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark -

@end
