//
//  PrismInstructionContentUtil.m
//  DiDiPrism
//
//  Created by hulk on 2020/5/7.
//

#import "PrismInstructionContentUtil.h"
#import "PrismInstructionDefines.h"
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
    // 原生实现
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel*)view;
        if (label.text.length) {
            return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, label.text];
        }
    }
    // ReactNative实现
    if ([view isKindOfClass:NSClassFromString(@"RCTParagraphComponentView")]) {
        if ([view respondsToSelector:@selector(attributedText)]) {
            NSAttributedString *attributedString = [view performSelector:@selector(attributedText)];
            if ([attributedString isKindOfClass:[NSAttributedString class]] && attributedString.length) {
                return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, [attributedString string]];
            }
        }
    }
    // WEEX实现
    id wxComponent = [view prism_wxComponent];
    if ([wxComponent isKindOfClass:NSClassFromString(@"WXTextComponent")]) {
        NSString *text = [wxComponent valueForKey:@"text"];
        if ([text isKindOfClass:[NSString class]] && text.length) {
            return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeText, text];
        }
    }
    // 原生实现 及 ReactNative实现
    if ([view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)view;
        SEL sd_selector = NSSelectorFromString(@"sd_imageURL");
        if (imageView.image.prismAutoDotImageName.length) {
            return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeLocalImage, imageView.image.prismAutoDotImageName];
        }
        else if (imageView.image.prismAutoDotImageUrl.length) {
            return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeNetworkImage, imageView.image.prismAutoDotImageUrl];
        }
        else if ([imageView respondsToSelector:sd_selector]) {
            NSURL *imageUrl = [imageView performSelector:sd_selector];
            if ([imageUrl isKindOfClass:[NSURL class]] && imageUrl.absoluteString.length) {
                return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeNetworkImage, imageUrl.absoluteString];
            }
        }
    }
    // WEEX实现
    if ([wxComponent isKindOfClass:NSClassFromString(@"WXImageComponent")]) {
        NSString *src = [[wxComponent valueForKey:@"attributes"] valueForKey:@"src"];
        if ([src isKindOfClass:[NSString class]] && src.length) {
            return [NSString stringWithFormat:@"%@%@", kViewRepresentativeContentTypeNetworkImage, src];
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
            [functionName appendString:firstText];
        }
    }
    if (bigTextView && bigTextView != firstTextView) {
        NSString *bigText = [self getRepresentativeContentOfView:bigTextView needRecursive:NO];
        if (bigText.length) {
            if (functionName.length) {
                [functionName appendString:@"_&_"];
            }
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
        BOOL viewHasTapGesture = NO;
        for (UIGestureRecognizer *gesture in [view gestureRecognizers]) {
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                viewHasTapGesture = YES;
                break;
            }
        }
        
        id wxComponent = [view prism_wxComponent];
        if ([view isKindOfClass:[UILabel class]] ||
            [view isKindOfClass:NSClassFromString(@"RCTParagraphComponentView")] ||
            [wxComponent isKindOfClass:NSClassFromString(@"WXTextComponent")]) {
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
        else if ([view isKindOfClass:[UIImageView class]] || [wxComponent isKindOfClass:NSClassFromString(@"WXImageComponent")]) {
            [imageViews prism_addObject:view];
        }
        else if (view.userInteractionEnabled && ([view isKindOfClass:[UIButton class]] || viewHasTapGesture)) {
            // 不提取可交互view的信息，避免混淆。
            continue;
        }
        [allSubviews addObjectsFromArray:view.subviews];
    }
    [self recursiveSubviewsWithViews:[allSubviews copy] standardView:standardView firstTextView:firstTextView bigTextView:bigTextView imageViews:imageViews count:count];
}

+ (CGFloat)getFontSizeOfView:(UIView*)view {
    CGFloat fontSize = 0;
    // WEEX实现
    id wxComponent = [view prism_wxComponent];
    if ([wxComponent isKindOfClass:NSClassFromString(@"WXTextComponent")]) {
        NSString *fontSizeString = [[wxComponent valueForKey:@"styles"] valueForKey:@"fontSize"];
        if ([fontSizeString isKindOfClass:[NSString class]] && fontSizeString.length) {
            fontSize = fontSizeString.floatValue;
        }
    }
    // 原生实现
    else if ([view isKindOfClass:[UILabel class]]) {
        fontSize = ((UILabel*)view).font.pointSize;
    }
    // ReactNative实现
    else if ([view isKindOfClass:NSClassFromString(@"RCTParagraphComponentView")]) {
        if ([view respondsToSelector:@selector(attributedText)]) {
            NSAttributedString *attributedString = [view performSelector:@selector(attributedText)];
            if ([attributedString isKindOfClass:[NSAttributedString class]] && attributedString.length) {
                UIFont *font = [[attributedString attributesAtIndex:0 effectiveRange:nil] prism_objectForKey:NSFontAttributeName];
                return font.pointSize;
            }
        }
    }
    return fontSize;
}

#pragma mark - setters

#pragma mark - getters

@end
