//
//  AnimalView.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-17.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit
import Mapbox

class AnimalView: MGLAnnotationView {
	let imageView: UIImageView
	
	override init(frame: CGRect) {
		imageView = UIImageView(frame: frame)
		
		super.init(frame: frame)
		
		imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		addSubview(imageView)
	}
	
	required init?(coder: NSCoder) { fatalError() }
}
