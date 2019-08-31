//
//  FirstView.swift
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit

class FirstView: UIView {

  @objc var count: NSNumber = 0 {
    didSet {
      button.setTitle(String(describing: count), for: .normal)
    }
  }
  
  @objc var onUpdate: RCTDirectEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.addSubview(button)
    increment()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var button: UIButton = {
    let b = UIButton.init(type: UIButton.ButtonType.system)
    b.titleLabel?.font = UIFont.systemFont(ofSize: 50)
    b.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    b.addTarget(
      self,
      action: #selector(increment),
      for: .touchUpInside
    )
    let longPress = UILongPressGestureRecognizer(
      target: self,
      action: #selector(sendUpdate(_:))
    )
    b.addGestureRecognizer(longPress)
    return b
  }()

  @objc func increment() {
    count = count.intValue + 1 as NSNumber
  }
  
  @objc func sendUpdate(_ gesture: UILongPressGestureRecognizer) {
    if gesture.state == .began {
      if onUpdate != nil {
        // our Event Emitter expects [AnyHashable:Any]
        onUpdate!(["count": count])
      }
    }
  }
  
  @objc func update(value: NSNumber) {
    count = value
  }

}
