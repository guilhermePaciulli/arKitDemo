//
//  FindCarViewController.swift
//  ARKitNanoChallenge
//
//  Created by Guilherme Paciulli on 27/02/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation
import SceneKit

class FindCarViewController: UIViewController {
    
    var sceneLocationView = SceneLocationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneLocationView.run()
        view.addSubview(sceneLocationView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let location = Location.shared.get()
        let carLocationNode = LocationNode(location: location)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: carLocationNode)
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.1))
        sphere.geometry?.materials.first?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.8)
        sphere.position = carLocationNode.position
        carLocationNode.addChildNode(sphere)
    }

}
