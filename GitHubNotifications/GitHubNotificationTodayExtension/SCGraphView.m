//
//  SCGraphView.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCGraphView.h"
#import "UIView+ViewFrameGeometry.h"
#import "SCItemView.h"

@interface SCGraphView()
{
    NSInteger numberOfColumns;
}
@property (strong, nonatomic) NSMutableArray *itemArray;

@end

@implementation SCGraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame columns:(NSInteger)columns
{
    self = [super initWithFrame:frame];
    if (self) {
        numberOfColumns = columns;
        _itemArray = [NSMutableArray array];
        
        [self layoutItems];
    }
    return self;
}

- (void)layoutItems
{
    for (SCItemView *item in _itemArray) {
        [item removeFromSuperview];
    }
    [_itemArray removeAllObjects];
    
    CGFloat nextX = 0.0f;
    CGFloat nextHeight = 0.1f;
    for (NSInteger i = 0; i < numberOfColumns; i++) {
        SCItemView *item = [[SCItemView alloc] initWithItemWidth:self.width/numberOfColumns maximunHeight:self.height];
        item.index = i;
        item.left = nextX;
        item.relativeHeight = nextHeight;
//        item.height = nextHeight * self.height;
        item.bottom = self.height;
//        item.backgroundColor = [UIColor colorWithWhite:(1.0f - nextHeight) alpha:1.0f];
        
        [self addSubview:item];
        [self.itemArray addObject:item];
        
        nextX += self.width/numberOfColumns;
        nextHeight += 0.9f / numberOfColumns;
    }
}
@end
