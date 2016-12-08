//
//  SCFollowerAndStarManager.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCFollowerAndStarManager.h"
#import "SCNetworkManager.h"
#import "SCDefaultsManager.h"
#import "DateTools.h"
#import <UserNotifications/UserNotifications.h>

@interface SCFollowerAndStarManager()
{
    BOOL shouldStopGettingRepos;
    BOOL shouldStopGettingStars;
    NSInteger finshedRepoCount;
    NSInteger starCount;
}
@property (nonatomic, strong) NSMutableArray *starsArray;
@property (nonatomic, strong) NSMutableArray *reposArray;

@end

@implementation SCFollowerAndStarManager

+ (id)sharedManager {
    static SCFollowerAndStarManager *sharedMyManager = nil;
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
        _starsArray = [NSMutableArray array];
        _reposArray = [NSMutableArray array];
        
        shouldStopGettingRepos = NO;
        shouldStopGettingStars = NO;
    }
    return self;
}

- (void)refreshData
{
    shouldStopGettingRepos = NO;
    shouldStopGettingStars = NO;
    finshedRepoCount = 0;
    starCount = 0;
    
    NSString *userName = [[SCDefaultsManager sharedManager] getUserName];
    if ([userName isEqualToString:@""]) {
        return;
    }
    
    _starsArray = [NSMutableArray array];
    _reposArray = [NSMutableArray array];
    
    [self getCurrentFollowerData];
    
    if ([[SCDefaultsManager sharedManager] isRepoCached]) {
        _starsArray = [[[SCDefaultsManager sharedManager] getRenderStarArray] mutableCopy];
        [self updateNewStarsFromPage:1];
    } else {
        [self getCurrentReposDatawithPage:1];
    }
}

- (void)getCurrentFollowerData
{
    [[SCNetworkManager sharedManager] getNumberOfFollowersForUser:[[SCDefaultsManager sharedManager] getUserName] success:^(id object, NSURLResponse *response) {
        NSDate *now = [NSDate date];
        NSInteger numberOfFollowers = [object integerValue];
        
        NSInteger cachedNumberOfFollowers = [[SCDefaultsManager sharedManager] getFollowersNumber];
        if (cachedNumberOfFollowers == -1) {
            NSString *key = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)now.year,(long)now.month,(long)now.day];
            [[SCDefaultsManager sharedManager] addDeltaToRenderFollowersDict:0 toKey:key];
        } else {
            NSInteger delta = numberOfFollowers - cachedNumberOfFollowers;
            if (delta > 0) {
                [self localNotificationMessage:delta > 1 ? [NSString stringWithFormat:@"You've just got %ld new followers!",(long)delta] : [NSString stringWithFormat:@"You've just got %ld new follower!",(long)delta]];
            }
            NSString *key = [NSString stringWithFormat:@"%ld-%ld-%ld",now.year,now.month,now.day];
            [[SCDefaultsManager sharedManager] addDeltaToRenderFollowersDict:delta toKey:key];
        }
        [[SCDefaultsManager sharedManager] setFollowersNumber:numberOfFollowers];
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailedUpdatingStarData)]) {
            [self.delegate didFailedUpdatingStarData];
        }
    }];
}

- (void)updateNewStarsFromPage:(NSInteger)page
{
    [[SCNetworkManager sharedManager] getRepoForUser:[[SCDefaultsManager sharedManager] getUserName] page:page success:^(id object, NSURLResponse *reponse) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"updateNewStarsFromPage page: %ld get %ld results , example: %@",page,[object count],[object objectAtIndex:0]);
            
            for (NSDictionary *item in object) {
                starCount = starCount + [[item objectForKey:@"stargazers_count"] integerValue];
            }
            
            if ([object count] < 100) {
                NSInteger cachedNumberOfStars = [[SCDefaultsManager sharedManager] getCachedStarNumber];
                NSInteger delta = starCount - cachedNumberOfStars;
                if (delta > 0) {
                    [self localNotificationMessage:delta > 1 ? [NSString stringWithFormat:@"You've just got %ld new stars!",delta] : [NSString stringWithFormat:@"You've just got %ld new star!",delta]];
                    for (NSInteger i = 0; i < delta; i ++) {
                        // Today adding how many stars just add to cached starsArray
                        [_starsArray addObject:@{@"date":[NSDate date],@"userName":@"Someone",@"repo":@""}];
                    }
                }
                if ([self.delegate respondsToSelector:@selector(didFinishUpdatingStarData:)]) {
                    [self.delegate didFinishUpdatingStarData:_starsArray];
                }
                if (self.completionBlock) {
                    self.completionBlock(_starsArray);
                }
                [[SCDefaultsManager sharedManager] setRepoCached:YES];
                [[SCDefaultsManager sharedManager] setStarNumber:starCount];
            } else {
                [self updateNewStarsFromPage:page + 1];
            }
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailedUpdatingStarData)]) {
            [self.delegate didFailedUpdatingStarData];
        }
    }];
}

