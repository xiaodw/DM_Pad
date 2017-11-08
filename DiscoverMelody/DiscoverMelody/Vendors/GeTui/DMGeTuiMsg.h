//
//  DMGeTuiMsg.h
//  DiscoverMelody
//
//  Created by Ares on 2017/11/6.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMGeTuiMsgData : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger is_token;
@property (nonatomic, assign) NSInteger native;
@property (nonatomic, copy) NSString *lesson_id;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *title;
@end

@interface DMGeTuiMsg : NSObject
@property (nonatomic, strong) DMGeTuiMsgData *data;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *title;
@end
