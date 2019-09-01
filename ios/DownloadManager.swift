//
//  DownloadManager.swift
//  BlueAR
//
//  Created by Hakan Karakaya on 1.09.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import Alamofire
import ZIPFoundation
import SceneKit

class DownloadManager: NSObject {
  let modelsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  
  // Create a singleton instance
  static let sharedInstance: DownloadManager = { return DownloadManager() }()
  
  //MARK: Get model SCNNode
  func getModelSCNNode(id: NSString, modelURL zipURL: NSString, completion: @escaping (SCNNode?) -> Void) {
    // Check that assets for that model are not already downloaded
    let fileManager = FileManager.default
    let dirForModel = modelsDirectory.appendingPathComponent(id as String)
    let dirExists = fileManager.fileExists(atPath: dirForModel.path)
    if dirExists {
      completion(loadModelFromDisk(id as String))
    } else {
      downloadZipFromURL(from: zipURL as String, at: id as String) {
        if let url = $0 {
          print("Downloaded and unzipped at: \(url.absoluteString)")
          completion(self.loadModelFromDisk(id as String))
        } else {
          print("Download Error!")
          completion(nil)
        }
      }
    }
  }
  
  // MARK: If model is exist return model SCNNode
  func loadModelFromDisk(_ id: String) -> SCNNode? {
    let fileManager = FileManager.default
    let dirForModel = modelsDirectory.appendingPathComponent(id)
    do {
      let files = try fileManager.contentsOfDirectory(atPath: dirForModel.path)
      if let objFile = files.first(where: { $0.hasSuffix(".obj") }) {
        let objScene = try? SCNScene(url: dirForModel.appendingPathComponent(objFile), options: nil)
        let objNode = SCNNode()
        guard let childNodes = objScene?.rootNode.childNodes else {return nil}
        
        // Apply to model if material exists
        if let mtlFile = files.first(where: { $0.hasSuffix(".mtl") }) {
          if let imageData = try? Data(contentsOf: dirForModel.appendingPathComponent(mtlFile)) {
              let material = SCNMaterial()
              material.diffuse.contents = UIImage(data: imageData)
              
              objNode.geometry?.materials = [material]
          }
        }
        
        for child in childNodes {
          objNode.addChildNode(child)
        }
        return objNode
      } else {
        print("No obj file in directory: \(dirForModel.path)")
        return nil
      }
    } catch {
      print("Could not enumarate files or load scene: \(error)")
      return nil
    }
  }
  
  // MARK: Download the zip file containing the model and texture
  func downloadZipFromURL(from zipURL: String, at destFileName: String, completion: ((URL?) -> Void)?) {
    print("Downloading \(zipURL)")
    let fullDestName = destFileName + ".zip"
    
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
      let fileURL = self.modelsDirectory.appendingPathComponent(fullDestName)
      return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    Alamofire.download(zipURL, to: destination).response { response in
      let error = response.error
      if error == nil {
        if let filePath = response.destinationURL?.path {
          let filePathString = NSString(string: filePath)
          let id = NSString(string: filePathString.lastPathComponent).deletingPathExtension
          
          print("File downloaded at: \(filePath)")
          
          let fileManager = FileManager()
          let sourceURL = URL(fileURLWithPath: filePath)
          var destinationURL = self.modelsDirectory
          destinationURL.appendPathComponent(id)
          do {
            try fileManager.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
            try fileManager.unzipItem(at: sourceURL, to: destinationURL)
            completion?(destinationURL)
          } catch {
            completion?(nil)
            print("Extraction error: \(error)")
          }
        } else {
          completion?(nil)
          print("File path not found")
        }
      } else {
        // Handle error
        completion?(nil)
      }
    }
  }
}


