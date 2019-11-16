//
//  MapViewController.swift
//  Junction2019
//
//  Created by Otto Otsamo on 2019-11-16.
//  Copyright © 2019 Otto Otsamo. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
	private static let mapURL = URL(string: "mapbox://styles/palikk/ck31fqa9a19se1ctd00qnx31f")
	private let mapView = MGLMapView(frame: .zero, styleURL: MapViewController.mapURL)
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		mapView.setCenter(CLLocationCoordinate2D(latitude: 65.4, longitude: 26.5), zoomLevel: 4.5, animated: false)
		
		mapView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(mapView)
		
		NSLayoutConstraint.activate([
			mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mapView.topAnchor.constraint(equalTo: view.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
}
