//
//  ZYShapeLayerView.m
//  GLSL
//
//  Created by zhenyu on 2022/8/26.
//

#import "ZYShapeLayerView.h"
#import "common.h"
@interface ZYShapeLayerView ()
//@property (nonatomic) CAShapeLayer *shapeLayer;
@property (nonatomic) NSArray<CAShapeLayer *> *layers;
@end
@implementation ZYShapeLayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        NSMutableArray *arr = [NSMutableArray array];
//        for (int i=0; i<10; i++) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.strokeColor = [UIColor blueColor].CGColor;
            layer.lineWidth = 1.0;
            [arr addObject:layer];
            [self.layer addSublayer:layer];
//        }
        self.layers = arr.copy;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    int const num = g_SLICE_NUM;
    double eachH = self.bounds.size.height/num;
    double eachW = self.bounds.size.width /num;
    
    for (int i=0; i<num; i++) {
        [path moveToPoint:CGPointMake(0, eachH*i)];
        //        CGContextMoveToPoint(context, 0, eachH*i);
        [path addLineToPoint:CGPointMake(eachW*num, eachH*i)];
        
        [path moveToPoint:CGPointMake(eachW*i, 0)];
        [path addLineToPoint:CGPointMake(eachW*i, eachH*num)];
    }
    for (CAShapeLayer *layer in self.layers) {
        layer.path = path.CGPath;
    }
}

@end
