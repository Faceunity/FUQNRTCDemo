//
//  AppDelegate.m
//  QNRTCKitDemo
//
//  Created by lawder on 2017/10/16.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "QRDLoginViewController.h"
#import <QNRTCKit/QNRTCKit.h>
#import <Bugsnag.h>

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugsnag startBugsnagWithApiKey:@"5c557cf459b88bd2726b2055530eac91"];
    
    QRDLoginViewController *loginVC = [[QRDLoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    [QNRTCSession enableFileLogging];
    return YES;
}


@end
