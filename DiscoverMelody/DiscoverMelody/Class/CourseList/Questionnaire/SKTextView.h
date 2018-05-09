//
//  SKTextView.h
//  SKMobileProject
//
//  Created by  on 16/5/6.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKTextView : UITextView

@property (nonatomic,copy)NSString *placeHold;
@property (nonatomic,strong)UILabel *placeHoldLab;
@property (nonatomic,strong)UILabel *countNumLab;
@property (nonatomic,assign)NSInteger limitNum;

@end
