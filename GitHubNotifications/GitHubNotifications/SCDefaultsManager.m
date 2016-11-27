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

- (void)setFollowersArray:(NSArray *)data
{
    [_groupDefaults setObject:data forKey:KEY_FOLLOWER_ARRAY];
}

- (NSArray *)getFollowersArray
{
    if ([_groupDefaults objectForKey:KEY_FOLLOWER_ARRAY]) {
        return [_groupDefaults objectForKey:KEY_FOLLOWER_ARRAY];
    } else {
        [_groupDefaults setObject:@[] forKey:KEY_FOLLOWER_ARRAY];
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
@end
