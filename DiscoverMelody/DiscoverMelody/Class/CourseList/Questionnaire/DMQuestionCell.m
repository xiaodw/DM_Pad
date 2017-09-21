//
//  DMQuestionCell.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/20.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMQuestionCell.h"
#import "DMEStarView.h"
#import "DMRadioView.h"
#import "DMTextView.h"
@interface DMQuestionCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DMEStarView *starView;
@property (nonatomic, strong) DMRadioView *radioView;
@property (nonatomic, strong) DMTextView *textView;
@end

@implementation DMQuestionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xf6f6f6);
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DMScreenWidth-40, 50)];
//    self.titleLabel.textAlignment = NSTextAlignmentLeft;
//    self.titleLabel.font = DMFontPingFang_Light(15);
//    self.titleLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
//    [self addSubview:self.titleLabel];
    
    CGFloat H = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
    
    self.textView = [[DMTextView alloc] initWithFrame:CGRectMake(34, H, DMScreenWidth-68, 50)];
    self.radioView = [[DMRadioView alloc] initWithFrame:CGRectMake(34, H, DMScreenWidth-68, 50)];
    self.starView = [[DMEStarView alloc] initWithFrame:CGRectMake(34, H, 250, 50) finish:^(CGFloat currentScore) {
        NSLog(@"当前选择的分数 = %f",currentScore);
    }];
    self.textView.backgroundColor = DMColorWithRGBA(245, 245, 245, 1);
    self.radioView.backgroundColor = DMColorWithRGBA(245, 245, 245, 1);
    self.starView.backgroundColor = DMColorWithRGBA(255, 255, 255, 1);
    [self hiddenAllSubViews];
    [self addSubview:self.radioView];
    [self addSubview:self.textView];
    [self addSubview:self.starView];
}

- (void)hiddenAllSubViews {
    self.textView.hidden = YES;
    self.radioView.hidden = YES;
    self.starView.hidden = YES;
}

- (void)configObj:(DMQuestSingleData *)obj indexRow:(NSInteger)index {
    [self hiddenAllSubViews];
    if (!OBJ_IS_NIL(obj)) {
     
        switch (obj.type.intValue) {
            case 0://问答题
                self.textView.hidden = NO;
                break;
            case 1://判断／选择题
                if (index < obj.options.count) {
                    self.radioView.hidden = NO;
                    DMQuestOptions *op = [obj.options objectAtIndex:index];
                    [self.radioView updateButtonTitle:[@"  " stringByAppendingString:op.option_content]];
                }
                break;
            case 2://打分题
                self.starView.hidden = NO;
                break;
            default:
                break;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
