#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JSONModel.h"
#import "JSONModelClassProperty.h"
#import "JSONModelError.h"
#import "JSONModelLib.h"
#import "JSONAPI.h"
#import "JSONHTTPClient.h"
#import "JSONModel+networking.h"
#import "JSONKeyMapper.h"
#import "JSONValueTransformer.h"

FOUNDATION_EXPORT double JSONModelVersionNumber;
FOUNDATION_EXPORT const unsigned char JSONModelVersionString[];

