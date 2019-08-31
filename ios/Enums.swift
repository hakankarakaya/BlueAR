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

enum HorizontalSurfaceModel: String, CaseIterable {
  case Glass = "Glass"
  case Bottle = "Bottle"
  
  var modelSourceString : String {
    switch self {
    case .Glass: return "art.scnassets/glass.dae"
    case .Bottle: return "art.scnassets/bottle.dae"
    }
  }
  
  static func stringToHorizontalSurfaceModel(_ string: String) -> HorizontalSurfaceModel? {
    return self.allCases.first{ "\($0)".lowercased() == string.lowercased() }
  }
}

enum PlanetModel: String, CaseIterable {
  case Earth = "Earth"
  case Moon = "Moon"
  
  var modelSourceString : String {
    switch self {
    case .Earth: return "art.scnassets/earth.dae"
    case .Moon: return "art.scnassets/moon.dae"
    }
  }
  
  static func stringToPlanetModel(_ string: String) -> PlanetModel? {
    return self.allCases.first{ "\($0)".lowercased() == string.lowercased() }
  }
}
