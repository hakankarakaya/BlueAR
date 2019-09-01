//
//  ScanView.swift
//  BlueAR
//
//  Created by Hakan Karakaya on 30.08.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import UIKit
import ARKit
import Vision
import Toast_Swift

class ScanView: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var sceneView: ARSCNView!
  
  var animations = [String: CAAnimation]()
  var handDetected: Bool = false
  
  // COREML
  var visionRequests = [VNRequest]()
  let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
  
  // React Native send event
  @objc var onSurfaceDetected: RCTDirectEventBlock?
  
  // Node list
  var wallpaperArray = [SCNNode]()
  var horizontalSurfaceModelArray = [SCNNode]()
  var planetModelArray = [SCNNode]()
  var charModelArray = [SCNNode]()
  
  // Detected surface plane Anchor
  var surfacePlaneAnchor: ARPlaneAnchor?
  var surfaceNode: SCNNode?
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame);
    
    Bundle.main.loadNibNamed("ScanView", owner: self, options: nil)
    addSubview(contentView)
    
    sceneView.delegate = self
    
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    configuration.planeDetection = [.horizontal, .vertical]
    
    // Run the view's session
    sceneView.session.run(configuration)
    
    // Set up Vision Model
    setupVisionModel()
  }
  
  //MARK: - Extern Methods
  
  @objc func addHorizontalSurfaceModel(identifier id: NSString, modelURL url: NSString) {
    guard let planeAnchor = surfacePlaneAnchor else { return }
    guard let surfaceNode = surfaceNode else { return }
    
    if planeAnchor.alignment == .horizontal {
      addHorizontalSurfaceModel(surfacePlaneAnchor: planeAnchor, id: id, modelURL: url, surfaceNode: surfaceNode)
    }else{
      self.contentView.makeToast("Surface not horizontal!.", duration: 2.0, position: .center)
    }
  }
  
  @objc func addPlanetModel(identifier id: NSString, modelURL url: NSString) {
    addPlanet(id: id, modelURL: url)
  }
  
  @objc func addWallpaperTexture(identifier id: NSString, wallpaperURL: NSString) {
    guard let planeAnchor = surfacePlaneAnchor else { return }
    guard let surfaceNode = surfaceNode else { return }
    
    if planeAnchor.alignment == .vertical {
      addWallpaper(surfacePlaneAnchor: planeAnchor, surfaceNode: surfaceNode)
      
      // Download texture from url and apply all wallpapers
      let url = URL(string: wallpaperURL as String)!
      self.contentView.makeToastActivity(.center)

      getData(from: url) { data, response, error in
        guard let data = data, error == nil else {
          self.contentView.hideToastActivity()
          return
        }
        DispatchQueue.main.async() {
          for wallpaper in self.wallpaperArray {
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(data: data)
            
            wallpaper.geometry?.materials = [gridMaterial]
            
            self.contentView.hideToastActivity()
          }
        }
      }
    }else {
      self.contentView.makeToast("Surface not vertical!.", duration: 2.0, position: .center)
    }
  }
  
  @objc func addCharacterAnimation(identifier id: NSString, animationURL: NSString) {
    guard let planeAnchor = surfacePlaneAnchor else { return }
    guard let surfaceNode = surfaceNode else { return }
    
    if planeAnchor.alignment == .horizontal {
      addChar(surfacePlaneAnchor: planeAnchor, id: id, animationURL: animationURL, surfaceNode: surfaceNode)
      
    }else{
      self.contentView.makeToast("Surface not horizontal!.", duration: 2.0, position: .center)
    }
  }
  
  func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
  }
  
  // MARK: - CoreML Vision Handling
  
  func setupVisionModel() {
    guard let selectedModel = try? VNCoreMLModel(for: HandModel().model) else {
      fatalError("Could not load model.")
    }
    
    // Set up Vision-CoreML Request
    let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
    classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
    visionRequests = [classificationRequest]
    
    // Begin Loop to Update CoreML
    loopCoreMLUpdate()
  }
  
  func loopCoreMLUpdate() {
    // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
    
    dispatchQueueML.async {
      // 1. Run Update.
      self.updateCoreML()
      
      // 2. Loop this function.
      self.loopCoreMLUpdate()
    }
  }
  
  func classificationCompleteHandler(request: VNRequest, error: Error?) {
    // Catch Errors
    if error != nil {
      return
    }
    guard let observations = request.results else {
      return
    }
    
    //MARK: Object Classification
    DispatchQueue.main.async {
      guard let identifier = (observations[0] as? VNClassificationObservation)?.identifier else {return}
//      guard let confidence = (observations[0] as? VNClassificationObservation)?.confidence else {return}
      
      //MARK: if hand detected send the surface information to the react native.
      if identifier.contains("no-hand") {
        if self.onSurfaceDetected != nil {
          // Event Emitter
          self.onSurfaceDetected!(["surface": SurfaceType.None.reactEnumString])
        }
      }else {
        if self.onSurfaceDetected != nil {
          // Event Emitter
          self.onSurfaceDetected!(["surface": SurfaceType.Hand.reactEnumString])
        }
      }
    }
  }
  
  func updateCoreML() {
    // Get Camera Image as RGB
    let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
    if pixbuff == nil { return }
    let ciImage = CIImage(cvPixelBuffer: pixbuff!)
    
    // Prepare CoreML/Vision Request
    let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
    
    // Run Image Request
    do {
      try imageRequestHandler.perform(self.visionRequests)
    } catch {
      print(error)
    }
  }
  
  // MARK: - ARSCNView
  
  func addHorizontalSurfaceModel(surfacePlaneAnchor planeAnchor : ARPlaneAnchor, id: NSString, modelURL: NSString, surfaceNode: SCNNode){
    self.contentView.makeToastActivity(.center)
    
    DownloadManager.sharedInstance.getModelSCNNode(id: id, modelURL: modelURL) { (modelNode) in
      guard let node = modelNode else { return }
      
      // Remove old objects from the scene. If you don't want to remove it, convert the comment line.
      for horizontalSurfaceModel in self.horizontalSurfaceModelArray {
        horizontalSurfaceModel.removeFromParentNode()
      }
      
      // Set up some properties
      node.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
      node.scale = SCNVector3(0.02, 0.02, 0.02)
      
      surfaceNode.addChildNode(node)
      
      self.horizontalSurfaceModelArray.append(node)
      
      self.contentView.hideToastActivity()
    }
  }
  
  func addPlanet(id: NSString, modelURL: NSString){
    self.contentView.makeToastActivity(.center)

    DownloadManager.sharedInstance.getModelSCNNode(id: id, modelURL: modelURL) { (modelNode) in
      guard let node = modelNode else { return }
      
      // Remove old objects from the scene. If you don't want to remove it, convert the comment line.
      for planetModel in self.planetModelArray {
        planetModel.removeFromParentNode()
      }
      
      let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
      
      let arHitTestResults : [ARHitTestResult] = self.sceneView.hitTest(screenCentre, types: [.featurePoint])
      
      if let closestResult = arHitTestResults.first {
        // Get Coordinates of HitTest
        let transform : matrix_float4x4 = closestResult.worldTransform
        let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
        
        // Set up some properties
        node.position = worldCoord
        node.scale = SCNVector3(0.02, 0.02, 0.02)
        
        self.sceneView.scene.rootNode.addChildNode(node)
        
        self.planetModelArray.append(node)
        
        self.contentView.hideToastActivity()
      }
    }
  }
  
  func addWallpaper(surfacePlaneAnchor planeAnchor : ARPlaneAnchor, surfaceNode: SCNNode){
    
    // Remove old objects from the scene. If you don't want to remove it, convert the comment line.
    for wallpaper in self.wallpaperArray {
      wallpaper.removeFromParentNode()
    }
    
    let wallpaper = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
    
    let wallpaperNode = SCNNode()
    
    wallpaperNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
    wallpaperNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
    
    wallpaperNode.geometry = wallpaper
    
    surfaceNode.addChildNode(wallpaperNode)
    
    self.wallpaperArray.append(wallpaperNode)
  }
  
  func addChar(surfacePlaneAnchor planeAnchor : ARPlaneAnchor, id: NSString, animationURL: NSString, surfaceNode: SCNNode){
    
    // Remove old objects from the scene. If you don't want to remove it, convert the comment line.
    for charModel in self.charModelArray {
      charModel.removeFromParentNode()
    }
    
    let idleScene = SCNScene(named: "art.scnassets/idleFixed.dae")!
    
    let charNode = SCNNode()
    
    // Add all the child nodes to the parent node
    for child in idleScene.rootNode.childNodes {
      charNode.addChildNode(child)
    }
    
    // Set up some properties
    charNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
    charNode.scale = SCNVector3(0.02, 0.02, 0.02)
    
    surfaceNode.addChildNode(charNode)
    
    charModelArray.append(charNode)
    
    // Load all the DAE animations
    loadAnimation(withKey: "dancing", sceneName: "art.scnassets/twist_danceFixed", animationIdentifier: "twist_danceFixed-1")
    
    // play animation
    self.playAnimation(key: animationURL as String)
  }
  
  func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
    let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
    let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
    
    if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
      // The animation will only play once
      animationObject.repeatCount = 1
      // To create smooth transitions between animations
      animationObject.fadeInDuration = CGFloat(1)
      animationObject.fadeOutDuration = CGFloat(0.5)
      
      // Store the animation for later use
      animations[withKey] = animationObject
    }
  }
  
  func playAnimation(key: String) {
    // Add the animation to start playing it right away
    guard let animation = animations[key] else {return}
    
    sceneView.scene.rootNode.addAnimation(animation, forKey: key)
  }
  
  func stopAnimation(key: String) {
    // Stop the animation with a smooth transition
    sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
  }
  
  //MARK: - Surface Rendering Methods
  
  func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor) -> SCNNode {
    let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
    
    let planeNode = SCNNode()
    
    planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
    planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
    
    let gridMaterial = SCNMaterial()
    gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
    
    plane.materials = [gridMaterial]
    
    planeNode.geometry = plane
    
    return planeNode
  }
}

// MARK: - ARSCNViewDelegateMethods

extension ScanView: ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    //MARK: Detect surface
    guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
    
    self.surfacePlaneAnchor = planeAnchor
    
    //MARK: - Sends the surface information to the react native. React shows the suggested objects by the native side.
    if let onSurfaceDetected = self.onSurfaceDetected {
      if planeAnchor.alignment == .horizontal{
        onSurfaceDetected(["surface": SurfaceType.Horizontal.reactEnumString])
        surfaceNode = node
        // Add horizontal grid
//        let planeNode = createPlane(withPlaneAnchor: planeAnchor)
//        node.addChildNode(planeNode)
        
      }else if planeAnchor.alignment == .vertical{
        onSurfaceDetected(["surface": SurfaceType.Vertical.reactEnumString])
        surfaceNode = node
      }
    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    surfaceNode = nil
    surfacePlaneAnchor = nil
    
    if let onSurfaceDetected = self.onSurfaceDetected {
      onSurfaceDetected(["surface": SurfaceType.None.reactEnumString])
    }
  }
    
  func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
  }
}
