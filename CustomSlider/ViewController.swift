//
//  ViewController.swift
//  CustomSlider
//
//  Created by Shane Whitehead on 25/06/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var slider: SlideTo!
	@IBOutlet weak var label: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func valueDidChange(_ sender: AnyObject) {
		label.text = String(slider.value)
	}

}

