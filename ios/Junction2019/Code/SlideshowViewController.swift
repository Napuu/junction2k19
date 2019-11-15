//
//  ViewController.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-15.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit

class SlideshowViewController: UIPageViewController {
	let firstViewController = SlideshowContentViewController()
	let secondViewController = SlideshowContentViewController()
	let thirdViewController = SlideshowContentViewController()
	
	var allViewControllers: [SlideshowContentViewController] {
		return [firstViewController, secondViewController, thirdViewController]
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		dataSource = self
		setViewControllers([firstViewController], direction: .forward, animated: false)
		
		view.subviews.forEach {
			if let scrollView = $0 as? UIScrollView {
				scrollView.delegate = self
			}
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
		for viewController in allViewControllers {
			let offset = view.convert(viewController.view.frame.origin, from: viewController.view).x
			let width = view.frame.width
			viewController.parallaxFactor = offset / width
		}
	}
}
