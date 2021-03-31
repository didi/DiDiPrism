//
//  PrismDataFilterItem.h
//  DiDiPrism
//
//  Created by hulk on 2021/3/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrismDataFilterEditorViewStyle) {
    PrismDataFilterEditorViewStylePicker,
    PrismDataFilterEditorViewStyleRadio
};

@interface PrismDataFilterItem : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSDictionary *itemParams;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface PrismDataFilterItemConfig : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<PrismDataFilterItem*> *items;
@property (nonatomic, assign) PrismDataFilterEditorViewStyle style;
@end

NS_ASSUME_NONNULL_END
