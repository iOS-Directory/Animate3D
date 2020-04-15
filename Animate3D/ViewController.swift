//
//  ViewController.swift
//  Animate3D
//
//  Created by FGT MAC on 4/15/20.
//  Copyright © 2020 FGT MAC. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.automaticallyUpdatesLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        //get the image from the assets folder, inGroupNamed = folder name, bundle = location
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            
            //Set the image to be track by ARImageTrackingConfiguration
             configuration.trackingImages = imageToTrack
            
            //The max ammount of images to track from the current images in the folder, we only have one at the moment
             configuration.maximumNumberOfTrackedImages = 1

             // Run the view's session
             sceneView.session.run(configuration)
             
             print("Image found in folder.")
        }
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            // instead of hardcoding size we use the physical size detected by arKit
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height)
            
            //Make plane 1/2 as transparent alpha: 0.5
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.3)
            
            let planeNode = SCNNode(geometry: plane)
            
            //Rotate plane where the 3d image will be display 90 degrees
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            if let spidermanScene = SCNScene(named: "art.scnassets/spiderman.scn") {
                if let spiderNode = spidermanScene.rootNode.childNodes.first {
                    
                    //Rotate spiderman where the 3d image will be display on top of the plane
                    spiderNode.eulerAngles.x = .pi / 2
                    
                    planeNode.addChildNode(spiderNode)
                }
            }
        }
        return node
    }
    
    
    
}
