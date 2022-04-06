//
//  PrismInstructionDefines.h
//  DiDiPrism
//
//  Created by hulk on 2020/4/16.
//

#ifndef PrismInstructionDefines_h
#define PrismInstructionDefines_h

// 基础标识
#define kFragmentFlag @"_^_"
#define kConnectorFlag @"_&_"
#define kDictionaryKeyPrefix @"prism-"
#define kViewMotionFlag @"vm"
#define kViewPathFlag @"vp"
#define kViewTreeFlag @"vt"
#define kViewListFlag @"vl"
#define kViewQuadrantFlag @"vq"
#define kViewRepresentativeContentFlag @"vr"
#define kEventFlag @"e"
#define kViewFunctionFlag @"vf"
#define kH5ViewFlag @"h5"

// 片段类型标识
#define kBeginOfViewMotionFlag [NSString stringWithFormat:@"%@%@", kViewMotionFlag, kConnectorFlag]
#define kBeginOfViewPathFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewPathFlag, kConnectorFlag]
#define kBeginOfViewTreeFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewTreeFlag, kConnectorFlag]
#define kBeginOfViewListFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewListFlag, kConnectorFlag]
#define kBeginOfViewQuadrantFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewQuadrantFlag, kConnectorFlag]
#define kBeginOfViewRepresentativeContentFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewRepresentativeContentFlag, kConnectorFlag]
#define kBeginOfEventFlag [NSString stringWithFormat:@"%@%@", kEventFlag, kConnectorFlag]
#define kBeginOfViewFunctionFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewFunctionFlag, kConnectorFlag]
#define kBeginOfH5Flag [NSString stringWithFormat:@"%@%@", kH5ViewFlag, kConnectorFlag]

// 通用事件标识
#define kUIApplicationOpenURL [NSString stringWithFormat:@"%@[UIApplication]_OpenURL", kBeginOfEventFlag]
#define kUIApplicationInit [NSString stringWithFormat:@"%@[UIApplication]_Init", kBeginOfEventFlag]
#define kUIApplicationJump [NSString stringWithFormat:@"%@[UIApplication]_Jump", kBeginOfEventFlag]
#define kUIApplicationBecomeActive [NSString stringWithFormat:@"%@[UIApplication]_BecomeActive", kBeginOfEventFlag]
#define kUIApplicationResignActive [NSString stringWithFormat:@"%@[UIApplication]_ResignActive", kBeginOfEventFlag]
#define kUIViewControllerDidAppear [NSString stringWithFormat:@"%@[UIViewController]_DidAppear", kBeginOfEventFlag]


// View Motion具体标识
#define kViewMotionControlFlag @"control"
#define kViewMotionEdgePanGestureFlag @"edgePanGesture"
#define kViewMotionTapGestureFlag @"tapGesture"
#define kViewMotionLongPressGestureFlag @"longPressGesture"
#define kViewMotionCellFlag @"cell"
#define kViewMotionTextFieldBFRFlag @"textFieldBFR"
#define kViewMotionTextFieldRFRFlag @"textFieldRFR"


// View RepresentativeContent
#define kViewRepresentativeContentTypeText @"[_text]"
#define kViewRepresentativeContentTypeLocalImage @"[_l_image]"
#define kViewRepresentativeContentTypeNetworkImage @"[_n_image]"
#endif /* PrismInstructionDefines_h */
