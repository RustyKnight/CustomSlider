//
//  SlideToOnserver.swift
//  CustomSlider
//
//  Created by Shane Whitehead on 26/06/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

protocol SlideToObserver {
	func slideTo(_ slidTo: SlideTo, didChange value: Float)
	func slideTo(_ slideTo: SlideTo, didTrigger: Bool)
}
