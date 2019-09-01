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
  
  @objc func addHorizontalSurfaceModel(_ node: NSNumber, identifier: NSString, modelURL: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.addHorizontalSurfaceModel(identifier: identifier, modelURL: modelURL)
    }
  }
  
  @objc func addPlanetModel(_ node: NSNumber, identifier id: NSString, modelURL: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.addPlanetModel(identifier: id, modelURL: modelURL)
    }
  }
  
  @objc func addWallpaperTexture(_ node: NSNumber, identifier id: NSString, wallpaperURL: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.addWallpaperTexture(identifier: id, wallpaperURL: wallpaperURL)
    }
  }
  
  @objc func addCharacterAnimation(_ node: NSNumber, identifier id: NSString, animationURL: NSString) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! ScanView
      component.addCharacterAnimation(identifier: id, animationURL: animationURL)
    }
  }
}

