//
//  SCMainViewController.m
//  GitHubNotifications
//
//  Created by 叔 陈 on 25/11/2016.
//  Copyright © 2016 叔 陈. All rights reserved.
//

#import "SCMainViewController.h"
#import "UIView+ViewFrameGeometry.h"

@interface SCMainViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UIButton *updateInfoButton;

@end

@implementation SCMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_updateInfoButton setTitle:@"Update Info" forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userNameField.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    
    NSString *name = [[[NSUserDefaults alloc] initWithSuiteName:@"group.sergio.chan.GitHubNotification"] objectForKey:@"GitHubNotificationsName"];
    if (name)
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
    _userNameField.text = @"";
}

- (void)tap:(id)sender
{
    [_userNameField resignFirstResponder];
}

- (IBAction)updateInfoButtonPressed:(id)sender {
    NSString *trimmedName = [_userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.sergio.chan.GitHubNotification"] setObject:trimmedName forKey:@"GitHubNotificationsName"];
    
    UIButton *button = (UIButton *)sender;
    [[[NSUserDefaults alloc] initWithSuiteName:@"group.sergio.chan.GitHubNotification"] removeObjectForKey:@"GitHubNotificationsArray"];
    
    [button setTitle:@"Widget will update soon" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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