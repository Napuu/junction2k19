//
//  SlideshowContentViewController.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-15.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class SlideshowContentViewController: UIViewController {
	var parallaxFactor: CGFloat = 0 {
		didSet {
			label.text = String(format: "%.2f", parallaxFactor)
		}
	}
	
	let label = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
}
