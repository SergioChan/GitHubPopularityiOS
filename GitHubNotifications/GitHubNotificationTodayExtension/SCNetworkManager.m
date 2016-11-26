//
//  SCNetworkManager.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCNetworkManager.h"

@implementation SCNetworkManager

+ (id)sharedManager {
    static SCNetworkManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)getNumberOfFollowersForUser:(NSString *)userName
                            success:(successWithObjectAndResponseBlock)onSuccess
                            failure:(failErrorBlock)onFailure
{
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"https://api.github.com/users/%@",userName] parameters:@{} error:nil];
    
    // Add two HEADER
    [req setValue:userName forHTTPHeaderField:@"User-Agent"];
    
    [self sendRequest:req
         successBlock:^(id object, NSURLResponse *response) {
             if (object) {
                 if ([object objectForKey:@"followers"]) {
                     onSuccess([object objectForKey:@"followers"], response);
                 } else {
                     NSError *error = [[NSError alloc] initWithDomain:@"sergio.chan.GitHubNotifications" code:-1001 userInfo:nil];
                     onFailure(error);
                 }
             } else {
                 NSError *error = [[NSError alloc] initWithDomain:@"sergio.chan.GitHubNotifications" code:-1000 userInfo:nil];
                 onFailure(error);
             }
         } failureBlock:onFailure];
}

- (void)getRepoForUser:(NSString *)userName
                  page:(NSInteger)page
               success:(successWithObjectAndResponseBlock)onSuccess
               failure:(failErrorBlock)onFailure
{
    if (page == 0) {
        // page is 1-based
        page = 1;
    }
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"https://api.github.com/users/%@/repos",userName] parameters:@{@"page":@(page),@"per_page":@(100)} error:nil];
    
    // Add two HEADER
    [req setValue:userName forHTTPHeaderField:@"User-Agent"];
    
    [self sendRequest:req
         successBlock:^(id object, NSURLResponse *response) {
             onSuccess(object,response);
         } failureBlock:onFailure];
}

- (void)getStarForUser:(NSString *)userName
                  repo:(NSString *)repo
                      page:(NSInteger)page
                  success:(successWithObjectAndResponseBlock)onSuccess
                  failure:(failErrorBlock)onFailure
{
    if (page == 0) {
        // page is 1-based
        page = 1;
    }
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/stargazers",userName,repo] parameters:@{@"page":@(page),@"per_page":@(100)} error:nil];
    
    // Add two HEADER
    [req setValue:@"application/vnd.github.v3.star+json" forHTTPHeaderField:@"Accept"];
    [req setValue:userName forHTTPHeaderField:@"User-Agent"];
    
    [self sendRequest:req
         successBlock: ^(id object, NSURLResponse *response) {
             onSuccess(object,response);
         } failureBlock:onFailure];
}

- (void)sendRequest:(NSMutableURLRequest *)req
       successBlock:(successWithObjectAndResponseBlock)onSuccess
       failureBlock:(failErrorBlock)onFailure {
    
    req.timeoutInterval = 20.0f;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[manager dataTaskWithRequest:req
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    if (error) {
                        onFailure(error);
                    } else {
                        onSuccess(responseObject, response);
                    }
                }] resume];
}

@end
