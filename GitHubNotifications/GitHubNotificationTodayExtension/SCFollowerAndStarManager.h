//
//  SCFollowerAndStarManager.h
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SCSharedDataGroupKey @"group.sergio.chan.GitHubNotification"

typedef void (^finishUpdatingWithObjectBlock)(id object);

@protocol SCFollowerAndStarDelegate <NSObject>

@optional

- (void)didFinishUpdatingRepo:(NSString *)repoName;
- (void)didFinishUpdatingStarData:(NSArray *)starData;

@end

@interface SCFollowerAndStarManager : NSObject

@property(nonatomic, weak) id<SCFollowerAndStarDelegate> delegate;
@property(nonatomic, copy) finishUpdatingWithObjectBlock completionBlock;

+ (id)sharedManager;
- (void)refreshData;

@end
