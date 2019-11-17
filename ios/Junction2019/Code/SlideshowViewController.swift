//
//  ViewController.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-15.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class SlideshowViewController: UIViewController {
	let backgroundView = UIImageView(image: UIImage(named: "background"))
	let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
	let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	
	let firstViewController = WelcomeViewController()
	let secondViewController = WelcomeViewController()
	let thirdViewController = WelcomeViewController()
	
	let mapButton = BigButton()
	
	var allViewControllers: [SlideshowContentViewController] {
		return [firstViewController, secondViewController, thirdViewController]
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		backgroundView.contentMode = .scaleAspectFill
		
		pageViewController.dataSource = self
		pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false)
		
		pageViewController.view.subviews.forEach {
			if let scrollView = $0 as? UIScrollView {
				scrollView.delegate = self
			}
		}
		
		mapButton.backgroundColor = .white
		mapButton.setTitleColor(.black, for: .normal)
		mapButton.setTitle("Get started", for: .normal)
		mapButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
		mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
		
		let pageView: UIView = pageViewController.view
		[backgroundView, effectView, pageView, mapButton].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
			backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			
			effectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			effectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			effectView.topAnchor.constraint(equalTo: view.topAnchor),
			effectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			pageView.topAnchor.constraint(equalTo: view.topAnchor),
			pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			mapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
		])
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		pageViewController.view.layoutIfNeeded()
		updateParallaxFactor()
	}
	
	func updateParallaxFactor() {
		for viewController in allViewControllers {
			let offset = view.convert(viewController.view.frame.origin, from: viewController.view).x
			let width = view.frame.width
			viewController.parallaxFactor = offset / width
		}
	}
	
	@objc private func mapButtonPressed() {
		let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
		window?.rootViewController = MapViewController()
	}
}

extension SlideshowViewController: UIPageViewControllerDataSource {
	private func viewControllerWithOffset(_ offset: Int, from viewController: UIViewController) -> UIViewController? {
		guard let controller = viewController as? SlideshowContentViewController,
			let index = allViewControllers.firstIndex(of: controller) else {
				assertionFailure("Unknown view controller in page controller")
				return nil
		}
		
		let count = allViewControllers.count
		var newIndex = index + offset
		while newIndex < 0 { newIndex += count }
		while newIndex >= count { newIndex -= count }
		return allViewControllers[newIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		viewControllerWithOffset(1, from: viewController)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		viewControllerWithOffset(-1, from: viewController)
	}
}

extension SlideshowViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		updateParallaxFactor()
	}
}
