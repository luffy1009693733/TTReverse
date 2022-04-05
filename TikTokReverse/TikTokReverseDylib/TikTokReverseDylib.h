//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  TikTokReverseDylib.h
//  TikTokReverseDylib
//
//  Created by iceman on 2022/4/3.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HookArea @"HookArea"
#define HookDownLoad @"HookDownLoad"
#define HookWaterMark @"HookWaterMark"
#define UserDefaults [NSUserDefaults standardUserDefaults]

#define INSERT_SUCCESS_WELCOME "               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍\n"

@interface CustomViewController

@property (nonatomic, copy) NSString* newProperty;

+ (void)classMethod;

- (NSString*)getMyName;

- (void)newMethod:(NSString*) output;

@end
