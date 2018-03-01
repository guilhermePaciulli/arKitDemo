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
        let node = LocationNode(location: location)
        let pin = SCNScene(named: "art.scnassets/pin.dae")!.rootNode.childNode(withName: "pin", recursively: true)!
        pin.scale = SCNVector3(pin.scale.x * 0.15,
                               pin.scale.y * 0.15,
                               pin.scale.z * 0.15)
        node.addChildNode(pin)
        self.sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
    }

}
