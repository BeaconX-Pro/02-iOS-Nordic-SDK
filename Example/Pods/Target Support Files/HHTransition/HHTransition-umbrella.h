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

#import "HHBaseAnimatedTransition.h"
#import "HHInteractionDelegate.h"
#import "HHInteractionDrawerTransition.h"
#import "HHInteractionFlipTransition.h"
#import "HHInteractionMotionTransition.h"
#import "HHInteractionTiltedTransition.h"
#import "HHInteractionTopBackTransition.h"
#import "HHPresentBackScaleTransition.h"
#import "HHPresentCircleTransition.h"
#import "HHPresentErectedTransition.h"
#import "HHPresentFlipTransition.h"
#import "HHPresentSystemTransition.h"
#import "HHPresentTiltedTransition.h"
#import "HHTransition.h"
#import "HHTransitioningDelegate.h"
#import "HHTransitionUtility.h"
#import "UIView+HHTransition.h"
#import "UIViewController+HHTransition.h"
#import "UIViewController+HHTransitionProperty.h"

FOUNDATION_EXPORT double HHTransitionVersionNumber;
FOUNDATION_EXPORT const unsigned char HHTransitionVersionString[];

