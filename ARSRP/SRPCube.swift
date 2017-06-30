//
//  SRPCube.swift
//  ARSRP
//
//  Created by Avikant Saini on 6/30/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit
import SceneKit
import GameKit

class SRPCube: SCNNode {
	override init() {
		super.init()
		
		let box = SCNBox(width: 0.3, height: 0.3, length: 0.3, chamferRadius: 0.001)
		self.geometry = box
		let shape = SCNPhysicsShape(geometry: box, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false
		
		self.physicsBody?.categoryBitMask = CollisionCategory.cube.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.paper.rawValue
		
		var materials = [SCNMaterial]()
		for i in 1...6 {
			let material = SCNMaterial()
			material.diffuse.contents = UIImage(named: "srp\(i)")
			materials.append(material)
		}
		self.geometry?.materials  = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: materials) as! [SCNMaterial]
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

