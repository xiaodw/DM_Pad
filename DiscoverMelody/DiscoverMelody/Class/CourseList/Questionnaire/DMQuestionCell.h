//
//  DMQuestionCell.h
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BlockClickButton)();
typedef void (^BlockClickTextField)(BOOL displayKeyBoard);
typedef void (^BLockClickTextViewDidChange)(NSString *content);
@interface DMQuestionCell : UITableViewCell
@property (nonatomic, strong) BlockClickButton clickButtonBlock;
@property (nonatomic, strong) BlockClickTextField clickTextFieldBlock;

@property (nonatomic, strong) BLockClickTextViewDidChange clickTextViewDidChangeBlock;

- (void)configObj:(DMQuestSingleData *)obj indexRow:(NSInteger)index indexSection:(NSInteger)section;
@end
