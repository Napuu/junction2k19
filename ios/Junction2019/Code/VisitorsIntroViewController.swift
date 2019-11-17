//
//  WelcomeViewController.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-15.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class VisitorsIntroViewController: SlideshowContentViewController {
	let titleLabel = UILabel()
	let subtitleStackView = UIStackView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleLabel.text = "Find the best time to travel"
		let subtitleTexts = [
			"Prefer a peaceful walk in the nature",
			"over a popular tourist location?",
			"The simple heatmap lets you easily find those spots."
		]
		
		titleLabel.font = .boldSystemFont(ofSize: 40)
		titleLabel.textColor = .white
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		
		subtitleStackView.axis = .vertical
		subtitleStackView.alignment = .center
		
		subtitleTexts.forEach {
			let label = UILabel()
			label.text = $0
			label.font = .systemFont(ofSize: 24)
			label.textColor = .white
			subtitleStackView.addArrangedSubview(label)
		}
		
		[titleLabel, subtitleStackView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
			
			subtitleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			subtitleStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
		])
	}
	
	override var parallaxFactor: CGFloat {
		didSet {
			let baseOffset = parallaxFactor * 500
			titleLabel.transform = .init(translationX: baseOffset, y: 0)
			for (index, subview) in subtitleStackView.arrangedSubviews.enumerated() {
				subview.transform = .init(translationX: baseOffset * (0.8 - CGFloat(index) * 0.1), y: 0)
			}
		}
	}
}
