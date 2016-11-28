//
//  SCItemView.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCItemView.h"
#import "UIView+ViewFrameGeometry.h"

@interface SCItemView()

@property (nonatomic, strong) UIView *itemMainView;
@property (nonatomic, strong) UILabel *indexLabel;

@end

@implementation SCItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithItemWidth:(CGFloat)width maximunHeight:(CGFloat)maximunHeight
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, width, 0.0f)];
    if (self) {
        self.itemMainView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, self.height - 10.0f)];
        self.itemMainView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.itemMainView];
        
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.height - 10.0f, width, 10.0f)];
        _indexLabel.font = [UIFont systemFontOfSize:6.0f];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_indexLabel];
        
        _maximumHeight = maximunHeight;
        _itemWidth = width;
    }
    return self;
}

- (void)setRelativeHeight:(CGFloat)relativeHeight
{
    _relativeHeight = relativeHeight;

    CGFloat dstBottom = self.bottom;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.height = relativeHeight * _maximumHeight;
        self.itemMainView.height = self.height - 10.0f;
        
        self.bottom = dstBottom;
        self.backgroundColor = [UIColor colorWithWhite:(1.0f - relativeHeight) + 0.3f alpha:1.0f];
    } completion:^(BOOL finished) {
        self.indexLabel.top = self.itemMainView.bottom;
    }];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.itemMainView.backgroundColor = backgroundColor;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    _indexLabel.text = [NSString stringWithFormat:@"%ld",index];
}
@end
