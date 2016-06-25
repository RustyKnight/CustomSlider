//
//  SlideTo.swift
//  CustomSlider
//
//  Created by Shane Whitehead on 25/06/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class SlideTo: UISlider {
	
	var observer: SlideToObserver?

	@IBInspectable var trackGap = 8.0 {
		didSet {
			updateThumbImage()
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	@IBInspectable var image: UIImage? {
		didSet {
			updateThumbImage()
		}
	}
	
	@IBInspectable var text: String? {
		didSet {
			textLabel.text = text
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	@IBInspectable var textColor: UIColor {
		get {
			return textLabel.textColor
		}
		set {
			textLabel.textColor = newValue
		}
	}
	
	@IBInspectable var textFont: UIFont {
		get {
			return textLabel.font
		}
		set {
			textLabel.font = newValue
			invalidateIntrinsicContentSize()
			setNeedsLayout()
			setNeedsDisplay()
		}
	}
	
	var cgTrackGap: CGFloat {
		return CGFloat(trackGap)
	}
	
	override var bounds: CGRect {
		didSet {
			layer.cornerRadius = bounds.height / 2.0
			textAnchor.constant = -bounds.height / 4.0
		}
	}
	
	internal let textLabel: UILabel = UILabel()
	internal var defaultDiameter = 5.0
	internal var textAnchor: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	internal func setup() {
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(textLabel)
		var constraints: [NSLayoutConstraint] = []
		constraints.append(NSLayoutConstraint(item: textLabel,
		                                      attribute: .centerY,
		                                      relatedBy: .equal,
		                                      toItem: self,
		                                      attribute: .centerY,
		                                      multiplier: 1.0,
		                                      constant: 0.0))
		
		textAnchor = NSLayoutConstraint(item: textLabel,
		                                attribute: .trailing,
		                                relatedBy: .equal,
		                                toItem: self,
		                                attribute: .trailing,
		                                multiplier: 1.0,
		                                constant: 0.0)
		constraints.append(textAnchor)
		
		addConstraints(constraints)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		bringSubview(toFront: textLabel)
		let count = subviews.count
		for index in stride(from: (count - 1), to: 1, by: -1) {
			exchangeSubview(at: index, withSubviewAt: index - 1)
		}
	}
	
	internal func updateThumbImage() {
		var diameter = CGFloat(defaultDiameter)
		if let image = image {
			diameter = max(image.size.width * 1.5,
			               image.size.height * 1.5)
		}
		UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter,
		                                              height: diameter),
		                                       false,
		                                       0.0)
		
		if let color = thumbTintColor {
			color.setFill()
		} else {
			UIColor.white().setFill()
		}
		let center = diameter / 2.0.cgFloat
		let path = UIBezierPath(arcCenter: CGPoint(x: center, y: center),
		                        radius: diameter / 2.0.cgFloat,
		                        startAngle: 0.0.radians.cgFloat,
		                        endAngle: 360.0.radians.cgFloat,
		                        clockwise: false)
		path.fill()
		
		if let image = image {
			let x = (diameter - (image.size.width)) / 2.0
			let y = (diameter - (image.size.height)) / 2.0
			image.draw(in: CGRect(x: x,
			                      y: y,
			                      width: image.size.width,
			                      height: image.size.height))
		}
		let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		setThumbImage(thumbImage, for: [])
		setThumbImage(thumbImage, for: .selected)
		setThumbImage(thumbImage, for: .focused)
		setThumbImage(thumbImage, for: .application)
		setThumbImage(thumbImage, for: .highlighted)
	}
	
	override func intrinsicContentSize() -> CGSize {
		let diameter = CGFloat(defaultDiameter)
		var height = diameter + (cgTrackGap * 2.0)
		var width = diameter * 3 + (cgTrackGap * 2.0)
		if let image = currentThumbImage {
			height = max(image.size.height + (cgTrackGap * 2.0),
			             height)
			width = max(image.size.width + (cgTrackGap * 2) * 3,
			            width)
		}
		if let _ = text {
			let textSize = textLabel.intrinsicContentSize()
			width += textSize.width + (diameter) + (cgTrackGap)
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
			let duration: TimeInterval = Double(value) * 0.5
			print("\(#function) \(value) ~ \(duration)")
			UIView.animate(withDuration: duration, animations: {
				self.setValue(0.0, animated: true)
			})
			if let observer = observer {
				observer.slideTo(self, didTrigger: false)
			}
		} else {
			if let observer = observer {
				observer.slideTo(self, didTrigger: true)
			}
		}
	}
	
	override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
		
		let height = bounds.size.height - CGFloat(trackGap * 2)
		
		let y = CGFloat(trackGap)
		
		let subTrack = CGRect(x: rect.origin.x + CGFloat(trackGap * 2),
		                      y: y,
		                      width: rect.width - (CGFloat(trackGap * 2) * 2.0),
		                      height: height)
		
		updateViewAlpha()
		if let observer = observer {
			observer.slideTo(self, didChange: value)
		}
		
		return super.thumbRect(forBounds: bounds, trackRect: subTrack, value: value)
	}
	
	internal func updateViewAlpha() {
		let count = subviews.count
		if count > 0 {
			for index in 0..<count - 1 {
				subviews[index].alpha = CGFloat(1.0 - Double(value))
			}
		}
	}

}

extension Double {
	var cgFloat: CGFloat { return CGFloat(self) }
}

extension FloatingPoint {
	var radians: Self { return self * .pi / 180 }
}
