//
//  ViewController.m
//  TVOSObjectiveC
//
//  Created by Vincent Lee on 11/25/15.
//  Copyright © 2015 Analytics Pros. All rights reserved.
//

#import "ViewController.h"
#import "GATracker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [GATracker screenView:@"FirstScreen" customParameters:nil];
}

- (IBAction)eventTrigger:(id)sender {
    NSLog(@"Fire Event");
    [GATracker event:@"a" action:@"b" label:nil customParameters:nil];
    
}

- (IBAction)nextScreenPressed:(id)sender {
    [self performSegueWithIdentifier:@"toSecondViewController" sender:self];
}


@end
