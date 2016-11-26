//
//  TodayViewController.m
//  GitHubNotificationTodayExtension
//
//  Created by 叔 陈 on 26/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "SCGraphView.h"
#import "UIView+ViewFrameGeometry.h"
#import "SCFollowerAndStarManager.h"

@interface TodayViewController () <NCWidgetProviding>
{
    BOOL accountHasSet;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    accountHasSet = NO;
    
    SCGraphView *fuck = [[SCGraphView alloc] initWithFrame:CGRectMake(5.0f, 10.0f, self.view.width - 30.0f, 100.0f) columns:24];
    [self.view addSubview:fuck];
    
    UIButton *tapToSetButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, 100.0f)];
    tapToSetButton.backgroundColor = [UIColor clearColor];
    tapToSetButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    tapToSetButton.titleLabel.numberOfLines = 2;
    [tapToSetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    tapToSetButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [tapToSetButton setTitle:@"Tap to initialize your \n Github Account" forState:UIControlStateNormal];
    [tapToSetButton addTarget:self action:@selector(goSettingsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    NSString *userName = [[[NSUserDefaults alloc] initWithSuiteName:SCSharedDataGroupKey]  objectForKey:@"GitHubNotificationsName"];
    if (userName == nil) {
        fuck.alpha = 0.0f;
        [self.view addSubview:tapToSetButton];
    } else {
        accountHasSet = YES;
    }
    
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

    // Do any additional setup after loading the view from its nib.
}

- (void)goSettingsButtonPressed:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"sergio.chan.GitHubNotifications://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

#pragma mark - NCWidgetProviding
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeCompact)
    {
        self.preferredContentSize = maxSize;
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
    else {
        self.preferredContentSize = CGSizeMake(0, 200.0);
        [UIView animateWithDuration:0.2
                         animations:^{
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
    }
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

@end
