//
//  FirstViewManager.swift
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

@objc(FirstViewManager)
class FirstViewManager: RCTViewManager {
  override func view() -> UIView! {
    return FirstView()
  }
  
  // this is required since RN 0.49+
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  @objc func updateFromManager(_ node: NSNumber, count: NSNumber) {
    DispatchQueue.main.async {
      let component = self.bridge.uiManager.view(
        forReactTag: node
      ) as! FirstView
      component.update(value: count)
    }
  }
}

