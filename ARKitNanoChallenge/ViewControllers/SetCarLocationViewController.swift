//
//  SetCarLocationViewController.swift
//  ARKitNanoChallenge
//
//  Created by Guilherme Paciulli on 27/02/18.
//  Copyright © 2018 Guilherme Paciulli. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import CoreLocation

class SetCarLocationViewController: UIViewController {
    
    @IBOutlet var arSceneView: ARSCNView!
    
    var statusLabel: UILabel!
    
    var completeButton: UIButton!
    
    var currentNode: SCNNode?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arSceneView.delegate = self
        self.addStatusLabel()
        self.setCompleteButton()
        self.getUserLocation()
        self.arSceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addPinToPlane(withGestureRecognizer:))))
    }
    
    func addStatusLabel() {
        self.statusLabel = UILabel(frame: CGRect(x: 0,
                                                 y: self.view.frame.size.height * 0.2,
                                                 width: self.view.frame.size.width,
                                                 height: self.view.frame.size.height * 0.1))
        self.statusLabel.isUserInteractionEnabled = false
        self.statusLabel.minimumScaleFactor = 0.5
        self.statusLabel.font = self.statusLabel.font.withSize(25)
        self.statusLabel.textAlignment = .center
        self.statusLabel.textColor = UIColor.white
        self.statusLabel.numberOfLines = 2
        self.statusLabel.adjustsFontSizeToFitWidth = true
        self.statusLabel.text = "Finding the floor\nMove your phone in order to find the floor"
        self.arSceneView.addSubview(self.statusLabel)
    }
    
    func setCompleteButton() {
        self.completeButton = UIButton(frame: CGRect(x: 0,
                                                     y: self.view.frame.size.height * 0.8,
                                                     width: self.view.frame.size.width,
                                                     height: self.view.frame.size.height * 0.1))
        self.completeButton.setTitle("Set pin!", for: .normal)
        self.completeButton.setTitleColor(UIColor.white, for: .normal)
        self.completeButton.titleLabel?.font = self.completeButton.titleLabel?.font.withSize(25)
        self.completeButton.titleLabel?.textAlignment = .center
        self.completeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.completeButton.titleLabel?.minimumScaleFactor = 0.5
        self.completeButton.addTarget(self, action: #selector(setPin), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arSceneView.scene = SCNScene()
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        self.arSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arSceneView.session.pause()
    }
    
    func getUserLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func setPin() {
        let location = locationManager.location!
        UserDefaults.standard.set(location, forKey: "location")
        self.dismiss(animated: true)
    }
    
    @objc func addPinToPlane(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: self.arSceneView)
        let hitTestResults = self.arSceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        
        let transform = hitTestResult.worldTransform
        let translation = SCNVector3(transform.columns.3.x,
                                     transform.columns.3.y,
                                     transform.columns.3.z)
        
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.1))
        sphere.geometry?.materials.first?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.8)
        sphere.position = SCNVector3(translation.x,
                                     translation.y + 0.1,
                                     translation.z)
        currentNode?.removeFromParentNode()
        currentNode = sphere
        self.arSceneView.scene.rootNode.addChildNode(sphere)
    }
    
}

extension SetCarLocationViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        node.removeFromParentNode()
        if self.arSceneView.scene.rootNode.childNodes.count == 0 {
            self.statusLabel.text = "Finding the floor\nMove your phone in order to find the floor"
            self.completeButton.removeFromSuperview()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor  else { return }
        
        let width = CGFloat(anchor.extent.x)
        let height = CGFloat(anchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.2)
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.simdPosition = float3(Float(anchor.center.x),
                                        Float(anchor.center.y),
                                        Float(anchor.center.z))
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
        
        self.statusLabel.text = "Floor found!\nClick inside the plane to place the pin"
        self.arSceneView.addSubview(self.completeButton)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as?  ARPlaneAnchor,
              let planeNode = node.childNodes.first,
              let plane = planeNode.geometry as? SCNPlane else { return }
        
        let width = CGFloat(anchor.extent.x)
        let height = CGFloat(anchor.extent.z)
        plane.width = width
        plane.height = height
        
        planeNode.simdPosition = float3(Float(anchor.center.x),
                                        Float(anchor.center.y),
                                        Float(anchor.center.z))
    }
    
}
