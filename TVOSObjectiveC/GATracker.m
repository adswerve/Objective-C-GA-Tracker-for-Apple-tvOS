//
//  GATracker.m
//  TVOSObjectiveC
//
//  Created by Vincent Lee on 11/25/15.
//  Copyright © 2015 Analytics Pros. All rights reserved.
//

#import "GATracker.h"

@interface GATracker ()

/*
 Define properties
 @tid = Google Analytics property id
 @cid = Google Analytics client id
 @appName = Application Name
 @appVersion = Application Version
 @MPVersion = Measurement Protocol version
 @ua = User Agent string
 */
@property (strong, nonatomic) NSString *tid;
@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *appVersion;
@property (strong, nonatomic) NSString *MPVersion;
@property (strong, nonatomic) NSString *ua;


@end

@implementation GATracker

+ (GATracker *)sharedInstance {
    
    static dispatch_once_t pred;
    static GATracker *shared;
    
    dispatch_once(&pred, ^{
        shared = [[GATracker alloc] init];
    });
    return shared;
}

+ (void)setupWithTrackingID:(NSString *)tid {
    [GATracker sharedInstance].tid = tid;
    [GATracker sharedInstance].appName = [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    [GATracker sharedInstance].appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [GATracker sharedInstance].ua = @"Mozilla/5.0 (Apple TV; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13T534YI";
    [GATracker sharedInstance].MPVersion = @"1";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cid = [defaults stringForKey:@"cid"];
    if (cid) {
        [GATracker sharedInstance].cid = cid;
    }
    else {
        [GATracker sharedInstance].cid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }

}

- (void)sendWithType:(NSString *)type andParams:(NSDictionary *)params {
    NSString *endpoint = @"https://www.google-analytics.com/collect?";
    NSString *parameters = [NSString stringWithFormat:@"v=%@&an=%@&tid=%@&av=%@&cid=%@&t=%@&ua=%@", self.MPVersion, self.appName, self.tid, self.appVersion, self.cid, type, self.ua];
    for (NSString *key in params) {
        [parameters stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, [params objectForKey:key]]];
    }
    
    //Encoding
    NSString *encodedString = [parameters stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSLog(@"%@", encodedString);
    if (encodedString) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", endpoint, encodedString];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSLog(@"%ld", (long)[httpResponse statusCode]);
                }
        [task resume];
        }];
    }
}

- (void)screenViewWithScreenName:(NSString *)screenName customParameters:(NSDictionary *)parameters {
    NSMutableDictionary *screenParameters = @[@"cd", screenName];
    if (screenParameters != nil) {
        for (NSString *key in parameters) {
            parameters valueForKeyPath:<#(nonnull NSString *)#>
        }
    }
    
}
    func screenView(screenName: String, customParameters: Dictionary<String, String>?) {
        /*
         A screenview hit, use screenname
         */
        var params = ["cd" : screenName]
        if (customParameters != nil) {
            for (key, value) in customParameters! {
                params.updateValue(value, forKey: key)
            }
        }
        self.send("screenview", params: params)
    }
}



@end
