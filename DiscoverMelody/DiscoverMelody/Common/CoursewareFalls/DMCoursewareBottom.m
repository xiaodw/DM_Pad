//
//  DMCoursewareBottom.m
//  DiscoverMelody
//
//  Created by Ares on 2017/9/12.
//  Copyright © 2017年 Discover Melody. All rights reserved.
//

#import "DMCoursewareBottom.h"

@implementation DMCoursewareBottom

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
    self.uploadBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 44, self.bounds.size.height)];
//    [self.uploadBtn setImage:[UIImage imageNamed:@"c_upload_normal"] forState:UIControlStateNormal];
    [self.uploadBtn setImage:[UIImage imageNamed:@"c_upload_selected"] forState:UIControlStateNormal];
    [self.uploadBtn setTitle:@"上传" forState:UIControlStateNormal];
    [self.uploadBtn.titleLabel setFont:DMFontPingFang_Light(12)];
    [self.uploadBtn setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
    [self.uploadBtn addTarget:self action:@selector(clickUploadBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.uploadBtn];
    
    self.synBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-44/2, 0, 44, self.bounds.size.height)];
    //    [self.uploadBtn setImage:[UIImage imageNamed:@"c_upload_normal"] forState:UIControlStateNormal];
    [self.synBtn setImage:[UIImage imageNamed:@"c_synchronizing_selected"] forState:UIControlStateNormal];
    [self.synBtn setTitle:@"同步" forState:UIControlStateNormal];
    [self.synBtn.titleLabel setFont:DMFontPingFang_Light(12)];
    [self.synBtn setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
    [self.synBtn addTarget:self action:@selector(clickSynBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.synBtn];
    
    self.delBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-30-44, 0, 44, self.bounds.size.height)];
    //    [self.uploadBtn setImage:[UIImage imageNamed:@"c_upload_normal"] forState:UIControlStateNormal];
    [self.delBtn setImage:[UIImage imageNamed:@"c_delete_selected"] forState:UIControlStateNormal];
    [self.delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [self.delBtn.titleLabel setFont:DMFontPingFang_Light(12)];
    [self.delBtn setTitleColor:DMColorBaseMeiRed forState:UIControlStateNormal];
    [self.delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.delBtn];

    [self.uploadBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -28, -28.0, 0.0)];
    [self.uploadBtn setImageEdgeInsets:UIEdgeInsetsMake(-15.0, 0.0, 0.0, -23)];
    [self.synBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -24, -28.0, 0.0)];
    [self.synBtn setImageEdgeInsets:UIEdgeInsetsMake(-15.0, 0.0, 0.0, -23)];
    [self.delBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -24, -28.0, 0.0)];
    [self.delBtn setImageEdgeInsets:UIEdgeInsetsMake(-15.0, 0.0, 0.0, -23)];
}

- (void)clickUploadBtn:(id)sender {
    if (self.blockDidUpload) {
        self.blockDidUpload();
    }
}

- (void)clickSynBtn:(id)sender {
    if (self.blockDidSyn) {
        self.blockDidSyn();
    }
}
- (void)clickDelBtn:(id)sender {
    if (self.blockDidDelete) {
        self.blockDidDelete();
    }
}

-(void)didUpload:(BlockDidUpload)blockDidUpload {
    self.blockDidUpload = blockDidUpload;
}

-(void)didDelete:(BlockDidDelete)blockDidDelete {
    self.blockDidDelete = blockDidDelete;
}

-(void)didSyn:(BlockDidSyn)blockDidSyn {
    self.blockDidSyn = blockDidSyn;
}

@end
