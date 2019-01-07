//
//  ViewController.m
//  openTargetTest
//
//  Created by qinglin bi on 2019/1/7.
//  Copyright © 2019年 qinglin bi. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Open.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)bundleId:(id)sender {
    
    id LSApplication = NSClassFromString(@"LSApplicationWorkspace");
    id workspace = [LSApplication bql_invokeMethod:@"defaultWorkspace"];
    [workspace bql_invoke:@"openApplicationWithBundleID:" arguments:@[@"com.biqinglin.ivideo"]];
}

- (IBAction)scheme:(id)sender {
    
    id LSApplication = NSClassFromString(@"LSApplicationRestrictionsManager");
    id shared = [LSApplication bql_invokeMethod:@"sharedInstance"];
    [shared bql_invoke:@"setWhitelistedBundleIDs:" arguments:@[@"com.biqinglin.ivideo"]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"com.biqinglin.ivideo://"] options:@{} completionHandler:^(BOOL success) {
        // 如果!success就重新注册一下，不过我测试发现注册一次，所有app都能通过该函数唤起scheme打开
    }];
}

@end
