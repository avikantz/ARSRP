//
//  Paper.swift
//  ARSRP
//
//  Created by Avikant Saini on 6/30/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit
import SceneKit

class Paper: SCNNode {
	
	override init () {
		super.init()
		
		let tube = SCNTube(innerRadius: 0.0222, outerRadius: 0.0224, height: 0.15)
		self.geometry = tube
		let shape = SCNPhysicsShape(geometry: tube, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false
		
		self.physicsBody?.categoryBitMask = CollisionCategory.paper.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.cube.rawValue
		
		var materials = [SCNMaterial]()
		for i in 1...2 {
			let material = SCNMaterial()
			material.diffuse.contents = UIImage(named: "paper\(i)")
			materials.append(material)
		}
		self.geometry?.materials  = materials
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
