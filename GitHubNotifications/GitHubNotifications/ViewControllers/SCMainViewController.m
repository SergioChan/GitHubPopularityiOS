//
//  SCMainViewController.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 25/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCMainViewController.h"
#import "UIView+ViewFrameGeometry.h"
#import "GithubAuthController.h"
#import "SCDefaultsManager.h"
#import "SCFollowerAndStarManager.h"
#import "SCHelpView.h"

@interface SCMainViewController () <UITextFieldDelegate,GitAuthDelegate,SCFollowerAndStarDelegate>
{
    BOOL isRefreshing;
    SCHelpView *helpView;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIButton *updateInfoButton;

@end

@implementation SCMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isRefreshing = NO;
    
    // Do any additional setup after loading the view.
    _userNameField.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    helpView = [[SCHelpView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight)];
    [self.view addSubview:helpView];
    
    NSString *name = [[SCDefaultsManager sharedManager] getUserName];
    if (![name isEqualToString:@""])
    {
        _userNameField.text = name;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect endRect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat endHeight = endRect.size.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        _userNameField.bottom = ScreenHeight - endHeight;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notif
{
    [UIView animateWithDuration:0.2f animations:^{
        _userNameField.bottom = ScreenHeight - 145.0f;
    }];
    if ([_userNameField.text isEqualToString:@""]) {
        _userNameField.text = @"Your User Name";
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_userNameField.text isEqualToString:@"Your User Name"]) {
        _userNameField.text = @"";
    }
}

- (IBAction)shouldReturnKey:(id)sender {
    [_userNameField resignFirstResponder];
}

- (void)tap:(id)sender
{
    [_userNameField resignFirstResponder];
}

- (IBAction)updateInfoButtonPressed:(id)sender {
    if (isRefreshing) {
        return;
    }
    
    NSString *trimmedName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([trimmedName isEqualToString:@"Your User Name"] || [trimmedName isEqualToString:@""]) {
        return;
    }
    
    [[SCDefaultsManager sharedManager] clearCache];
    
    [self checkGitAuth];
}

-(void) checkGitAuth
{
    GithubAuthController *githubAuthController = [[GithubAuthController alloc] init];
    githubAuthController.authDelegate = self;
    
    githubAuthController.modalPresentationStyle = UIModalPresentationFormSheet;
    githubAuthController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:githubAuthController animated:YES completion:^{ } ];
    
    __weak __block GithubAuthController *weakAuthController = githubAuthController;
    
    githubAuthController.completionBlock = ^(void) {
        [weakAuthController dismissViewControllerAnimated:YES completion:nil];
        [_updateInfoButton setTitle:@"Authenticating ... " forState:UIControlStateNormal];
    };
    githubAuthController.dismissBlock = ^(void) {
        [_updateInfoButton setTitle:@"Refresh Authentication and Data " forState:UIControlStateNormal];
    };
}

- (void)didAuth:(NSString *)token
{
    if(!token) return;

    NSLog(@"didAuth :%@",token);
    
    NSString *trimmedName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[SCDefaultsManager sharedManager] setUserName:trimmedName];
    [[SCDefaultsManager sharedManager] setUserToken:token];

    dispatch_async(dispatch_get_main_queue(), ^{
        [_updateInfoButton setTitle:@"Syncronizing data ... \nPlease wait ..." forState:UIControlStateNormal];
    });

    [[SCFollowerAndStarManager sharedManager] refreshData];
    isRefreshing = YES;
    [[SCFollowerAndStarManager sharedManager] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - FollowerAndStarDelegate

- (void)didFinishUpdatingRepo:(NSString *)repoName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_updateInfoButton setTitle:[NSString stringWithFormat:@"Syncronizing data ... \n- %@ - Finished",repoName] forState:UIControlStateNormal];
    });
}

- (void)didFinishUpdatingStarData:(NSArray *)starData
{
    NSLog(@"didFinishUpdatingStarData %ld",starData.count);
    [[SCDefaultsManager sharedManager] setRenderStarArray:starData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_updateInfoButton setTitle:@"Syncronizing finished" forState:UIControlStateNormal];
    });
    isRefreshing = NO;
}

- (void)didFailedUpdatingStarData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_updateInfoButton setTitle:@"Syncronizing failed. Try agian? " forState:UIControlStateNormal];
    });
    isRefreshing = NO;
}

- (IBAction)infoButtonClicked:(id)sender {
    [helpView show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
