//
//  VKUploadWallPhotoRequest.m
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

#import "VKUploadWallPhotoRequest.h"
#import "VKApi.h"
@implementation VKUploadWallPhotoRequest
- (instancetype)initWithImage:(UIImage *)image parameters:(VKImageParameters *)parameters userId:(long long)userId groupId:(int)groupId {
	self = [super init];
	self->_image            = image;
	self->_imageParameters  = parameters;
	self->_userId           = userId;
	self->_groupId          = groupId;
	return self;
}

- (VKRequest *)getServerRequest {
	if (_groupId != 0)
		return [[VKApi photos] getWallUploadServer:_groupId];
	else
		return [[VKApi photos] getWallUploadServer];
}

- (VKRequest *)getSaveRequest:(VKResponse *)response {
	VKRequest *saveRequest = [[VKApi photos] saveWallPhoto:response.json];
	if (_userId)
		[saveRequest addExtraParameters:@{ VK_API_USER_ID : @(_userId) }];
	if (_groupId)
		[saveRequest addExtraParameters:@{ VK_API_GROUP_ID : @(_groupId) }];
	return saveRequest;
}

@end
