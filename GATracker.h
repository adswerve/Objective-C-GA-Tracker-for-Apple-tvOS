//
//  GATracker.h
//  TVOSObjectiveC
//
//  Created by Vincent Lee on 11/25/15.
//  Copyright © 2015 Analytics Pros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATracker : NSObject

@property (strong, nonatomic) NSString *cid;
@property (strong, nonatomic) NSString *appName;
@property (strong, nonatomic) NSString *appVersion;
@property (strong, nonatomic) NSString *MPVersion;
@property (strong, nonatomic) NSString *ua;

+ (void)setupWithTrackingID:(NSString *)tid;
+ (void)send:(NSString *)type andParams:(NSDictionary *)params;
+ (void)screenView:(NSString *)screenName customParameters:(NSDictionary *)parameters;
+ (void)event:(NSString *)category action:(NSString *)action label:(NSString *)label customParameters:(NSDictionary *)parameters;
+ (void)excpetionWithDescription:(NSString *)description isFatal:(BOOL)isFatal customParameters:(NSDictionary *)parameters;

@end
