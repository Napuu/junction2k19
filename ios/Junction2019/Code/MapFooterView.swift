//
//  MapFooterView.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-16.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class MapFooterView: UIView {
	let sliderContainer = UIView()
	let slider = UISlider()
	let timeScaleControl = UISegmentedControl(items: ["Monthly", "Daily", "Hourly"])
	
	var timeScaleCallback: ((Int) -> Void)?
	var monthCallback: ((Int) -> Void)?
	var dayCallback: ((Int) -> Void)?
	var hourCallback: ((Int) -> Void)?
	var focusCallback: ((Double, Double, Double) -> Void)?
	var animalSwitchCallback: ((Bool) -> Void)?
	var weatherSwitchCallback: ((Bool) -> Void)?
	
	let animalSwitch = UISwitch()
	let weatherSwitch = UISwitch()
	
	let focusButton1 = BigButton()
	let focusButton2 = BigButton()
	var trailingStackView = UIStackView()
	
	let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	let dayNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
	let hours = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
				 "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		layoutMargins = UIEdgeInsets(top: 64, left: 128, bottom: 32, right: 128)
		
		let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
		effectView.isUserInteractionEnabled = true
		
		slider.setThumbImage(UIImage(named: "knob"), for: .normal)
		slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
		
		timeScaleControl.selectedSegmentIndex = 0
		timeScaleControl.addTarget(self, action: #selector(timeScaleChanged), for: .valueChanged)
		
		animalSwitch.onTintColor = .black
		if let image = UIImage(named: "animalKnob") {
			animalSwitch.thumbTintColor = UIColor(patternImage: image)
		}
		animalSwitch.addTarget(self, action: #selector(animalSwitchChanged), for: .valueChanged)
		
		weatherSwitch.onTintColor = .black
		if let image = UIImage(named: "weatherKnob") {
			weatherSwitch.thumbTintColor = UIColor(patternImage: image)
		}
		weatherSwitch.addTarget(self, action: #selector(weatherSwitchChanged), for: .valueChanged)
		
		focusButton1.setTitle("Pallas", for: .normal)
		focusButton2.setTitle("Nuuksio", for: .normal)
		
		[focusButton1, focusButton2].forEach {
			$0.backgroundColor = .white
			$0.titleLabel?.font = .boldSystemFont(ofSize: 17)
			$0.setTitleColor(.black, for: .normal)
			$0.addTarget(self, action: #selector(focusButtonPressed), for: .touchUpInside)
		}
		
		trailingStackView.spacing = 16
		trailingStackView.addArrangedSubview(focusButton1)
		trailingStackView.addArrangedSubview(focusButton2)
		
		effectView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(effectView)
		
		sliderContainer.translatesAutoresizingMaskIntoConstraints = false
		effectView.contentView.addSubview(sliderContainer)
		
		[slider, timeScaleControl, animalSwitch, weatherSwitch, trailingStackView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			effectView.contentView.addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			effectView.leadingAnchor.constraint(equalTo: leadingAnchor),
			effectView.trailingAnchor.constraint(equalTo: trailingAnchor),
			effectView.topAnchor.constraint(equalTo: topAnchor),
			effectView.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			sliderContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
			sliderContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
			sliderContainer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
			
			slider.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor, constant: -30),
			slider.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor, constant: 30),
			slider.centerYAnchor.constraint(equalTo: sliderContainer.topAnchor),
			
			timeScaleControl.centerXAnchor.constraint(equalTo: centerXAnchor),
			timeScaleControl.topAnchor.constraint(equalTo: sliderContainer.bottomAnchor, constant: 32),
			timeScaleControl.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
			timeScaleControl.heightAnchor.constraint(equalToConstant: 32),
			
			animalSwitch.centerYAnchor.constraint(equalTo: timeScaleControl.centerYAnchor),
			animalSwitch.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
			
			weatherSwitch.centerYAnchor.constraint(equalTo: animalSwitch.centerYAnchor),
			weatherSwitch.leadingAnchor.constraint(equalTo: animalSwitch.trailingAnchor, constant: 32),
			
			trailingStackView.centerYAnchor.constraint(equalTo: timeScaleControl.centerYAnchor),
			trailingStackView.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
			
			focusButton1.heightAnchor.constraint(equalTo: timeScaleControl.heightAnchor),
			focusButton2.heightAnchor.constraint(equalTo: timeScaleControl.heightAnchor),
		])
		
		setupSliderSteps()
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	private func setupSliderSteps() {
		let count: Int
		let values: [String]
		switch timeScaleControl.selectedSegmentIndex {
		case 0:
			count = 12
			values = monthNames
		case 1:
			count = 7
			values = dayNames
		default:
			count = 24
			values = hours
		}
		
		sliderContainer.subviews.forEach { $0.removeFromSuperview() }
		for i in 0..<count {
			let line = UIView()
			line.backgroundColor = .lightGray
			
			let label = UILabel()
			label.font = .boldSystemFont(ofSize: 17)
			label.text = values[i]
			
			[line, label].forEach {
				$0.translatesAutoresizingMaskIntoConstraints = false
				sliderContainer.insertSubview($0, belowSubview: slider)
			}
			
			NSLayoutConstraint.activate([
				line.widthAnchor.constraint(equalToConstant: 1),
				line.topAnchor.constraint(equalTo: slider.centerYAnchor, constant: 1.5),
				line.heightAnchor.constraint(equalToConstant: 42),
				
				label.centerXAnchor.constraint(equalTo: line.centerXAnchor),
				label.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 16),
				label.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor)
			])
			
			NSLayoutConstraint(
				item: line,
				attribute: .centerX,
				relatedBy: .equal,
				toItem: sliderContainer,
				attribute: .trailing,
				multiplier: max(0.001, CGFloat(i) * 1.0 / CGFloat(count - 1)),
				constant: 0
			).isActive = true
		}
	}
	
	@objc private func timeScaleChanged(_ control: UISegmentedControl) {
		timeScaleCallback?(control.selectedSegmentIndex)
		slider.value = 0
		sliderValueChanged(slider)
		setupSliderSteps()
	}
	
	@objc private func sliderValueChanged(_ slider: UISlider) {
		if timeScaleControl.selectedSegmentIndex == 0 {
			monthCallback?(Int((slider.value * 11).rounded()))
		} else if timeScaleControl.selectedSegmentIndex == 1 {
			dayCallback?(Int((slider.value * 6).rounded()))
		} else if timeScaleControl.selectedSegmentIndex == 2 {
			hourCallback?(Int((slider.value * 23).rounded()))
		}
	}
	
	@objc private func focusButtonPressed(_ sender: UIButton) {
		if sender == focusButton1 {
			focusCallback?(67.9, 24.0, 8)
		} else if sender == focusButton2 {
			focusCallback?(60.3, 24.5, 11)
		}
	}
	
	@objc private func animalSwitchChanged(_ sender: UISwitch) {
		animalSwitchCallback?(sender.isOn)
	}
	
	@objc private func weatherSwitchChanged(_ sender: UISwitch) {
		weatherSwitchCallback?(sender.isOn)
	}
}
