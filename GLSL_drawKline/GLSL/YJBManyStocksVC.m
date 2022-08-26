//
//  YJBManyStocksVC.m
//  YJBClient
//
//  Created by zhenyu on 2022/8/22.
//  Copyright © 2022 Gjzq. All rights reserved.
//

#import "YJBManyStocksVC.h"
#import "YJBKlineViewCell.h"
#import "ZYDrawView.h"
#import "ZYShapeLayerView.h"
#import "common.h"
#import "ZYView.h"
@interface YJBManyStocksVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) ZYDrawView *drawView;
@property (nonatomic) ZYView *openGLView;
@property (nonatomic) ZYShapeLayerView *shapeView;
@property (nonatomic) UITextField *textField;
@end

@implementation YJBManyStocksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self generateNavBar];
//    [self addCollectionView];
//    [self requestKLineDataWithIsHistory:NO];
    ZYDrawView *drawView = [[ZYDrawView alloc] initWithFrame:CGRectMake(50, 50, 300, 200)];
    [self.view addSubview:drawView];
    self.drawView = drawView;
    
    ZYShapeLayerView *shapeView = [[ZYShapeLayerView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(drawView.frame) + 20, 300, 200)];
    [self.view addSubview:shapeView];
    self.shapeView = shapeView;
    
    ZYView *glView = [[ZYView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(shapeView.frame) + 20, 300, 200)];
    [self.view addSubview:glView];
    self.openGLView = glView;
    
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(glView.frame) + 20, 350, 30)];
    field.textColor = [UIColor blackColor];
    field.userInteractionEnabled = NO;
    [self.view addSubview:field];
    self.textField = field;
    
    [self beginTimer];
    
}

- (void)beginTimer {
    static CADisplayLink *link = nil;
    if (link) {
        return;
    }
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(display)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
static int kSwitch = 0;
- (void)display {
//    NSArray<__kindof UICollectionViewCell *> *cells = [self.collectionView visibleCells];
//    NSUInteger const count = cells.count;
//    unsigned long countMin = count;// MIN(count, 5);
//    for (int i=0; i<countMin; i++) {
//        YJBKlineViewCell *cell = cells[i];
//        [cell.drawview setNeedsDisplay];
//    }
    
    if (kSwitch == 1) {
        [self.drawView setNeedsDisplay];
    } else if (kSwitch == 2) {
        [self.shapeView setNeedsDisplay];
    } else {
        [self.openGLView renderLayer];
    }
    [self fresh];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    kSwitch = (kSwitch+1)%3;
    NSLog(@"%d",kSwitch);
    [self fresh];
}

- (void)fresh {
    self.textField.text = [NSString stringWithFormat:@" %@ => %d time:%.2f",kSwitch == 1?@"drawView" :( kSwitch == 2? @"shapeView": @"glView"),g_SLICE_NUM,[NSDate date].timeIntervalSince1970];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self display];
//}

- (void)addCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(300, 300);
    layout.minimumLineSpacing = 2;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:YJBKlineViewCell.class forCellWithReuseIdentifier:NSStringFromClass(YJBKlineViewCell.class)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)requestKLineDataWithIsHistory:(BOOL)isHistory{
    [self beginTimer];
}


#pragma mark - datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}
#pragma mark - delegate

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJBKlineViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YJBKlineViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


@end
