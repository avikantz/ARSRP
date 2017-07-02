//
//  ViewController.swift
//  ARSRP
//
//  Created by Avikant Saini on 6/30/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Toast_Swift

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
	
	@IBOutlet var sceneView: ARSCNView!
	
	@IBOutlet weak var scoreLabel: UILabel!
	
	private var score: Int = 0 {
		didSet {
			DispatchQueue.main.async {
				self.scoreLabel.text = String(self.score) + " papers published"
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		sceneView.delegate = self
		sceneView.showsStatistics = false
		
		let scene = SCNScene()
		sceneView.scene = scene
		sceneView.scene.physicsWorld.contactDelegate = self
		
		// Papers party!
		for _ in 1...10 {
			self.addNewSRPCube()
		}
		
		self.score = 0
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.configureSession()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		// Pause the view's session
		sceneView.session.pause()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Release any cached data, images, etc that aren't in use.
	}
	
	// MARK: - ARSCNViewDelegate
	
	/*
	// Override to create and configure nodes for anchors added to the view's session.
	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
	let node = SCNNode()
	
	return node
	}
	*/
	
	func session(_ session: ARSession, didFailWithError error: Error) {
		// Present an error message to the user
		print("Session failed with error: \(error.localizedDescription)")
	}
	
	func sessionWasInterrupted(_ session: ARSession) {
		// Inform the user that the session has been interrupted, for example, by presenting an overlay
		
	}
	
	func sessionInterruptionEnded(_ session: ARSession) {
		// Reset tracking and/or remove existing anchors if consistent tracking is required
		
	}
	
	// MARK: - Actions
	
	@IBAction func didTapScreen(_ sender: UITapGestureRecognizer) { // throw a paper
		let papersNode = Paper()
		
		let (direction, position) = self.getUserVector()
		papersNode.position = position
		papersNode.rotation = SCNVector4Make(floatBetween(0.5, and: 1.5), floatBetween(-0.2, and: 0.2), floatBetween(-0.4, and: 0.4), floatBetween(-1.2, and: 1.2))
		
		papersNode.physicsBody?.applyForce(direction, asImpulse: true)
		sceneView.scene.rootNode.addChildNode(papersNode)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { // remove paper after a while
			self.removeNodeWithAnimation(node: papersNode)
		})
		
	}
	
	// MARK: - Game Functionality
	
	func configureSession() {
		if ARWorldTrackingSessionConfiguration.isSupported {
			let configuration = ARWorldTrackingSessionConfiguration()
			configuration.planeDetection = ARWorldTrackingSessionConfiguration.PlaneDetection.horizontal
			sceneView.session.run(configuration)
		} else {
			let configuration = ARSessionConfiguration()
			sceneView.session.run(configuration)
		}
	}
	
	func addNewSRPCube() {
		// Too many SRPs
		if sceneView.scene.rootNode.childNodes.count > 128 {
			return
		}
		let cubeNode = SRPCube()
		let posX = floatBetween(-0.5, and: 0.5)
		let posY = floatBetween(-0.5, and: 0.5)
		cubeNode.position = SCNVector3(posX, posY, -1)
		cubeNode.rotation = SCNVector4Make(floatBetween(0.5, and: 1.5), floatBetween(-0.2, and: 0.2), floatBetween(-0.4, and: 0.4), floatBetween(-1.2, and: 1.2))
		cubeNode.opacity = 0
		sceneView.scene.rootNode.addChildNode(cubeNode)
		SCNTransaction.begin()
		SCNTransaction.animationDuration = 0.5
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
		cubeNode.opacity = 1.0
		SCNTransaction.commit()
	}
	
	func removeNodeWithAnimation(node: SCNNode) {
		DispatchQueue.main.async {
			SCNTransaction.begin()
			SCNTransaction.animationDuration = 0.3
			SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
			node.scale = SCNVector3(0, 0, 0)
			SCNTransaction.commit()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
				node.removeFromParentNode()
			})
		}
	}
	
	func getUserVector() -> (SCNVector3, SCNVector3) {
		if let frame = self.sceneView.session.currentFrame {
			let mat = SCNMatrix4FromMat4(frame.camera.transform)
			let dir = SCNVector3(-2 * mat.m31, -2 * mat.m32, -2 * mat.m33)
			let pos = SCNVector3(mat.m41, mat.m42, mat.m43)
			return (dir, pos)
		}
		return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
	}
	
	// MARK: - Contact Delegate
	
	func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
		//print("did begin contact", contact.nodeA.physicsBody!.categoryBitMask, contact.nodeB.physicsBody!.categoryBitMask)
		if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.cube.rawValue || contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.cube.rawValue {
			removeNodeWithAnimation(node: contact.nodeB) // remove paper on contact
			if contact.nodeA.isKind(of: SRPCube.self) {
				if let srpCube = contact.nodeA as? SRPCube {
//					print("Contact with: \(srpCube.title)")
					DispatchQueue.main.async {
						self.score += srpCube.score
						self.view.makeToast("Hit \(srpCube.title).", duration: 0.5, position: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height - 80), title: "+ \(srpCube.score)", image: UIImage(named: "\(srpCube.imageName)")!, style: nil, completion: nil)
					}
				}
			}
			removeNodeWithAnimation(node: contact.nodeA)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
				self.addNewSRPCube()
				self.addNewSRPCube()
			})
		}
	}
	
}

struct CollisionCategory: OptionSet {
	let rawValue: Int
	static let paper  = CollisionCategory(rawValue: 1 << 0)
	static let cube = CollisionCategory(rawValue: 1 << 1)
}

