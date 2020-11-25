//
//  DetailBannerACollectionViewCell.m
//  DiDiPrismDemo
//
//  Created by hulk on 2020/10/27.
//  Copyright © 2020 prism. All rights reserved.
//

#import "DetailBannerACollectionViewCell.h"
#import "Masonry.h"
#import <SDWebImage/SDWebImage.h>

@interface DetailBannerACollectionViewCell()
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation DetailBannerACollectionViewCell
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action

#pragma mark - delegate

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.imageView];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

#pragma mark - setters
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
}

#pragma mark - getters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
