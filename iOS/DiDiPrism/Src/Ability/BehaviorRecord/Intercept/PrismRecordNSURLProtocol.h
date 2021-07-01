//
//  PrismRecordNSURLProtocol.h
//  DiDiPrism
//
//  Created by hulk on 2020/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrismRecordNSURLProtocol : NSURLProtocol
/*
 定制用于提取网络请求信息的逻辑。
 */
@property (nonatomic, strong, class) NSString*(^urlFlagPickBlock)(NSURLRequest*);
@property (nonatomic, strong, class) NSString*(^traceIdPickBlock)(NSURLRequest*);
@end

NS_ASSUME_NONNULL_END
