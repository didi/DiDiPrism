//
//  PrismDataFilterEditorView.m
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import "PrismDataFilterEditorView.h"
#import "Masonry.h"
// Util
#import "PrismIdentifierUtil.h"
#import "PrismImageUtil.h"
// Category
#import "UIButton+PrismExtends.h"
#import "NSArray+PrismExtends.h"
// View
#import "PrismDataPickerView.h"

@interface PrismDataFilterEditorView() <UITextFieldDelegate, PrismDataPickerViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) PrismDataPickerView *pickerView;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) NSArray<PrismDataFilterItemConfig*> *config;
@property (nonatomic, copy) NSArray<PrismDataFilterItem*> *currentItems;
@property (nonatomic, strong) PrismDataFilterItem *selectedItem;

@end


@implementation PrismDataFilterEditorView
#pragma mark - life cycle
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(17);
    }];
    [self.saveButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
    [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - public method
- (void)setupWithConfig:(NSArray<PrismDataFilterItemConfig*>*)config {
    [self clearSubview];
    self.config = config;
    for (PrismDataFilterItemConfig *itemConfig in config) {
        UILabel *titleLabel = [self generateLabelWithTitle:itemConfig.title];
        titleLabel.tag = [self calculateParentTagWithParentIndex:itemConfig.index];
        [self addSubview:titleLabel];
        UIView *previousView = [self viewWithTag:titleLabel.tag - 1];
        previousView = previousView ?: self.titleLabel;
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(8);
            make.top.equalTo(previousView.mas_bottom).offset(22);
            make.width.mas_equalTo(80);
        }];
        if (itemConfig.style == PrismDataFilterEditorViewStyleRadio) {
            for (PrismDataFilterItem *item in itemConfig.items) {
                UIButton *button = [self generateButtonWithTitle:item.itemName];
                button.tag = [self calculateChildrenTagWithParentIndex:itemConfig.index childrenIndex:item.index];
                [button setSelected:item.isSelected];
                [self addSubview:button];
                UIView *previousItem = [self viewWithTag:button.tag - 1];
                previousItem = previousItem ?: titleLabel;
                [button mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(titleLabel);
                    make.left.equalTo(previousItem.mas_right).offset(10);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo(60);
                }];
            }
        }
        else if (itemConfig.style == PrismDataFilterEditorViewStylePicker) {
            NSString *title = @"全部";
            for (PrismDataFilterItem *item in itemConfig.items) {
                if (item.isSelected) {
                    title = item.itemName;
                    break;
                }
            }
            UIButton *button = [self generatePickerButtonWithTitle:title];
            button.tag = [self calculateChildrenTagWithParentIndex:itemConfig.index childrenIndex:1];
            [self addSubview:button];
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(titleLabel);
                make.left.equalTo(titleLabel.mas_right).offset(18);
                make.height.mas_equalTo(25);
                make.width.mas_equalTo(80);
            }];
        }
    }
}

#pragma mark - action
- (void)clickButtonAction:(UIButton*)sender {
    if (sender.isSelected) {
        return;
    }
    [sender setSelected:!sender.isSelected];
    for (NSInteger tag = sender.tag/10*10; tag < sender.tag/10*10 + 10; tag++) {
        if (tag == sender.tag) {
            continue;
        }
        UIView *view = [self viewWithTag:tag];
        if (view && [view isKindOfClass:[UIButton class]]) {
            [(UIButton*)view setSelected:NO];
        }
    }
    
    
    NSInteger parentIndex = [self calculateParentIndexWithChildrenTag:sender.tag];
    NSInteger childrenIndex = [self calculateChildrenIndexWithChildrenTag:sender.tag];
    for (PrismDataFilterItemConfig *itemConfig in self.config) {
        if (itemConfig.index != parentIndex) {
            continue;
        }
        for (PrismDataFilterItem *item in itemConfig.items) {
            item.isSelected = item.index == childrenIndex;
        }
    }
}

