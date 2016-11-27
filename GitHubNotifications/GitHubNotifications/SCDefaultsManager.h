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

- (void)setUserName:(NSString *)name;
- (NSString *)getUserName;
- (void)setUserToken:(NSString *)token;
- (NSString *)getUserToken;
- (void)setStarArray:(NSArray *)data;
- (NSArray *)getStarArray;
- (void)setFollowersArray:(NSArray *)data;
- (NSArray *)getFollowersArray;

@end
