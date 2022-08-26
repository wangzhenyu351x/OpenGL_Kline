//
//  ZYDrawView.m
//  GLSL
//
//  Created by zhenyu on 2022/8/25.
//

#import "ZYDrawView.h"
#import "common.h"
#import "YJBManyStocksVC.h"

@implementation ZYDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    g_SLICE_NUM = g_SLICE_NUM * 2;
    if (g_SLICE_NUM > 1000000) {
        g_SLICE_NUM = 100;
    }
    NSLog(@"%d",g_SLICE_NUM);
    YJBManyStocksVC *vc = (YJBManyStocksVC *)self.nextResponder.nextResponder;
    if ([vc isKindOfClass:YJBManyStocksVC.class]) {
        [vc fresh];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一条路径
//    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    int const num = g_SLICE_NUM;
    double eachH = self.bounds.size.height/num;
    double eachW = self.bounds.size.width /num;
    
    for (int i=0; i<num; i++) {
        CGContextMoveToPoint(context, 0, eachH*i);
        CGContextAddLineToPoint(context, eachW*num, eachH*i);
        
        CGContextMoveToPoint(context, eachW*i, 0);
        CGContextAddLineToPoint(context, eachW*i, eachH*num);
    }
    //把路径添加到上下文，并进行渲染
//    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
    CGContextStrokePath(context);
    //内存管理，凡是Create、Copy、Retain方法创建出来的的值，都必须手动释放。
//    CGPathRelease(path);
}

@end
