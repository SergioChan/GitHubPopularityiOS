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

@interface SCFollowerAndStarManager()
{
    BOOL shouldStopGettingRepos;
    BOOL shouldStopGettingStars;
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
        NSLog(@"getNumberOfFollowersForUser :%@",object);
    } failure:^(NSError *error) {
        
    }];
}

- (void)star_hasCached {
    
}

- (void)getCurrentReposDatawithPage:(NSInteger)page
{
    if (shouldStopGettingRepos) {
        return;
    }
    
    [[SCNetworkManager sharedManager] getRepoForUser:[[SCDefaultsManager sharedManager] getUserName] page:page success:^(id object, NSURLResponse *reponse) {
        if ([object isKindOfClass:[NSArray class]]) {
            NSLog(@"getRepoForUser page: %ld get %ld results , example: %@",page,[object count],[object objectAtIndex:0]);
            [_reposArray addObjectsFromArray:object];
            if ([object count] < 100) {
                shouldStopGettingRepos = YES;
            } else {
                shouldStopGettingRepos = NO;
                [self getCurrentReposDatawithPage:page + 1];
            }
        }
    } failure:^(NSError *error) {
        shouldStopGettingRepos = YES;
    }];
}
@end
