//
//  PrismDataPickerView.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import "PrismDataPickerView.h"
#import "PrismIdentifierUtil.h"
#import "Masonry.h"

@interface PrismDataPickerView()< UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *typePicker;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *confirmTypeButton;
@property (nonatomic, strong) UIButton *cancelTypeButton;

@property (nonatomic, copy) NSArray<PrismDataFilterItem*> *oneColumnItems;
@property (nonatomic, copy) NSDictionary<NSString *,NSArray<PrismDataFilterItem*> *> * twoColumnItems;
@end

@implementation PrismDataPickerView
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
- (void)confirmTypeAction:(UIButton*)sender {
    [self removeFromSuperview];
    
    if (self.oneColumnItems.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithSelectedRow:)]) {
            [self.delegate confirmWithSelectedRow:[_typePicker selectedRowInComponent:0]];
        }
    }
    else if (self.twoColumnItems.allKeys.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmWithSelectedRow0:selectedRow1:)]) {
            [self.delegate confirmWithSelectedRow0:[_typePicker selectedRowInComponent:0] selectedRow1:[_typePicker selectedRowInComponent:1]];
        }
    }
    
}

- (void)cancelTypeAction:(UIButton*)sender {
    [self removeFromSuperview];
}

#pragma mark - delegate
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.oneColumnItems.count) {
        return 1;
    }
    else if (self.twoColumnItems.allKeys.count) {
        return 2;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.oneColumnItems.count) {
        return self.oneColumnItems.count;
    }
    else if (self.twoColumnItems.allKeys.count) {
        if (component == 0) {
            return self.twoColumnItems.allKeys.count;
        }
        else if (component == 1) {
            NSInteger component0Row = [pickerView selectedRowInComponent:0];
            NSArray *valueArray = self.twoColumnItems[self.twoColumnItems.allKeys[component0Row]];
            return valueArray.count;
        }
    }
    return 0;
}

#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.oneColumnItems.count) {
        return pickerView.frame.size.width;
    }
    else if (self.twoColumnItems.allKeys.count) {
        if (component == 0) {
            return 130;
        }
        else if (component == 1) {
            return pickerView.frame.size.width - 130;
        }
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.oneColumnItems.count) {
        return self.oneColumnItems[row].itemName;
    }
    else if (self.twoColumnItems.allKeys.count) {
        if (component == 0) {
            return self.twoColumnItems.allKeys[row];
        }
        else if (component == 1) {
            NSInteger component0Row = [pickerView selectedRowInComponent:0];
            if (self.twoColumnItems[self.twoColumnItems.allKeys[component0Row]].count) {
                return self.twoColumnItems[self.twoColumnItems.allKeys[component0Row]][row].itemName;
            }
        }
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 && self.twoColumnItems.allKeys.count) {
        [pickerView reloadComponent:1];
    }
}

#pragma mark - public method
- (void)reloadWithAllItems:(NSArray<PrismDataFilterItem*> *)allItems defaultRow:(NSInteger)defaultRow {
    self.twoColumnItems = nil;
    self.oneColumnItems = allItems;
    [self.typePicker reloadAllComponents];
    [self.typePicker selectRow:defaultRow inComponent:0 animated:NO];
}

- (void)reloadWithAllItems:(NSDictionary<NSString *,NSArray<PrismDataFilterItem*> *> *)allItems
               defaultRow0:(NSInteger)defaultRow0
               defaultRow1:(NSInteger)defaultRow1 {
    self.oneColumnItems = nil;
    self.twoColumnItems = allItems;
    [self.typePicker reloadAllComponents];
    if (allItems.allKeys.count) {
        [self.typePicker selectRow:defaultRow0 inComponent:0 animated:NO];
        [self.typePicker selectRow:defaultRow1 inComponent:1 animated:NO];
    }
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self addSubview:self.backView];
    [self addSubview:self.typePicker];
    [self addSubview:self.confirmTypeButton];
    [self addSubview:self.cancelTypeButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(260);
    }];
    [self.typePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(200);
    }];
    [self.confirmTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-205);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.cancelTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.confirmTypeButton.mas_left).offset(-5);
        make.top.bottom.equalTo(self.confirmTypeButton);
        make.width.mas_equalTo(80);
    }];
    
}

#pragma mark - setters

#pragma mark - getters
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIPickerView *)typePicker {
    if (!_typePicker) {
        _typePicker = [[UIPickerView alloc] init];
        _typePicker.delegate = self;
        _typePicker.dataSource = self;
        _typePicker.backgroundColor = [UIColor whiteColor];
    }
    return _typePicker;
}

- (UIButton *)confirmTypeButton {
    if (!_confirmTypeButton) {
        _confirmTypeButton = [[UIButton alloc] init];
        _confirmTypeButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _confirmTypeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_confirmTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmTypeButton setBackgroundColor:[UIColor clearColor]];
        _confirmTypeButton.layer.borderColor = [UIColor blackColor].CGColor;
        _confirmTypeButton.layer.borderWidth = 0.5;
        _confirmTypeButton.layer.cornerRadius = 2.0;
        _confirmTypeButton.layer.masksToBounds = YES;
        [_confirmTypeButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmTypeButton addTarget:self action:@selector(confirmTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmTypeButton;
}

- (UIButton *)cancelTypeButton {
    if (!_cancelTypeButton) {
        _cancelTypeButton = [[UIButton alloc] init];
        _cancelTypeButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _cancelTypeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_cancelTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelTypeButton setBackgroundColor:[UIColor clearColor]];
        _cancelTypeButton.layer.borderColor = [UIColor blackColor].CGColor;
        _cancelTypeButton.layer.borderWidth = 0.5;
        _cancelTypeButton.layer.cornerRadius = 2.0;
        _cancelTypeButton.layer.masksToBounds = YES;
        [_cancelTypeButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelTypeButton addTarget:self action:@selector(cancelTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelTypeButton;
}
@end

