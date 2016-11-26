//
//  SCFollowerAndStarManager.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCFollowerAndStarManager.h"
#import "SCNetworkManager.h"

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

- (void)refreshData
{
    shouldStopGettingRepos = NO;
    NSString *userName = [[[NSUserDefaults alloc] initWithSuiteName:SCSharedDataGroupKey]  objectForKey:@"GitHubNotificationsName"];
    if (userName == nil) {
        return;
    }
    [self getCurrentReposData:userName withPage:1];
}

- (void)getCurrentFollowerData
{
    
}

- (void)star_hasCached {
    
}

- (void)getCurrentReposData:(NSString *)userName withPage:(NSInteger)page
{
    [[SCNetworkManager sharedManager] getRepoForUser:userName page:page success:^(id object, NSURLResponse *reponse) {
        if ([object count] < 100) {
            
        }
    } failure:^(NSError *error) {
    }];
}
@end
