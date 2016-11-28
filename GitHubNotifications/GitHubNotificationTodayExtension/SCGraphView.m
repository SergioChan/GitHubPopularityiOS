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
    NSMutableArray *itemValueArray;
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

    for (NSInteger i = 0; i < numberOfColumns; i++) {
        SCItemView *item = [[SCItemView alloc] initWithItemWidth:self.width/numberOfColumns maximunHeight:self.height];
        
        CGFloat relHeight = 0.1f;
        if (i >= [itemValueArray count]) {
            relHeight = 0.1f;
        } else {
            relHeight = [[itemValueArray objectAtIndex:i] floatValue] + 0.1f;
        }
        
        item.index = i;
        item.left = nextX;
        item.relativeHeight = relHeight;
        item.bottom = self.height;
        
        [self addSubview:item];
        [self.itemArray addObject:item];
        
        nextX += self.width/numberOfColumns;
    }
}

- (void)refreshWithFollwers:(NSArray *)dayArray
{
    itemValueArray = [dayArray mutableCopy];
    [self layoutItems];
}
@end
