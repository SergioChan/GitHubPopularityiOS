//
//  SCHelpView.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 29/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCHelpView.h"

@interface SCHelpView ()
{
    BOOL isShowing;
    UITapGestureRecognizer *tap;
}
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SCHelpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isShowing = NO;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"HelpImage"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
        self.alpha = 0.f;
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tap.enabled = NO;
        
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    [self hide];
}

- (void)show
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        isShowing = YES;
        tap.enabled = YES;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        isShowing = NO;
        tap.enabled = NO;
    }];
}
@end
