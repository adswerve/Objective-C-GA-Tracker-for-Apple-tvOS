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
        [[NSUserDefaults standardUserDefaults] setObject:[GATracker sharedInstance].cid forKey:@"cid"];
    }

}

+ (void)send:(NSString *)type andParams:(NSDictionary *)params {
    /*
     Generic hit sender to Measurement Protocol
     Consists out of hit type and a dictionary of other parameters
     */
    NSString *endpoint = @"https://www.google-analytics.com/collect?";
    NSMutableString *parameters = [NSMutableString stringWithFormat:@"v=%@&an=%@&tid=%@&av=%@&cid=%@&t=%@&ua=%@", [GATracker sharedInstance].MPVersion, [GATracker sharedInstance].appName, [GATracker sharedInstance].tid, [GATracker sharedInstance].appVersion, [GATracker sharedInstance].cid, type, [GATracker sharedInstance].ua];
    for (NSString *key in params) {
        [parameters appendString:[NSString stringWithFormat:@"&%@=%@", key, [params valueForKey:key]]];
    }
    
    //Encoding
    NSString *encodedString = [parameters stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    if (encodedString) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", endpoint, encodedString];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
#if DEBUG
        NSLog(@"%@", urlString);
#endif
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if ([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSLog(@"%ld", (long)[httpResponse statusCode]);
                }
                else {
                    if (error) {
#if DEBUG
                        NSLog(@"%@", error.description);
#endif
                    }
                }
        }];
    [task resume];
    }
}

+ (void)screenView:(NSString *)screenName customParameters:(NSDictionary *)parameters {
    /*
     A screenview hit, use screenname
     */
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"cd": screenName}];
    if (parameters != nil) {
        for (NSString *key in parameters) {
            [params setObject:[parameters valueForKey:key] forKey:key];
        }
    }
    [GATracker send:@"screenview" andParams:params];
}

+ (void)event:(NSString *)category action:(NSString *)action label:(NSString *)label customParameters:(NSDictionary *)parameters {
    /*
     An event hit with category, action, label
     */
    if (label == nil) {
        label = @"";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"ec": category, @"ea": action, @"el": label}];
    if (parameters != nil) {
        for (NSString *key in parameters) {
            [params setObject:[parameters valueForKey:key] forKey:key];
        }
    }
    [self send:@"event" andParams:params];
}

+ (void)excpetionWithDescription:(NSString *)description isFatal:(BOOL)isFatal customParameters:(NSDictionary *)parameters {
    /*
     An exception hit with exception description (exd) and "fatality"  (Crashed or not) (exf)
     */
    NSString *fatal = @"0";
    if (isFatal) {
        fatal = @"1";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"exd": description, @"exf": fatal}];
    if (parameters != nil) {
        for (NSString *key in parameters) {
            [params setObject:[parameters valueForKey:key] forKey:key];
        }
    }
    [self send:@"exception" andParams:params];
}



@end
