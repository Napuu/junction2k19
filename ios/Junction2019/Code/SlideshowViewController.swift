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
	let secondViewController = VisitorsIntroViewController()
	let thirdViewController = AnimalsIntroViewController()
	
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
		
		let pageView: UIView = pageViewController.view
		[backgroundView, effectView, pageView].forEach {
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
			pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
}

extension SlideshowViewController: UIPageViewControllerDataSource {
	private func viewControllerWithOffset(_ offset: Int, from viewController: UIViewController) -> UIViewController? {
		guard let controller = viewController as? SlideshowContentViewController,
			let index = allViewControllers.firstIndex(of: controller) else {
				assertionFailure("Unknown view controller in page controller")
				return nil
		}
		
		let count = allViewControllers.count
		let newIndex = index + offset
		if newIndex < 0 { return nil }
		if newIndex >= count { return nil }
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
