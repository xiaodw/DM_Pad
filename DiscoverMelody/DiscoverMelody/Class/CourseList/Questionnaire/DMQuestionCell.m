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
@interface DMQuestionCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DMEStarView *starView;
@property (nonatomic, strong) DMRadioView *radioView;
@property (nonatomic, strong) DMTextView *textView;
@property (nonatomic, strong) DMQuestSingleData *obje;
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

-(void)clickButtonBlock:(BlockClickButton)blockClickButton {
    self.clickButtonBlock = blockClickButton;
}

-(void)clickTextFieldBlock:(BlockClickTextField)blockClickTextField {
    self.clickTextFieldBlock = blockClickTextField;
}

- (void)loadUI {
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DMScreenWidth-40, 50)];
//    self.titleLabel.textAlignment = NSTextAlignmentLeft;
//    self.titleLabel.font = DMFontPingFang_Light(15);
//    self.titleLabel.textColor = DMColorWithRGBA(51, 51, 51, 1);
//    [self addSubview:self.titleLabel];
    
    WS(weakSelf);
    
    CGFloat H = self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y;
    
    self.textView = [[DMTextView alloc] initWithFrame:CGRectMake(34, H, DMScreenWidth-68, 50)];
    self.textView.textField.delegate = self;
    self.radioView = [[DMRadioView alloc] initWithFrame:CGRectMake(34, H, DMScreenWidth-68, 45)];
    [self.radioView.selButton addTarget:self action:@selector(clickSelButton:) forControlEvents:UIControlEventTouchUpInside];
    self.starView = [[DMEStarView alloc] initWithFrame:CGRectMake(34, H, 250, 50) finish:^(CGFloat currentScore) {
        NSLog(@"当前选择的分数 = %f",currentScore);
        weakSelf.obje.answer_content = [NSString stringWithFormat:@"%d", (int)currentScore];
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

- (void)configObj:(DMQuestSingleData *)obj indexRow:(NSInteger)index indexSection:(NSInteger)section {
    [self hiddenAllSubViews];
    if (!OBJ_IS_NIL(obj)) {
        self.obje = obj;
        switch (obj.type.intValue) {
            case 0://问答题
                self.textView.hidden = NO;
                
                self.textView.textField.text = STR_IS_NIL(obj.answer_content) ? @"": obj.answer_content;
                break;
            case 1://判断／选择题
                if (index < obj.options.count) {
                    self.radioView.hidden = NO;
                    DMQuestOptions *op = [obj.options objectAtIndex:index];
                    [self.radioView updateButtonTitle:[@"  " stringByAppendingString:STR_IS_NIL(op.option_content)?@"": op.option_content]];
                    self.radioView.selButton.tag = (1+index)+section*100;
                    if (obj.answer_content.intValue == op.option_id.intValue) {
                        self.radioView.selButton.selected = YES;
                        self.obje.answer_content = op.option_id;
                    } else {
                        self.radioView.selButton.selected = NO;
                    }
                }
                break;
            case 2://打分题
                self.starView.hidden = NO;
                self.starView.currentScore = obj.answer_content.intValue;
                break;
            default:
                break;
                
        }
    }
}

- (void)clickSelButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    self.obje.isSelectedIndex = btn.tag;
    int index = btn.tag%100-1;
    if (index < self.obje.options.count) {
        DMQuestOptions *op = [ self.obje.options objectAtIndex:index];
        self.obje.answer_content = op.option_id;
    }
    btn.selected = YES;
    self.clickButtonBlock();
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.obje.answer_content = textField.text;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
     self.clickTextFieldBlock(YES);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.obje.answer_content = textField.text;
    self.clickTextFieldBlock(NO);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    return YES;
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