- (void)clickPickerButtonAction:(UIButton*)sender {
    if (![self.pickerView superview]) {
        UIWindow *mainWindow = UIApplication.sharedApplication.delegate.window;
        self.pickerView.frame = CGRectMake(0, 0, mainWindow.frame.size.width, mainWindow.frame.size.height);
        [mainWindow addSubview:self.pickerView];
    }
    
    NSString *itemName = [sender.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (PrismDataFilterItemConfig *config in self.config) {
        if (config.index == [self calculateParentIndexWithChildrenTag:sender.tag]) {
            self.currentItems = config.items;
            break;
        }
    }
    __block NSInteger defaultRow = 0;
    [self.currentItems enumerateObjectsUsingBlock:^(PrismDataFilterItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.itemName isEqualToString:itemName]) {
            defaultRow = idx;
            *stop = YES;
        }
    }];
    self.selectedItem = [self.currentItems prism_objectAtIndex:defaultRow];
    [self.pickerView reloadWithAllItems:self.currentItems defaultRow:defaultRow];
}

- (void)cancelAction:(UIButton*)sender {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchCancelButton:)]) {
        [self.delegate didTouchCancelButton:sender];
    }
}

- (void)saveAction:(UIButton*)sender {
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchSaveButton:withConfig:)]) {
        [self.delegate didTouchSaveButton:sender withConfig:self.config];
    }
}

#pragma mark - delegate
#pragma mark PrismDataPickerViewDelegate
- (void)confirmWithSelectedRow:(NSInteger)selectedRow {
    self.selectedItem = self.currentItems[selectedRow];
}


#pragma mark - private method
- (void)_initView {
    self.accessibilityIdentifier = [PrismIdentifierUtil identifier];
    self.backgroundColor = [UIColor colorWithRed:0.01 green:0.03 blue:0.08 alpha:0.8];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.saveButton];
    
    [self setNeedsUpdateConstraints];
}

- (void)clearSubview {
    NSArray<UIView*> *retainView = @[self.titleLabel, self.cancelButton, self.saveButton];
    NSArray<UIView*> *allSubviews = [self subviews];
    for (UIView *subview in allSubviews) {
        if (![retainView containsObject:subview]) {
            [subview removeFromSuperview];
        }
    }
}

- (NSInteger)calculateParentTagWithParentIndex:(NSInteger)parentIndex {
    return parentIndex + 100;
}
- (NSInteger)calculateChildrenTagWithParentIndex:(NSInteger)parentIndex childrenIndex:(NSInteger)childrenIndex {
    return parentIndex * 1000 + childrenIndex;
}
- (NSInteger)calculateParentIndexWithChildrenTag:(NSInteger)childrenTag {
    return childrenTag / 1000;
}
- (NSInteger)calculateChildrenIndexWithChildrenTag:(NSInteger)childrenTag {
    return childrenTag % 1000;
}

- (UILabel *)generateLabelWithTitle:(NSString*)title {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (UIButton *)generateButtonWithTitle:(NSString*)title {
    UIButton *button = [[UIButton alloc] init];
    button.accessibilityLabel = [PrismIdentifierUtil identifier];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setImage:[PrismImageUtil imageNamed:@"prism_visualization_radio_normal.png"] forState:UIControlStateNormal];
    [button setImage:[PrismImageUtil imageNamed:@"prism_visualization_radio_checked.png"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[NSString stringWithFormat:@" %@", title] forState:UIControlStateNormal];
    return button;
}

- (UIButton *)generatePickerButtonWithTitle:(NSString*)title {
    UIButton *button = [[UIButton alloc] init];
    button.accessibilityLabel = [PrismIdentifierUtil identifier];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.2 green:0.21 blue:0.25 alpha:1.0] forState:UIControlStateSelected];
    [button prism_setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button prism_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 2.0;
    button.layer.masksToBounds = YES;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button setLineBreakMode:NSLineBreakByTruncatingTail];
    [button setTitle:[NSString stringWithFormat:@" %@ ", title] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickPickerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - setters

#pragma mark - getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"数据筛选";
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _titleLabel;
}

- (PrismDataPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[PrismDataPickerView alloc] init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        _saveButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveButton setTitleColor:[UIColor colorWithRed:0.16 green:0.2 blue:0.25 alpha:1] forState:UIControlStateNormal];
        _saveButton.backgroundColor = [UIColor whiteColor];
        _saveButton.layer.cornerRadius = 13;
        _saveButton.layer.masksToBounds = YES;
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    return _saveButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.accessibilityLabel = [PrismIdentifierUtil identifier];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 13;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.borderColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1].CGColor;
        _cancelButton.backgroundColor = [UIColor colorWithRed:0.18 green:0.2 blue:0.24 alpha:0.8];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    return _cancelButton;
}

@end

