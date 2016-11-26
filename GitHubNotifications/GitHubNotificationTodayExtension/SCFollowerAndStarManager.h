//
//  SCFollowerAndStarManager.h
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SCSharedDataGroupKey @"group.sergio.chan.GitHubNotification"

@interface SCFollowerAndStarManager : NSObject

+ (id)sharedManager;
- (void)refreshData;

@end
