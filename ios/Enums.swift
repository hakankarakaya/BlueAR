//
//  Enums.swift
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

enum SurfaceType: String, CaseIterable {
  case Horizontal = "Horizontal"
  case Vertical = "Vertical"
  case Hand = "Hand"
  case None = "None"
  
  var reactEnumString : String {
    switch self {
    case .Horizontal: return "Horizontal"
    case .Vertical: return "Vertical"
    case .Hand: return "Hand"
    case .None: return "None"
    }
  }
}
