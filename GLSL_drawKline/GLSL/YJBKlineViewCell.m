//
//  YJBKlineViewCell.m
//  YJBClient
//
//  Created by zhenyu on 2022/8/22.
//  Copyright © 2022 Gjzq. All rights reserved.
//

#import "YJBKlineViewCell.h"
#import "ZYDrawView.h"
@interface YJBKlineViewCell ()
@end
@implementation YJBKlineViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        ZYDrawView *view = [[ZYDrawView alloc] initWithFrame:self.bounds];
        [self addSubview:view];
        self.drawview = view;
    }
    return self;
}

@end
