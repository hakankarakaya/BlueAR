//
//  ScanViewManager.m
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "React/RCTViewManager.h"

// the component will be exposed as "ScanView"
@interface RCT_EXTERN_MODULE(ScanViewManager, RCTViewManager)

//RCT_EXPORT_VIEW_PROPERTY(count, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(onSurfaceDetected, RCTDirectEventBlock)

// all id arguments are required to be marked as "nonnull"
RCT_EXTERN_METHOD(addHorizontalSurfaceModel:(nonnull NSNumber *)node identifier:(nonnull NSString *)identifier)
RCT_EXTERN_METHOD(addPlanet:(nonnull NSNumber *)node identifier:(nonnull NSString *)identifier)
RCT_EXTERN_METHOD(updateWallpaperTexture:(nonnull NSNumber *)node identifier:(nonnull NSString *)identifier)

@end
