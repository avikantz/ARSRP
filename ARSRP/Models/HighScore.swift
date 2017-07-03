//
//  HighScore.swift
//  ARSRP
//
//  Created by Avikant Saini on 7/3/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit
import RealmSwift

class HighScore: Object {
	
	@objc dynamic var name = ""
	@objc dynamic var score = 0
	@objc dynamic var dateCreated = NSDate()

}

class HighScores {
	
	static func getHighScores() -> [HighScore] {
		let realm = try! Realm()
		let scores = realm.objects(HighScore.self).sorted(byKeyPath: "score", ascending: false)
		var s = Array<HighScore>()
		for k in scores {
			s.append(k)
		}
		return s
	}
	
	static func saveHighScore(name: String, score: Int) {
		let realm = try! Realm()
		let s = HighScore()
		s.name = name
		s.score = score
		s.dateCreated = NSDate()
		try! realm.write {
			realm.add(s)
		}
	}
	
}
