//
//  SCItemView.h
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCItemView : UIView

// relativeHeight is float value between 0.0f ~ 1.0f
@property (nonatomic) CGFloat relativeHeight;
@property (nonatomic) CGFloat maximumHeight;
@property (nonatomic) CGFloat itemWidth;

// index in itemArray
@property (nonatomic) NSInteger index;

- (id)initWithItemWidth:(CGFloat)width maximunHeight:(CGFloat)maximunHeight;

@end
