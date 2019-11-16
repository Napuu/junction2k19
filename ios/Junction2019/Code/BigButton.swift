//
//  BigButton.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-16.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class BigButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = 8
	}
	
	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + 48, height: size.height + 16)
	}
	
	override var isHighlighted: Bool {
		didSet {
			backgroundColor = backgroundColor?.withAlphaComponent(isHighlighted ? 0.8 : 1)
		}
	}
	
	required init?(coder: NSCoder) { fatalError() }
}
