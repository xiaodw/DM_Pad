//
//  DMAlertMananger.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AlertIndexBlock)(NSInteger index);

@interface DMAlertMananger : NSObject

+ (DMAlertMananger *)shareManager;

- (DMAlertMananger *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitle:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION;

- (void)showWithViewController:(UIViewController *)viewController IndexBlock:(AlertIndexBlock)indexBlock;

@end
