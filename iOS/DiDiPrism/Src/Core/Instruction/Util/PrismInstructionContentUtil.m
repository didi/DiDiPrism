//
//  PrismInstructionContentUtil.m
//  DiDiPrism
//
//  Created by hulk on 2020/5/7.
//

#import "PrismInstructionContentUtil.h"
// Category
#import "UIImage+PrismIntercept.h"
#import "NSArray+PrismExtends.h"
#import "NSDictionary+PrismExtends.h"
#import "UIView+PrismExtends.h"

@interface PrismInstructionContentUtil()

@end

@implementation PrismInstructionContentUtil
#pragma mark - life cycle

#pragma mark - public method
+ (NSString*)getRepresentativeContentOfView:(UIView*)view needRecursive:(BOOL)needRecursive {
    if (!needRecursive && (view.alpha == 0 || view.hidden == YES)) {
        return nil;
    }
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel*)view;
        if (label.text.length) {
            return label.text;
        }
    }
    id wxComponent = [view prism_wxComponent];
    if ([wxComponent isKindOfClass:NSClassFromString(@"WXTextComponent")]) {
        NSString *text = [wxComponent valueForKey:@"text"];
        if ([text isKindOfClass:[NSString class]] && text.length) {
            return text;
        }
    }
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)view;
        if (imageView.image.autoDotImageName.length) {
            return imageView.image.autoDotImageName;
        }
    }
    if ([wxComponent isKindOfClass:NSClassFromString(@"WXImageComponent")]) {
        NSString *src = [[wxComponent valueForKey:@"attributes"] valueForKey:@"src"];
        if ([src isKindOfClass:[NSString class]] && src.length) {
            return src;
        }
    }
    if (!needRecursive) {
        return nil;
    }
    if (![view subviews].count) {
        return nil;
    }
    // 文字回放内容优化
    // 我们认为，如果有文本就应该优先使用文本，因为但凡出现了文本相对来说其比图片所表述的意思会更清晰。
    UIView *firstTextView = nil;
    UIView *bigTextView = nil;
    NSMutableArray<UIView*> *imageViews = [NSMutableArray array];
    [self recursiveSubviewsWithViews:[view subviews] standardView:view firstTextView:&firstTextView bigTextView:&bigTextView imageViews:imageViews count:0];
    NSMutableString *functionName = [NSMutableString string];
    if (firstTextView) {
        NSString *firstText = [self getRepresentativeContentOfView:firstTextView needRecursive:NO];
        if (firstText.length) {
            [functionName appendFormat:@"%@_&_", firstText];
        }
    }
    if (bigTextView && bigTextView != firstTextView) {
        NSString *bigText = [self getRepresentativeContentOfView:bigTextView needRecursive:NO];
        if (bigText.length) {
            [functionName appendString:bigText];
        }
    }
    if (functionName.length) {
        return [functionName copy];
    }
    NSArray<UIView*> *allRepresentativeSubviews = [imageViews copy];
    for (UIView *subview in allRepresentativeSubviews) {
        NSString *subviewText = [self getRepresentativeContentOfView:subview needRecursive:NO];
        if (subviewText.length) {
            [functionName appendString:subviewText];
            return [functionName copy];
        }
    }
    
    return nil;
}

#pragma mark - private method
+ (void)recursiveSubviewsWithViews:(NSArray<UIView*>*)views
                      standardView:(UIView*)standardView
                     firstTextView:(UIView**)firstTextView
                       bigTextView:(UIView**)bigTextView
                        imageViews:(NSMutableArray<UIView*>*)imageViews
                             count:(NSInteger)count {
    if (count > 4 || !views.count) {
        return;
    }
    count++;
    NSMutableArray<UIView*> *allSubviews = [NSMutableArray array];
    for (UIView *view in views) {
        if (view.isHidden) {
            continue;
        }
        id wxComponent = [view prism_wxComponent];
        if ([wxComponent isKindOfClass:NSClassFromString(@"WXTextComponent")] || [view isKindOfClass:[UILabel class]]) {
            if (!*firstTextView) {
                *firstTextView = view;
            }
            else {
                CGRect newRect = [view convertRect:view.bounds toView:standardView];
                CGRect oldRect = [(*firstTextView) convertRect:(*firstTextView).bounds toView:standardView];
                if (newRect.origin.x * 0.5 + newRect.origin.y * 0.5 < oldRect.origin.x * 0.5 + oldRect.origin.y * 0.5) {
                    *firstTextView = view;
                }
            }
            
            if (!*bigTextView) {
                *bigTextView = view;
            }
            else {
                CGFloat oldFontSize = [self getFontSizeOfView:*bigTextView];
                CGFloat newFontSize = [self getFontSizeOfView:view];
                if (newFontSize > oldFontSize) {
                    *bigTextView = view;
                }
            }
        }
        else if ([wxComponent isKindOfClass:NSClassFromString(@"WXImageComponent")] || [view isKindOfClass:[UIImageView class]]) {
            [imageViews prism_addObject:view];
        }
        [allSubviews addObjectsFromArray:view.subviews];
    }
    [self recursiveSubviewsWithViews:[allSubviews copy] standardView:standardView firstTextView:firstTextView bigTextView:bigTextView imageViews:imageViews count:count];
}

+ (CGFloat)getFontSizeOfView:(UIView*)view {
    CGFloat fontSize = 0;
    id wxComponent = [view prism_wxComponent];
    if ([wxComponent isKindOfClass:NSClassFromString(@"WXTextComponent")]) {
        NSString *fontSizeString = [[wxComponent valueForKey:@"styles"] valueForKey:@"fontSize"];
        if ([fontSizeString isKindOfClass:[NSString class]] && fontSizeString.length) {
            fontSize = fontSizeString.floatValue;
        }
    }
    else if ([view isKindOfClass:[UILabel class]]) {
        fontSize = ((UILabel*)view).font.pointSize;
    }
    return fontSize;
}

#pragma mark - setters

#pragma mark - getters

@end
