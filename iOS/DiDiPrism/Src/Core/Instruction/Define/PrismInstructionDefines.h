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
#define kViewMotionFlag @"vm"
#define kViewPathFlag @"vp"
#define kViewListFlag @"vl"
#define kViewQuadrantFlag @"vq"
#define kViewRepresentativeContentFlag @"vr"
#define kEventFlag @"e"
#define kViewFunctionFlag @"vf"
#define kH5ViewFlag @"h5"

// 片段类型标识
#define kBeginOfViewMotionFlag [NSString stringWithFormat:@"%@%@", kViewMotionFlag, kConnectorFlag]
#define kBeginOfViewPathFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewPathFlag, kConnectorFlag]
#define kBeginOfViewListFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewListFlag, kConnectorFlag]
#define kBeginOfViewQuadrantFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewQuadrantFlag, kConnectorFlag]
#define kBeginOfViewRepresentativeContentFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewRepresentativeContentFlag, kConnectorFlag]
#define kBeginOfEventFlag [NSString stringWithFormat:@"%@%@", kEventFlag, kConnectorFlag]
#define kBeginOfViewFunctionFlag [NSString stringWithFormat:@"%@%@%@", kFragmentFlag, kViewFunctionFlag, kConnectorFlag]
#define kBeginOfH5Flag [NSString stringWithFormat:@"%@%@", kH5ViewFlag, kConnectorFlag]

// 通用事件标识
#define kUIApplicationOpenURL [NSString stringWithFormat:@"%@[UIApplication]_OpenURL", kBeginOfEventFlag]
#define kUIApplicationBecomeActive [NSString stringWithFormat:@"%@[UIApplication]_BecomeActive", kBeginOfEventFlag]
#define kUIApplicationResignActive [NSString stringWithFormat:@"%@[UIApplication]_ResignActive", kBeginOfEventFlag]
#define kUIViewControllerDidAppear [NSString stringWithFormat:@"%@[UIViewController]_DidAppear", kBeginOfEventFlag]


// View Motion具体标识
#define kViewMotionControlFlag @"control"
#define kViewMotionEdgePanGestureFlag @"edgePanGesture"
#define kViewMotionGestureFlag @"gesture"
#define kViewMotionCellFlag @"cell"

#endif /* PrismInstructionDefines_h */
