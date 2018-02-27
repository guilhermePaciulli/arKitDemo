//
//  SetPinLocationARViewController.swift
//  ARKitNanoChallenge
//
//  Created by Guilherme Paciulli on 26/02/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class SetPinLocationARViewController: UIViewController {
    
    var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = self.view as! ARSCNView
        
        self.sceneView.delegate = self
        self.sceneView.showsStatistics = true
        
        let scene = SCNScene()
        self.sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        self.sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sceneView.session.pause()
    }

}


extension SetPinLocationARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let sphere = SCNSphere(radius: CGFloat(planeAnchor.extent.x) / 3)
        sphere.materials.first?.diffuse.contents = UIColor.blue
        
//        let sphere

        
    }
    
}
