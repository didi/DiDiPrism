//
//  DetailBannerATableViewCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/26.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailBannerATableViewCell.h"
#import <Masonry/Masonry.h>
#import "DetailBannerACollectionViewCell.h"

@interface DetailBannerATableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation DetailBannerATableViewCell
#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action

#pragma mark - delegate
#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *images = @[@"https://view.didistatic.com/static/dcms/1jt5q1e68hkgrnxulc_120x120.png",@"https://view.didistatic.com/static/dcms/olv821ne7ukgrnxsun_96x96.png",@"https://view.didistatic.com/static/dcms/3pwfxvm09kgrnxql3_57x57.png"];
    DetailBannerACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DetailBannerACollectionViewCell" forIndexPath:indexPath];
    cell.imageUrl = images[indexPath.row];
    return cell;
}

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo(150);
    }];
}

#pragma mark - setters

#pragma mark - getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        flowLayout.itemSize = CGSizeMake(mainWindow.frame.size.width, 150);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[DetailBannerACollectionViewCell class] forCellWithReuseIdentifier:@"DetailBannerACollectionViewCell"];
    }
    return _collectionView;
}
@end
