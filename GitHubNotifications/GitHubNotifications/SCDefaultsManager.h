//
//  SCDefaultsManager.h
//  GitHubNotifications
//
//  Created by 叔 陈 on 27/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCDefaultsManager : NSObject

+ (id)sharedManager;

- (void)setFirstLogin:(BOOL)firstLogin;
- (BOOL)isFirstLogin;

// UserName
- (void)setUserName:(NSString *)name;
- (NSString *)getUserName;

// UserAccessToken
- (void)setUserToken:(NSString *)token;
- (NSString *)getUserToken;

- (void)setStarNumber:(NSInteger)star;
- (NSInteger)getCachedStarNumber;

// StarArray : Array -> [(SCStar)]
- (void)setStarArray:(NSArray *)data;
- (NSArray *)getStarArray;

// FollowersArray : Array -> [(SCFollower)]
- (void)setFollowersNumber:(NSInteger)data;
- (NSInteger)getFollowersNumber;

// RepoArray : Dict -> repo:{cached(BOOL)}
- (void)setRepoCached:(BOOL)cached;
- (BOOL)isRepoCached;

- (void)setRenderStarArray:(NSArray *)data;
- (NSArray *)getRenderStarArray;

- (void)addDeltaToRenderFollowersDict:(NSInteger)delta toKey:(NSString *)key;
- (NSDictionary *)getRenderFollowersDict;

- (void)clearCache;

@end
