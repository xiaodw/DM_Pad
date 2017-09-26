//
//  DMAlertMananger.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMAlertMananger.h"

@interface DMAlertMananger ()

@property(nonatomic, strong)NSMutableArray *actionTitles;
@property(nonatomic,copy)AlertIndexBlock indexBlock;

@end

@implementation DMAlertMananger


+ (DMAlertMananger *)shareManager
{
    static DMAlertMananger *managerInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        managerInstance = [[self alloc] init];
    });
    return managerInstance;
}

- (DMAlertMananger *)creatAlertWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle cancelTitle:(NSString *)canceTitle otherTitle:(NSString *)otherTitle,...NS_REQUIRES_NIL_TERMINATION {
    
    self.alertCol = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    NSString *actionTitle = nil;
    va_list args;//用于指向第一个参数
    self.actionTitles = [NSMutableArray array];
    [self.actionTitles addObject:canceTitle];
    if (otherTitle) {
        [self.actionTitles addObject:otherTitle];
        va_start(args, otherTitle);//对args进行初始化，让它指向可变参数表里面的第一个参数
        while ((actionTitle = va_arg(args, NSString*))) {
            
            [self.actionTitles addObject:actionTitle];
            
        }
        va_end(args);
    }
    
    if (!STR_IS_NIL(title))  {
        NSMutableAttributedString *titleAlert = [[NSMutableAttributedString alloc] initWithString:title];
        [titleAlert addAttribute:NSFontAttributeName value:DMFontPingFang_Regular(18) range:NSMakeRange(0, [[titleAlert string] length])];
        [self.alertCol setValue:titleAlert forKey:@"attributedTitle"];
        
        NSMutableAttributedString *msgAlert = [[NSMutableAttributedString alloc] initWithString:message];
        [msgAlert addAttribute:NSFontAttributeName value:DMFontPingFang_Light(13) range:NSMakeRange(0, [[msgAlert string] length])];
        [self.alertCol setValue:msgAlert forKey:@"attributedTitle"];
    } else {
        NSMutableAttributedString *msgAlert = [[NSMutableAttributedString alloc] initWithString:message];
        [msgAlert addAttribute:NSFontAttributeName value:DMFontPingFang_Regular(18) range:NSMakeRange(0, [[msgAlert string] length])];
        [self.alertCol setValue:msgAlert forKey:@"attributedTitle"];
    }
    

    
    [self buildCancelAction];
    [self buildOtherAction];
    
    return [DMAlertMananger shareManager];
}

- (void)buildCancelAction{
    
    NSString *cancelTitle = self.actionTitles[0];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.indexBlock(0);
        
    }];
    [cancelAction setValue:DMColorBaseMeiRed forKey:@"_titleTextColor"];
    [self.alertCol addAction:cancelAction];
    
}

- (void)buildOtherAction{
    
    for (int i = 0 ; i < self.actionTitles.count; i++) {
        if (i == 0)continue;
        NSString *actionTitle = self.actionTitles[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (self.indexBlock) {
                self.indexBlock(i);
            }
        }];
        [action setValue:DMColorBaseMeiRed forKey:@"_titleTextColor"];
        [self.alertCol addAction:action];
    }
}

- (void)showWithViewController:(UIViewController *)viewController IndexBlock:(AlertIndexBlock)indexBlock {
    
    if (indexBlock) {
        self.indexBlock = indexBlock;
    }
    [viewController presentViewController:self.alertCol animated:YES completion:^{ }];
}



@end
