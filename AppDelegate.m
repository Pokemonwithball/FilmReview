//
//  AppDelegate.m
//  FilmReview
//
//  Created by tarena on 15/10/16.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "PKQMoviesViewController.h"
#import "PKQCinemaViewController.h"
#import "PKQSelfTableViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UMSocialData setAppKey:@"563b586767e58e04fa001fb5"];
    
    [UMSocialWechatHandler setWXAppId:@"wx6cd7b2d07967885f" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    PKQMoviesViewController *movieVC = [[PKQMoviesViewController alloc]initWithNibName:@"PKQMoviesViewController" bundle:nil];
    UINavigationController *naviVc1 = [[UINavigationController alloc]initWithRootViewController:movieVC];
    
    PKQCinemaViewController *cinemaVC = [[PKQCinemaViewController alloc]initWithNibName:@"PKQCinemaViewController" bundle:nil];
    UINavigationController *naviVc2 = [[UINavigationController alloc]initWithRootViewController:cinemaVC];
    
    PKQSelfTableViewController *selfVC = [[PKQSelfTableViewController alloc]initWithNibName:@"PKQSelfTableViewController" bundle:nil];
    UINavigationController *naviVc3 = [[UINavigationController alloc]initWithRootViewController:selfVC];
    
    UITabBarController *tabBar = [[UITabBarController alloc]init];
    tabBar.viewControllers = @[naviVc1,naviVc2,naviVc3];
    tabBar.tabBar.tintColor = [UIColor whiteColor];
    tabBar.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"blue"];
    
    self.window.rootViewController = tabBar;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
