//
//  ViewController.swift
//  CustomSlider
//
//  Created by Shane Whitehead on 25/06/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SlideToObserver {

	@IBOutlet weak var slider: SlideTo!
	@IBOutlet weak var label: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		slider.observer = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func valueDidChange(_ sender: AnyObject) {
	}
	
	func slideTo(_ slideTo: SlideTo, didChange value: Float) {
		label.text = String(slider.value)
	}
	
	func slideTo(_ slideTo: SlideTo, didTrigger: Bool) {
		if didTrigger {
			var heightConstraint: NSLayoutConstraint? = nil
			let constraints = slider.constraints
			for constraint in constraints {
				if slider == constraint.firstItem as! NSObject ||
					slider == constraint.secondItem as? NSObject {
					if constraint.firstAttribute == .height {
						heightConstraint = constraint
						break
					}
				}
			}
			
			guard let constraint = heightConstraint else {
				return
			}
			let value = constraint.constant
			constraint.constant = 0
			UIView.animate(withDuration: 1, animations: {
				self.view.layoutIfNeeded()
				}, completion: { (_) in
					constraint.constant = value
					UIView.animate(withDuration: 0.25, animations: {
						self.view.layoutIfNeeded()
					})
			})
		}
	}

}

