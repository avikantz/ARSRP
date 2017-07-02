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
	
	var score: Int = 0
	var title: String = ""
	var imageName: String = ""
	
	override init() {
		
		super.init()
		
		let item = SRPManager.getRandomSRPItem()
		let dim = CGFloat(0.06 * Float(6 - item.score));
		let box = SCNBox(width: dim, height: dim, length: dim, chamferRadius: 0.001)
		self.geometry = box
		let shape = SCNPhysicsShape(geometry: box, options: nil)
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
		self.physicsBody?.isAffectedByGravity = false
		
		self.physicsBody?.categoryBitMask = CollisionCategory.cube.rawValue
		self.physicsBody?.contactTestBitMask = CollisionCategory.paper.rawValue
		
		var materials = [SCNMaterial]()
		let material = SCNMaterial()
		material.diffuse.contents = UIImage(named: item.imageName)
		for _ in 1...6 {
			materials.append(material)
		}
		self.geometry?.materials  = materials
		
		self.score = item.score
		self.title = item.title
		self.imageName = item.imageName
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

