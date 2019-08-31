//
//  FirstViewManager.m
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "React/RCTViewManager.h"

// the component will be exposed as "FirstView"
// if the name ends with "Manager" it will be stripped by React Native
@interface RCT_EXTERN_MODULE(FirstViewManager, RCTViewManager)
// or, we could also rename it ourselves
//@interface RCT_EXTERN_REMAP_MODULE(FirstView, FirstViewManager, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(count, NSNumber)

// the type could also be "RCTBubblingEventBlock", but the difference is not explained anywhere
// the name must begin with lowercase "on"
RCT_EXPORT_VIEW_PROPERTY(onUpdate, RCTDirectEventBlock)

// all NSNumber arguments are required to be marked as "nonnull"
RCT_EXTERN_METHOD(updateFromManager:(nonnull NSNumber *)node count:(nonnull NSNumber *)count)

@end
