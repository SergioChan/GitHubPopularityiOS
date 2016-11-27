//
//  SCDefaultsManager.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 27/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCDefaultsManager.h"
#define KEY_NAME            @"GitHubNotificationsName"
#define KEY_TOKEN           @"GitHubNotificationsToken"
#define KEY_STAR_ARRAY      @"GitHubNotificationsStar"
#define KEY_FOLLOWER_ARRAY  @"GitHubNotificationsFollower"
#define KEY_REPO_DICT       @"GitHubNotificationsRepo"
#define KEY_RENDER_STAR_ARRAY      @"GitHubNotificationsRenderStar"
#define KEY_RENDER_FOLLOWER_ARRAY  @"GitHubNotificationsRenderFollower"

@interface SCDefaultsManager()

@property (nonatomic, strong) NSUserDefaults *groupDefaults;

@end

@implementation SCDefaultsManager

+ (id)sharedManager {
    static SCDefaultsManager *sharedMyManager = nil;
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
        _groupDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.sergio.chan.GitHubNotification"];
    }
    return self;
}

- (void)setUserName:(NSString *)name
{
    [_groupDefaults setObject:name forKey:KEY_NAME];
}

- (NSString *)getUserName
{
    if ([_groupDefaults objectForKey:KEY_NAME]) {
        return [_groupDefaults objectForKey:KEY_NAME];
    } else {
        [_groupDefaults setObject:@"" forKey:KEY_NAME];
        return @"";
    }
}

- (void)clearCache
{
    [_groupDefaults setObject:@[] forKey:KEY_STAR_ARRAY];
    [_groupDefaults setObject:@[] forKey:KEY_FOLLOWER_ARRAY];
    [_groupDefaults setObject:@{} forKey:KEY_REPO_DICT];
}

- (void)setUserToken:(NSString *)token
{
    [_groupDefaults setObject:token forKey:KEY_TOKEN];
}

- (NSString *)getUserToken
{
    if ([_groupDefaults objectForKey:KEY_TOKEN]) {
        return [_groupDefaults objectForKey:KEY_TOKEN];
    } else {
        [_groupDefaults setObject:@"" forKey:KEY_TOKEN];
        return @"";
    }
}

- (void)setStarArray:(NSArray *)data
{
    [_groupDefaults setObject:data forKey:KEY_STAR_ARRAY];
}

- (NSArray *)getStarArray
{
    if ([_groupDefaults objectForKey:KEY_STAR_ARRAY]) {
        return [_groupDefaults objectForKey:KEY_STAR_ARRAY];
    } else {
        [_groupDefaults setObject:@[] forKey:KEY_STAR_ARRAY];
        return @[];
    }
}

- (void)setFollowersNumber:(NSInteger)data
{
    [_groupDefaults setObject:@(data) forKey:KEY_FOLLOWER_ARRAY];
}

- (NSInteger)getFollowersNumber
{
    if ([_groupDefaults objectForKey:KEY_FOLLOWER_ARRAY]) {
        return [[_groupDefaults objectForKey:KEY_FOLLOWER_ARRAY] integerValue];
    } else {
        [_groupDefaults setObject:@(-1) forKey:KEY_FOLLOWER_ARRAY];
        return -1;
    }
}

- (void)addDeltaToRenderFollowersDict:(NSInteger)delta toKey:(NSString *)key
{
    NSMutableDictionary *dict = [[self getRenderFollowersDict] mutableCopy];
    if ([dict objectForKey:key]) {
        NSInteger tmp = [[dict objectForKey:key] integerValue];
        [dict setValue:@(tmp + delta) forKey:key];
        [_groupDefaults setObject:dict forKey:KEY_RENDER_FOLLOWER_ARRAY];
    } else {
        [dict setObject:@(0 + delta) forKey:key];
        [_groupDefaults setObject:dict forKey:KEY_RENDER_FOLLOWER_ARRAY];
    }
}

- (NSDictionary *)getRenderFollowersDict
{
    if ([_groupDefaults objectForKey:KEY_RENDER_FOLLOWER_ARRAY]) {
        return [_groupDefaults objectForKey:KEY_RENDER_FOLLOWER_ARRAY];
    } else {
        [_groupDefaults setObject:@{} forKey:KEY_RENDER_FOLLOWER_ARRAY];
        return @{};
    }
}

- (void)setRenderStarArray:(NSArray *)data
{
    [_groupDefaults setObject:data forKey:KEY_RENDER_STAR_ARRAY];
}

- (NSArray *)getRenderStarArray
{
    if ([_groupDefaults objectForKey:KEY_RENDER_STAR_ARRAY]) {
        return [_groupDefaults objectForKey:KEY_RENDER_STAR_ARRAY];
    } else {
        [_groupDefaults setObject:@[] forKey:KEY_RENDER_STAR_ARRAY];
        return @[];
    }
}

- (void)setRepoCached:(BOOL)cached repoName:(NSString *)repo
{
    NSMutableDictionary *dict = [self getRepoCachedDict];
    [dict setObject:@(cached) forKey:repo];
    [_groupDefaults setObject:dict forKey:KEY_REPO_DICT];
}

- (NSMutableDictionary *)getRepoCachedDict
{
    if ([_groupDefaults objectForKey:KEY_REPO_DICT]) {
        return [[_groupDefaults objectForKey:KEY_REPO_DICT] mutableCopy];
    } else {
        [_groupDefaults setObject:@{} forKey:KEY_REPO_DICT];
        return [NSMutableDictionary dictionary];
    }
}

- (BOOL)isRepoCached:(NSString *)repoName
{
    if ([_groupDefaults objectForKey:KEY_REPO_DICT]) {
        if ([[_groupDefaults objectForKey:KEY_REPO_DICT] objectForKey:repoName]) {
            return [[[_groupDefaults objectForKey:KEY_REPO_DICT] objectForKey:repoName] boolValue];
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end
