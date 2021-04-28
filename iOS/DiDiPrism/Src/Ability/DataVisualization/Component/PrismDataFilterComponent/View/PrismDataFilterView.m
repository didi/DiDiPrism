//
//  PrismDataFilterView.m
//  DiDiPrism
//
//  Created by hulk on 2021/2/23.
//

#import "PrismDataFilterView.h"
#import "Masonry.h"
// Util
#import "PrismIdentifierUtil.h"
#import "PrismImageUtil.h"

@interface PrismDataFilterView()
@property (nonatomic, strong) UIButton *foldButton;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) UIButton *throughButton;

@property (nonatomic, assign) BOOL isFolding;
@end

@implementation PrismDataFilterView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initData];
    }
    return self;
}

#pragma mark - action
- (void)foldAction:(UIButton*)sender {
    if (self.filterButton.isSelected) {
        self.filterButton.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchFilterButton:isShow:)]) {
            [self.delegate didTouchFilterButton:self.filterButton isShow:NO];
        }
        return;
    }
    self.isFolding = !self.isFolding;
    NSString *imageName = self.isFolding ? @"prism_visualization_unfold.png" : @"prism_visualization_fold.png";
    [sender setImage:[PrismImageUtil imageNamed:imageName] forState:UIControlStateNormal];
    CGRect lastFrame = self.frame;
    CGFloat currentWidth = self.isFolding ? PrismDataFilterViewFoldWidth : PrismDataFilterViewUnfoldWidth;
    CGFloat currentOrignX = self.isFolding ? PrismDataFilterViewOrignX : ([UIScreen mainScreen].bounds.size.width - currentWidth) / 2;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(currentOrignX, lastFrame.origin.y, currentWidth, lastFrame.size.height);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchFoldButton:isFolding:)]) {
        [self.delegate didTouchFoldButton:sender isFolding:self.isFolding];
    }
}

- (void)editAction:(UIButton*)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchFilterButton:isShow:)]) {
        [self.delegate didTouchFilterButton:sender isShow:sender.isSelected];
    }
}

- (void)selectPageAction:(UIButton*)sender {
    if (self.filterButton.isSelected) {
        self.filterButton.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchFilterButton:isShow:)]) {
            [self.delegate didTouchFilterButton:self.filterButton isShow:NO];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchThroughButton:)]) {
        [self.delegate didTouchThroughButton:sender];
    }
}

#pragma mark - delegate

#pragma mark - public method
- (void)reset {
    [self.filterButton setSelected:NO];
}

#pragma mark - private method
- (void)initView {
    self.accessibilityIdentifier = [PrismIdentifierUtil identifier];
    self.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.cornerRadius = PrismDataFilterViewHeight / 2;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.foldButton];
    [self addSubview:self.filterButton];
    [self addSubview:self.throughButton];
    
    [self.foldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(PrismDataFilterViewFoldWidth);
    }];
    [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.foldButton.mas_right);
        make.width.mas_equalTo(PrismDataFilterViewUnfoldWidth - PrismDataFilterViewFoldWidth - PrismDataFilterViewSelectPageWidth);
    }];
    [self.throughButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self.filterButton.mas_right);
        make.width.mas_equalTo(PrismDataFilterViewSelectPageWidth);
    }];
}

- (void)initData {
    
}

#pragma mark - setters

#pragma mark - getters
- (UIButton *)foldButton {
    if (!_foldButton) {
        _foldButton = [[UIButton alloc] init];
        _foldButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        [_foldButton setImage:[PrismImageUtil imageNamed:@"prism_visualization_fold.png"] forState:UIControlStateNormal];
        [_foldButton addTarget:self action:@selector(foldAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foldButton;
}

- (UIButton *)filterButton {
    if (!_filterButton) {
        _filterButton = [[UIButton alloc] init];
        _filterButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        [_filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_filterButton setTitleColor:[UIColor colorWithRed:0.36 green:0.68 blue:1.0 alpha:1.0] forState:UIControlStateSelected];
        _filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _filterButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_filterButton setTitle:@"数据筛选" forState:UIControlStateNormal];
        [_filterButton setTitle:@"数据筛选" forState:UIControlStateSelected];
        [_filterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [_filterButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _filterButton;
}

- (UIButton *)throughButton {
    if (!_throughButton) {
        _throughButton = [[UIButton alloc] init];
        _throughButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _throughButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.21 blue:0.26 alpha:1.0];
        _throughButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_throughButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_throughButton setTitle:@" 任意门" forState:UIControlStateNormal];
        [_throughButton setImage:[PrismImageUtil imageNamed:@"prism_visualization_through_door.png"] forState:UIControlStateNormal];
        [_throughButton addTarget:self action:@selector(selectPageAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _throughButton;
}
@end
