//
//  ProgressView.swift
//  ARSRP
//
//  Created by Avikant Saini on 7/3/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

import UIKit

class ProgressView: UIView {
	
	var timerCounter: Double = 0.0
	var maxTimerCounter: Double = 1.0
	
	func startCountingDownFor(timeInSeconds: TimeInterval) {
		timerCounter = timeInSeconds / 0.02;
		maxTimerCounter = timeInSeconds / 0.02;
		self.timerUpdate()
	}
	
	func timerUpdate() {
		self.timerCounter -= 1
		self.fillPercentage = CGFloat((self.timerCounter) / (self.maxTimerCounter))
		if (self.timerCounter > 0) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: {
				self.timerUpdate()
			})
		}
	}
	
	@IBInspectable var fillColor: UIColor = UIColor.lightGray {
		didSet {
			setNeedsDisplay()
		}
	}
	
	@IBInspectable var fillPercentage: CGFloat = 0.0 {
		didSet {
			setNeedsDisplay()
		}
	}
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
		// Drawing code
		let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: fillPercentage * self.bounds.size.width, height: self.bounds.size.height), cornerRadius: 4.0)
		fillColor.setFill()
		path.fill()
	}

}
