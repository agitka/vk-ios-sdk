//
//  VKCaptchaView.m
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

#import "VKCaptchaView.h"
#import "VKUtil.h"
#import "VKApiConst.h"
#import "VKHTTPClient.h"
#import "VKRequest.h"

#ifndef DOXYGEN_SHOULD_SKIP_THIS
@interface VKCaptchaView () <UITextFieldDelegate> {
	VKError *_error;
	UIImageView *_captchaImage;
	UILabel *_infoLabel;
	UITextField *_captchaTextField;
	UIButton *_doneButton;
	UIActivityIndicatorView *_imageLoadingActivity;
}
@end
#endif
static CGFloat kCaptchaImageWidth  = 240;
static CGFloat kCaptchaImageHeight = 79;
@implementation VKCaptchaView
- (id)initWithFrame:(CGRect)frame andError:(VKError *)captchaError {
	if ((self = [super initWithFrame:frame])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self setBackgroundColor:VK_COLOR];
        
		_error = captchaError;
        
		_imageLoadingActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, 20, 30, 30)];
		_imageLoadingActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		_imageLoadingActivity.hidesWhenStopped = YES;
		[self addSubview:_imageLoadingActivity];
		[_imageLoadingActivity startAnimating];
        
		_captchaImage = [[UIImageView alloc] init];
		_captchaImage.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_captchaImage];
        
		_captchaTextField = [[UITextField alloc] init];
		_captchaTextField.borderStyle = UITextBorderStyleRoundedRect;
		_captchaTextField.textAlignment = NSTextAlignmentCenter;
		_captchaTextField.delegate = self;
		_captchaTextField.returnKeyType = UIReturnKeyDone;
		_captchaTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		_captchaTextField.placeholder = NSLocalizedString(@"Enter captcha text", @"");
		[self addSubview:_captchaTextField];
		VKHTTPOperation *operation = [[VKHTTPOperation alloc] initWithURLRequest:[[VKHTTPClient getClient] requestWithMethod:@"GET" path:_error.captchaImg parameters:nil secure:NO]];
		[operation setCompletionBlockWithSuccess: ^(VKHTTPOperation *operation, id responseObject) {
		    [_captchaImage setImage:[UIImage imageWithData:operation.responseData]];
		} failure: ^(VKHTTPOperation *operation, NSError *error) {
		}];
		[[VKHTTPClient getClient] enqueueHTTPRequestOperation:operation];
		//        [_captchaImage setImageWithURL:[NSURL URLWithString:_error.captchaImg]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
		[self deviceDidRotate:nil];
	}
	return self;
}

- (void)deviceDidRotate:(NSNotification *)notification {
	[UIView animateWithDuration:notification ? 0.3:0 animations: ^{
	    _captchaImage.frame = CGRectMake((self.bounds.size.width - kCaptchaImageWidth) / 2, 20, kCaptchaImageWidth, kCaptchaImageHeight);
	    _captchaTextField.frame = CGRectMake(_captchaImage.frame.origin.x, _captchaImage.frame.origin.y + kCaptchaImageHeight + 10, kCaptchaImageWidth, 31);
	}];
}

- (void)doneButtonPressed:(UIButton *)sender {
	[_error answerCaptcha:_captchaTextField.text];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] postNotificationName:VKCaptchaAnsweredEvent object:nil];
}

- (void)didMoveToSuperview {
	[_captchaTextField becomeFirstResponder];
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == _captchaTextField) {
		[self doneButtonPressed:_doneButton];
		[textField endEditing:YES];
		return NO;
	}
	return YES;
}

@end
