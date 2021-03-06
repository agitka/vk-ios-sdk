//
//  VKStartScreen.m
//
//  Copyright (c) 2013 VK.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "VKStartScreen.h"

@implementation VKStartScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[VKSdk initializeWithDelegate:self andAppId:@"3974615" andCustomToken:[VKAccessToken tokenFromFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"my_application_access_token"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction) authorize:(id)sender
{
    [VKSdk authorize:@[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS] revokeAccess:YES];
}
-(IBAction) authorizeForceOAuth:(id)sender
{
    [VKSdk authorize:@[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS] revokeAccess:YES forceOAuth:YES];
}

-(void) vkSdkNeedCaptchaEnter:(VKError*) captchaError
{
    VKCaptchaViewController * vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

-(void) vkSdkTokenHasExpired:(VKAccessToken*) expiredToken
{
    [self authorize:nil];
}

-(void) vkSdkDidReceiveNewToken:(VKAccessToken*) newToken
{
    [newToken saveTokenToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"my_application_access_token"]];
    [self performSegueWithIdentifier:@"START_WORK" sender:self];
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)vkSdkDidAcceptUserToken:(VKAccessToken *)token
{
    [self performSegueWithIdentifier:@"START_WORK" sender:self];
}
-(void)vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
}
@end
