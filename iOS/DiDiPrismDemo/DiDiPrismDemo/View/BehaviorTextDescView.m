//
//  PrismBehaviorTextDescView.m
//  DiDiPrismDemo
//
//  Created by hulk on 2019/11/7.
//

#import "BehaviorTextDescView.h"
#import <Masonry/Masonry.h>
#import <DiDiPrism/UIColor+PrismExtends.h>
#import "BehaviorTextDescViewCell.h"
#import "BehaviorTextDescNodeCell.h"

@interface BehaviorTextDescView() <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, copy) NSArray<PrismBehaviorTextModel*> *textDescArray;

@property (nonatomic, strong) UITableView *descTableView;

@end

@implementation BehaviorTextDescView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - action
- (void)tapAction:(UITapGestureRecognizer*)gesture {
    [self removeFromSuperview];
}

#pragma mark - delegate
#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.textDescArray.count + (self.model.startIndex > self.textDescArray.count ? 0 : 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.model.startIndex
        || (self.model.startIndex < self.textDescArray.count && indexPath.row == self.model.endIndex + 2)
        || (indexPath.row == self.textDescArray.count + 1 && indexPath.row == self.model.endIndex)) {
        BehaviorTextDescNodeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrismBehaviorTextDescNodeCell"];
        if (!cell) {
            cell = [[BehaviorTextDescNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrismBehaviorTextDescNodeCell"];
        }
        cell.titleLabel.text = indexPath.row == self.model.startIndex ? @"视频回放起点" : @"视频回放终点";
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else {
        BehaviorTextDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrismBehaviorTextDescViewCell"];
        if (!cell) {
            cell = [[BehaviorTextDescViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrismBehaviorTextDescViewCell"];
        }

        NSInteger rowValue = indexPath.row > self.model.startIndex ? (indexPath.row > self.model.endIndex + 2 ? indexPath.row - 2 : indexPath.row - 1) : indexPath.row;
        cell.indexLabel.text = [NSString stringWithFormat:@"%ld", (long)(rowValue + 1)];
        cell.textModel = self.textDescArray[rowValue];
        UIColor *hightlightColor = (indexPath.row >= self.model.startIndex && indexPath.row <=
        self.model.endIndex + 2) ? [UIColor prism_colorWithHexString:@"#EEF6FF"] : [UIColor prism_colorWithHexString:@"#F8F8F8"];
        cell.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : hightlightColor;
        cell.contentImageView.backgroundColor = (indexPath.row >= self.model.startIndex && indexPath.row <=
                                                 self.model.endIndex + 2) ? [UIColor prism_colorWithHexString:@"#EEF6FF"] : [[UIColor grayColor] colorWithAlphaComponent:0.1];
        if (self.model.replayFailIndex >= 0 && rowValue == self.model.startIndex + self.model.replayFailIndex) {
            cell.failFlagLabel.hidden = NO;
            cell.contentView.layer.borderColor = [UIColor redColor].CGColor;
            cell.contentView.layer.borderWidth = 0.5;
        }
        else {
            cell.failFlagLabel.hidden = YES;
            cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
            cell.contentView.layer.borderWidth = 0;
        }
        return cell;
    }
}

#pragma mark - public method

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
    [self addSubview:self.descTableView];
    
    [self.descTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
}

#pragma mark - setters
- (void)setModel:(PrismBehaviorListModel *)model {
    _model = model;
    if (!_model) {
        return;
    }
    self.textDescArray = [model instructionTextArray];
}

- (void)setTextDescArray:(NSArray<PrismBehaviorTextModel *> *)textDescArray {
    _textDescArray = textDescArray;
    
    [self.descTableView reloadData];
    [self.descTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    if (self.model.startIndex < self.textDescArray.count || self.model.replayFailIndex >= 0) {
        NSInteger row = self.model.replayFailIndex >= 0 ? self.model.replayFailIndex : self.model.startIndex;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.descTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }
}

#pragma mark - getters
- (UITableView *)descTableView {
    if (!_descTableView) {
        _descTableView = [[UITableView alloc] init];
        _descTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _descTableView.delegate = self;
        _descTableView.dataSource = self;
    }
    return _descTableView;
}


@end
