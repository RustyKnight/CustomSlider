//
//  SlideTo.swift
//  CustomSlider
//
//  Created by Shane Whitehead on 25/06/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class SlideTo: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override var bounds: CGRect {
		didSet {
			layer.cornerRadius = bounds.height / 2.0
		}
	}
	
	override func trackRect(forBounds bounds: CGRect) -> CGRect {
		let customBounds = CGRect(origin: bounds.origin,
		                          size: CGSize(width: bounds.size.width, height: 50))
		super.trackRect(forBounds: customBounds)
		return customBounds
	}
	
	override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		super.endTracking(touch, with: event)
		if value < 1.0 {
			let duration: TimeInterval = Double(value) / 0.5
			UIView.animate(withDuration: duration, animations: {
				self.setValue(0.0, animated: true)
			})
		}
	}
	
	override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
		let gap = CGFloat(8.0)
		
		let subTrack = CGRect(x: rect.origin.x + gap,
		                      y: rect.origin.y + gap,
		                      width: rect.width - (gap *
														2.0), height: rect.height - (gap * 2.0))
		
		return super.thumbRect(forBounds: bounds, trackRect: subTrack, value: value)
	}

}
