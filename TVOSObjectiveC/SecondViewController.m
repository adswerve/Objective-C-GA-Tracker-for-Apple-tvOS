//
//  SecondViewController.m
//  TVOSObjectiveC
//
//  Created by Vincent Lee on 1/12/16.
//  Copyright © 2016 Analytics Pros. All rights reserved.
//

#import "SecondViewController.h"
#import "GATracker.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [GATracker screenView:@"SecondScreen" customParameters:@{@"cd1" : @"Seattle", @"cm2" : @"2"}];
    
}

- (IBAction)fireException:(id)sender {
    NSLog(@"Exception Fired");
    [GATracker send:@"transaction" andParams:@{@"tid" : @"10001", @"tr" : @"425", @"cu" : @"USD"}];
    [GATracker excpetionWithDescription:@"This test failed" isFatal:true customParameters:nil];
}

@end