- (void)localNotificationMessage:(NSString *)msg
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Popularity Notification";
    content.subtitle = @"";
    content.body = msg;
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5.0f repeats:NO];

    NSString *requestIdentifier = @"sergio.chan.GitHubNotifications.notification";
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"local notified succeeded");
        }
    }];
}

- (void)isRepoCachedStarData:(NSString *)repoName {
    return [[SCDefaultsManager sharedManager] isRepoCachedStarData:repoName];
}

- (void)getCurrentReposDatawithPage:(NSInteger)page
{
    [[SCNetworkManager sharedManager] getRepoForUser:[[SCDefaultsManager sharedManager] getUserName] page:page success:^(id object, NSURLResponse *reponse) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"getRepoForUser page: %ld get %ld results , example: %@",page,[object count],[object objectAtIndex:0]);
            [_reposArray addObjectsFromArray:object];
            
            for (NSDictionary *item in object) {
                starCount = starCount + [[item objectForKey:@"stargazers_count"] integerValue];
            }
            
            if ([object count] < 100) {
                [self processCurrentRepoArray];
                [[SCDefaultsManager sharedManager] setStarNumber:starCount];
            } else {
                [self getCurrentReposDatawithPage:page + 1];
            }
        }
    } failure:^(NSError *error) {
        if ([self.delegate respondsToSelector:@selector(didFailedUpdatingStarData)]) {
            [self.delegate didFailedUpdatingStarData];
        }
    }];
}

- (void)processCurrentRepoArray
{
    dispatch_queue_t queue = dispatch_queue_create("sergio.chan.requestQueue", DISPATCH_QUEUE_SERIAL);

    for (NSDictionary *item in _reposArray) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:0.2];
            NSString *repoName = [item objectForKey:@"name"];
            if ([[item objectForKey:@"stargazers_count"] integerValue] > 0) {
                [self getCurrentStarsDatawithPage:1 repoName:repoName];
            } else {
                finshedRepoCount ++;
            }
        });
    }
}

- (void)getCurrentStarsDatawithPage:(NSInteger)page repoName:(NSString *)repoName
{
    [[SCNetworkManager sharedManager] getStarForUser:[[SCDefaultsManager sharedManager] getUserName] repo:repoName page:page success:^(id object, NSURLResponse *reponse) {
        if ([object isKindOfClass:[NSArray class]]) {
            [_starsArray addObjectsFromArray:object];
            
            if ([object count] < 100) {
                NSLog(@"getStarForUser repo:%@ page: %ld get %ld results",repoName, page,[object count]);
                finshedRepoCount ++;
                
                if ([self.delegate respondsToSelector:@selector(didFinishUpdatingRepo:)]) {
                    [self.delegate didFinishUpdatingRepo:repoName];
                }
                
                if (finshedRepoCount == [_reposArray count]) {
                    if ([self.delegate respondsToSelector:@selector(didFinishUpdatingStarData:)]) {
                        [self.delegate didFinishUpdatingStarData:_starsArray];
                    }
                    if (self.completionBlock) {
                        self.completionBlock(_starsArray);
                    }
                    [[SCDefaultsManager sharedManager] setRepoCached:YES];
                }
                
            } else {
                [self getCurrentStarsDatawithPage:page + 1 repoName:repoName];
            }
        }
    } failure:^(NSError *error) {
        finshedRepoCount ++;
//        if ([self.delegate respondsToSelector:@selector(didFailedUpdatingStarData)]) {
//            [self.delegate didFailedUpdatingStarData];
//        }
    }];
}


@end
