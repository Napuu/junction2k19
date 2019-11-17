//
//  WelcomeViewController.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-15.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class AnimalsIntroViewController: SlideshowContentViewController {
	let titleLabel = UILabel()
	let subtitleStackView = UIStackView()
	let mapButton = BigButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		titleLabel.text = "Gotta see those reindeer"
		let subtitleTexts = [
			"If there's a specific Finnish wild animal you",
			"wish to see, the app can help you with that too!",
			"The best animal spotting locations are marked on the map.",
			" ",
			"The typical weather conditions are displayed as well to",
			"help you pack appropriately."
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
		
		mapButton.backgroundColor = .white
		mapButton.setTitleColor(.black, for: .normal)
		mapButton.setTitle("Get started", for: .normal)
		mapButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
		mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
		
		[titleLabel, subtitleStackView, mapButton].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
			
			subtitleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			subtitleStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			
			mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			mapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160)
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
	
	@objc private func mapButtonPressed() {
		let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
		window?.rootViewController = MapViewController()
	}
}
