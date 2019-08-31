//
//  ScanViewManager.swift
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(ScanViewManager)
class ScanViewManager: RCTViewManager {
  override func view() -> UIView! {
    return ScanView()
  }
  
  // this is required since RN 0.49+
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc func addHorizontalSurfaceModel(_ node: NSNumber, identifier id: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.addHorizontalSurfaceModel(identifier: id)
    }
  }
  
  @objc func addPlanet(_ node: NSNumber, identifier id: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.addPlanet(identifier: id)
    }
  }
  
  @objc func updateWallpaperTexture(_ node: NSNumber, identifier id: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.updateWallpaperTexture(identifier: id)
    }
  }
}

