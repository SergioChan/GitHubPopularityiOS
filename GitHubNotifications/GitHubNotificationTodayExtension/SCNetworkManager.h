//
//  SCNetworkManager.h
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface SCNetworkManager : NSObject

typedef void (^failErrorBlock)(NSError *error);
typedef void (^successWithObjectBlock)(id object);
typedef void (^successWithObjectAndResponseBlock)(id object, NSURLResponse *response);

+ (id)sharedManager;

- (void)getNumberOfFollowersForUser:(NSString *)userName
                            success:(successWithObjectAndResponseBlock)onSuccess
                            failure:(failErrorBlock)onFailure;
- (void)getRepoForUser:(NSString *)userName
                  page:(NSInteger)page
               success:(successWithObjectAndResponseBlock)onSuccess
               failure:(failErrorBlock)onFailure;
- (void)getStarForUser:(NSString *)userName
                  repo:(NSString *)repo
                  page:(NSInteger)page
               success:(successWithObjectAndResponseBlock)onSuccess
               failure:(failErrorBlock)onFailure;

@end
