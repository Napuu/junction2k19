//
//  WeatherView.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-16.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit
import Mapbox

class WeatherView: MGLAnnotationView {
	private let rainImageView = UIImageView(image: UIImage(named: "rain"))
	private let tempImageView = UIImageView(image: UIImage(named: "temperature"))
	
	private let rainLabel = UILabel()
	private let tempLabel = UILabel()
	
	func setTemperature(_ temp: Int) {
		tempLabel.text = "\(temp) °C"
		rainImageView.image = UIImage(named: temp > 0 ? "rain" : "snow")
	}
	
	func setRain(_ rain: Int) {
		rainLabel.text = "\(rain) mm"
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		[rainLabel, tempLabel].forEach {
			$0.font = .boldSystemFont(ofSize: 14)
		}
		
		layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		backgroundColor = UIColor.white.withAlphaComponent(0.6)
		layer.cornerRadius = 8
		
		[rainImageView, rainLabel, tempImageView, tempLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			rainImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			rainImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
			
			rainLabel.centerYAnchor.constraint(equalTo: rainImageView.centerYAnchor),
			rainLabel.leadingAnchor.constraint(equalTo: rainImageView.trailingAnchor, constant: 6),
			rainLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor),
			
			tempImageView.centerXAnchor.constraint(equalTo: rainImageView.centerXAnchor),
			tempImageView.topAnchor.constraint(lessThanOrEqualTo: rainImageView.bottomAnchor, constant: 4),
			tempImageView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
			
			tempLabel.centerYAnchor.constraint(equalTo: tempImageView.centerYAnchor),
			tempLabel.leadingAnchor.constraint(equalTo: rainLabel.leadingAnchor),
			tempLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor)
		])
	}
	
	required init?(coder: NSCoder) { fatalError() }
}
