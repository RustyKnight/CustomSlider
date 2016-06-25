//
//  SlideTo.swift
//  CustomSlider
//
//  Created by Shane Whitehead on 25/06/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class SlideTo: UISlider {

	@IBInspectable var trackGap = 8.0 {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	@IBInspectable var image: UIImage? {
		didSet {
			setThumbImage(image, for: [])
		}
	}
	
	var cgTrackGap: CGFloat {
		return CGFloat(trackGap)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override var bounds: CGRect {
		didSet {
			layer.cornerRadius = bounds.height / 2.0
		}
	}
	
	override func intrinsicContentSize() -> CGSize {
		let diameter = CGFloat(5.0)
		var height = diameter + (cgTrackGap * 2.0)
		var width = diameter * 3 + (cgTrackGap * 2.0)
		if let image = currentThumbImage {
			height = max(image.size.height + (cgTrackGap * 2.0),
			             height)
			width = max(image.size.width + (cgTrackGap * 2) * 3,
			            width)
		}
		return CGSize(width: width, height: height)
	}
	
	override func trackRect(forBounds bounds: CGRect) -> CGRect {
		var height = CGFloat(5.0)
		if let image = currentThumbImage {
			height = max(image.size.height + CGFloat((trackGap * 2.0)),
			             height)
		}
		let customBounds = CGRect(origin: bounds.origin,
		                          size: CGSize(width: bounds.size.width,
		                                       height: height))
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
		
		let height = bounds.size.height - CGFloat(trackGap * 2)
		
		let y = CGFloat(trackGap)
		
		let subTrack = CGRect(x: rect.origin.x + CGFloat(trackGap * 2),
		                      y: y,
		                      width: rect.width - (CGFloat(trackGap * 2) * 2.0),
		                      height: height)
		
		return super.thumbRect(forBounds: bounds, trackRect: subTrack, value: value)
	}

}
