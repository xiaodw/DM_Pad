//
//  DMPullDownMenu.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/15.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMPullDownMenu.h"
#import "DMPullDownCell.h"

#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

#define FRAME_ORIGIN(aFrame)     ((aFrame).origin)
#define FRAME_X(aFrame)          ((aFrame).origin.x)
#define FRAME_Y(aFrame)          ((aFrame).origin.y)

#define FRAME_SIZE(aFrame)       ((aFrame).size)
#define FRAME_HEIGHT(aFrame)     ((aFrame).size.height)
#define FRAME_WIDTH(aFrame)      ((aFrame).size.width)



#define VIEW_BOUNDS(aView)       ((aView).bounds)

#define VIEW_FRAME(aView)        ((aView).frame)

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)


#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)

#define AnimateTime 0.25f   // 下拉动画时间

@implementation DMPullDownMenu
{
    UIImageView * _arrowMark;   // 尖头图标
    UIView      * _listView;    // 下拉列表背景View
    UITableView * _tableView;   // 下拉列表
    
    NSArray     * _titleArr;    // 选项数组
    CGFloat       _rowHeight;   // 下拉列表行高
    UIView      * _bgView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self createMainBtnWithFrame:frame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self createMainBtnWithFrame:frame];
}


- (void)createMainBtnWithFrame:(CGRect)frame{
    if (self.mainBtn) {
        _mainBtn.layer.cornerRadius = 5;
        _mainBtn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
        _mainBtn.layer.borderWidth = 1;
        _mainBtn.backgroundColor = DMColorWithRGBA(56, 56, 56, 1);
        [_mainBtn setImage:[UIImage imageNamed:@"btn_menu_arrow_top"] forState:UIControlStateSelected];
#if LANGUAGE_ENVIRONMENT == 0 //中文
        [_mainBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0, 30.0)];
        [_mainBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0.0, -65)];
#elif LANGUAGE_ENVIRONMENT == 1 //英文
        _mainBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
        _mainBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [_mainBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0, 20.0)];
        [_mainBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0.0, -70)];
        
#endif
    
    } else {
        //创建
    }
}


- (void)setMenuTitles:(NSArray *)titlesArr rowHeight:(CGFloat)rowHeight {
    
    if (self == nil) {
        return;
    }

    _titleArr  = [NSArray arrayWithArray:titlesArr];
    _rowHeight = rowHeight;
    
    
    // 下拉列表背景View
    _listView = [[UIView alloc] init];
    _listView.frame = CGRectMake(VIEW_X(self) , VIEW_Y_Bottom(self), VIEW_WIDTH(self),  0);
    _listView.backgroundColor = [UIColor clearColor];
    _listView.clipsToBounds       = YES;
    _listView.layer.masksToBounds = NO;
    _listView.layer.cornerRadius = 5;
    _listView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.5].CGColor;
    _listView.layer.borderWidth = 3;
    _listView.layer.shadowColor = UIColorFromRGB(0xf6087a).CGColor;//shadowColor阴影颜色
    _listView.layer.shadowOffset = CGSizeMake(1,3);//shadowOffset阴影偏移,x向右偏移，y向下偏移，默认(0, -3),这个跟shadowRadius配合使用
    _listView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
    _listView.layer.shadowRadius = 8;//阴影半径，默认3

    
    
    // 下拉列表TableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView))];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.bounces         = NO;
    [_listView addSubview:_tableView];
    _tableView.clipsToBounds       = YES;
    //_tableView.layer.cornerRadius = 5;
}

- (void)clickMainBtn:(UIButton *)button {
    
    [self.superview addSubview:_listView]; // 将下拉视图添加到控件的俯视图上
    
    if(button.selected == NO) {
        [self showPullDown];
    }
    else {
        [self hidePullDown];
    }
}

- (void)showPullDown{   // 显示下拉列表
    [_listView.superview bringSubviewToFront:_listView]; // 将下拉列表置于最上层
    
    if ([self.delegate respondsToSelector:@selector(pulldownMenuWillShow:)]) {
        [self.delegate pulldownMenuWillShow:self]; // 将要显示回调代理
    }
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), _rowHeight *_titleArr.count);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        _bgView.frame = CGRectMake(0, 0, DMScreenWidth, DMScreenHeight);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_tableView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

        maskLayer.lineJoin = kCALineJoinRound;
        maskLayer.lineCap = kCALineCapRound;
        maskLayer.path = maskPath.CGPath;
        _tableView.layer.mask = maskLayer;
        
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(pulldownMenuDidShow:)]) {
            [self.delegate pulldownMenuDidShow:self]; // 已经显示回调代理
        }
    }];
    
    _mainBtn.selected = YES;
}
- (void)hidePullDown{  // 隐藏下拉列表
    
    
    if ([self.delegate respondsToSelector:@selector(pulldownMenuWillHidden:)]) {
        [self.delegate pulldownMenuWillHidden:self]; // 将要隐藏回调代理
    }
    
    
    [UIView animateWithDuration:AnimateTime animations:^{
        
        _arrowMark.transform = CGAffineTransformIdentity;
        _listView.frame  = CGRectMake(VIEW_X(_listView), VIEW_Y(_listView), VIEW_WIDTH(_listView), 0);
        _tableView.frame = CGRectMake(0, 0, VIEW_WIDTH(_listView), VIEW_HEIGHT(_listView));
        _bgView.frame = CGRectZero;
    }completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(pulldownMenuDidHidden:)]) {
            [self.delegate pulldownMenuDidHidden:self]; // 已经隐藏回调代理
        }
    }];
    
    
    
    _mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *pdCell = @"pdCell";
    DMPullDownCell *cell = [tableView dequeueReusableCellWithIdentifier:pdCell];
    if (!cell) {
        cell = [[DMPullDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pdCell];
    }
    cell.titleLabel.text =[_titleArr objectAtIndex:indexPath.row];
    if (_titleArr.count == 0 || indexPath.row == _titleArr.count-1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [_mainBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    if (indexPath.row < _titleArr.count) {
        
#if LANGUAGE_ENVIRONMENT == 0 //中文
        [self.mainBtn setTitle:[_titleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
#elif LANGUAGE_ENVIRONMENT == 1 //英文
        UILabel *titleLabel = [self.mainBtn viewWithTag:10001];
        titleLabel.text = [_titleArr objectAtIndex:indexPath.row];
        
#endif        
        if ([self.delegate respondsToSelector:@selector(pulldownMenu:selectedCellNumber:)]) {
            [self.delegate pulldownMenu:self selectedCellNumber:indexPath.row]; // 回调代理
        }
    }
    
    [self hidePullDown];
}

@end
