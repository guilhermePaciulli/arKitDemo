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
        
        let annotationNode = LocationAnnotationNode(location: Location.shared.get(),
                                                    image: UIImage(named: "circlePin.png")!)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }

}
