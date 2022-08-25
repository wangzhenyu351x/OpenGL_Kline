//
//  ZYDrawView.m
//  GLSL
//
//  Created by zhenyu on 2022/8/25.
//

#import "ZYDrawView.h"

@implementation ZYDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一条路径
//    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(context, 1);
    int const num = 100;
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
