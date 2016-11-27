//
//  SCGraphView.h
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGraphView : UIView

- (id)initWithFrame:(CGRect)frame columns:(NSInteger)columns;
- (void)refreshWithFollwers:(NSArray *)dayArray;

@end
