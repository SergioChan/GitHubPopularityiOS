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

@interface SCFollowerAndStarManager()
{
    BOOL shouldStopGettingRepos;
    BOOL shouldStopGettingStars;
    NSInteger finshedRepoCount;
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
    
    NSString *userName = [[SCDefaultsManager sharedManager] getUserName];
    if ([userName isEqualToString:@""]) {
        return;
    }
    
    _starsArray = [NSMutableArray array];
    _reposArray = [NSMutableArray array];
    
    [self getCurrentFollowerData];
    [self getCurrentReposDatawithPage:1];
}

- (void)getCurrentFollowerData
{
    [[SCNetworkManager sharedManager] getNumberOfFollowersForUser:[[SCDefaultsManager sharedManager] getUserName] success:^(id object, NSURLResponse *response) {
        NSDate *now = [NSDate date];
        NSInteger numberOfFollowers = [object integerValue];
        
        NSInteger cachedNumberOfFollowers = [[SCDefaultsManager sharedManager] getFollowersNumber];
        if (cachedNumberOfFollowers == -1) {
            NSString *key = [NSString stringWithFormat:@"%ld-%ld-%ld",now.year,now.month,now.day];
            [[SCDefaultsManager sharedManager] addDeltaToRenderFollowersDict:0 toKey:key];
        } else {
            NSInteger delta = numberOfFollowers - cachedNumberOfFollowers;
            NSString *key = [NSString stringWithFormat:@"%ld-%ld-%ld",now.year,now.month,now.day];
            [[SCDefaultsManager sharedManager] addDeltaToRenderFollowersDict:delta toKey:key];
        }
        [[SCDefaultsManager sharedManager] setFollowersNumber:numberOfFollowers];
    } failure:^(NSError *error) {
        
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
            if ([object count] < 100) {
                [self processCurrentRepoArray];
            } else {
                [self getCurrentReposDatawithPage:page + 1];
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)processCurrentRepoArray
{
    for (NSDictionary *item in _reposArray) {
        NSString *repoName = [item objectForKey:@"name"];
//        if (![[SCDefaultsManager sharedManager] isRepoCached:repoName]) {
            [self getCurrentStarsDatawithPage:1 repoName:repoName];
//        }
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
                
                if (finshedRepoCount == [_reposArray count]) {
                    if ([self.delegate respondsToSelector:@selector(didFinishUpdatingStarData:)]) {
                        [self.delegate didFinishUpdatingStarData:_starsArray];
                    }
                    if (self.completionBlock) {
                        self.completionBlock(_starsArray);
                    }
                }
                
                if ([self.delegate respondsToSelector:@selector(didFinishUpdatingRepo:)]) {
                    [self.delegate didFinishUpdatingRepo:repoName];
                }
                
                [[SCDefaultsManager sharedManager] setRepoCached:YES repoName:repoName];
            } else {
                [self getCurrentStarsDatawithPage:page + 1 repoName:repoName];
            }
        }
    } failure:^(NSError *error) {
        [[SCDefaultsManager sharedManager] setRepoCached:NO repoName:repoName];
    }];
}

@end
