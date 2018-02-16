//
//  SRPManager.swift
//  ARSRP
//
//  Created by Avikant Saini on 7/2/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit
import CSV

func floatBetween(_ first: Float,  and second: Float) -> Float {
	return (Float(arc4random()) / Float(UInt32.max)) * (first - second) + second
}

class SRPItem: NSObject {
	var score: Int = 0
	var imageName: String = ""
	var title: String = ""
	init(score: Int, imageName: String, title: String) {
		super.init()
		self.score = score
		self.imageName = imageName
		self.title = title
	}
}

class SRPManager: NSObject {
	
	static let sharedManager = SRPManager()
	
	var items = Array<SRPItem>()
	
	override init() {
		if let stream = InputStream(fileAtPath: Bundle.main.path(forResource: "srps", ofType: "csv")!) {
			let csv = try! CSVReader(stream: stream)
			while let row = csv.next() {
				if let score = Int(row[2]) {
					let item = SRPItem(score: score, imageName: row[0], title: row[1])
					items.append(item)
				}
			}
		} else {
			print("Unable to load stream")
		}
		items.sort { (item1, item2) -> Bool in
			return (item1.score < item2.score)
		}
	}
	
	class func getRandomSRPItem () -> SRPItem {
		var rand = floatBetween(0.0, and: 1.0)
		rand *= rand
		let index = Int(rand * Float(sharedManager.items.count))
//		print("random float sq: \(rand), index: \(index)")
		return sharedManager.items[index]
	}

}
