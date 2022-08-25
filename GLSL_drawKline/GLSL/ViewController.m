//
//  ViewController.m
//  GLSL
//
//  Created by zhenyu on 2022/3/25.
//

#import "ViewController.h"
#import "ZYView.h"
@interface ViewController ()

@end

@implementation ViewController
static ZYView *zyView = nil;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    ZYView *view = [[ZYView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 400)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    zyView = view;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(view.frame) + 10, 300, 300)];
    view2.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [zyView setNeedsLayout];
}


@end
