//
//  YJBManyStocksVC.m
//  YJBClient
//
//  Created by zhenyu on 2022/8/22.
//  Copyright © 2022 Gjzq. All rights reserved.
//

#import "YJBManyStocksVC.h"
#import "YJBKlineViewCell.h"
@interface YJBManyStocksVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation YJBManyStocksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self generateNavBar];
    [self addCollectionView];
    [self requestKLineDataWithIsHistory:NO];
    
}

- (void)generateNavBar {
    if (YES) {
//        self.navBar = [HsNavigationBar navigationBarWithLeftBarType:HsNavigationLeftBarTypeBack];
//
//        [self.view addSubview:self.navBar];
//        self.navBar.useNewAppearanceColor = true;
//        self.navBar.updateAppearanceColor = ^(HsNavigationBar *navBar) {
//            navBar.backgroundView.backgroundColor = YJBHexColor(#ffffff,#0f0f1b);
//        };
//        [self.navBar updateAppearance];
        
//        ({
//            UISwipeGestureRecognizer *leftGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(minusNum)];
//            leftGes.direction = UISwipeGestureRecognizerDirectionLeft;
//            [self.navBar addGestureRecognizer:leftGes];
//        });
//        ({
//            UISwipeGestureRecognizer *rightGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addNum)];
//            rightGes.direction = UISwipeGestureRecognizerDirectionRight;
//            [self.navBar addGestureRecognizer:rightGes];
//        });
//        
//        ({
//            UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//            [self.navBar addGestureRecognizer:tapClick];
//        });
        
    }
}

- (void)tapClick:(UIGestureRecognizer *)ges {
}

- (void)beginTimer {
    static CADisplayLink *link = nil;
    if (link) {
        return;
    }
    link = [CADisplayLink displayLinkWithTarget:self selector:@selector(redisplay)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)redisplay {
//    static int i = 0;
//    i++;
//    if (i % 10 == 0) {
        [self display];
//    }
}

- (void)display {
    NSArray<__kindof UICollectionViewCell *> *cells = [self.collectionView visibleCells];
    NSUInteger const count = cells.count;
    unsigned long countMin = count;// MIN(count, 5);
    for (int i=0; i<countMin; i++) {
        YJBKlineViewCell *cell = cells[i];
        [cell.drawview setNeedsDisplay];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self display];
}

- (void)addCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
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
    return 80;
}
#pragma mark - delegate

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YJBKlineViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YJBKlineViewCell.class) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


@end
