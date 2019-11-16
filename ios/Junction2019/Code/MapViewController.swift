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
	
	let slider = UISlider()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.layoutMargins = UIEdgeInsets(top: 64, left: 128, bottom: 80, right: 128)
	
		mapView.setCenter(CLLocationCoordinate2D(latitude: 65.4, longitude: 26.5), zoomLevel: 4.5, animated: false)
		mapView.delegate = self
		
		slider.setThumbImage(UIImage(named: "knob"), for: .normal)
		
		[mapView, slider].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mapView.topAnchor.constraint(equalTo: view.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			slider.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
		])
		
		let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap))
		for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
			singleTap.require(toFail: recognizer)
		}
		mapView.addGestureRecognizer(singleTap)
	}
	
	@objc private func handleMapTap(sender: UITapGestureRecognizer) {
		let location = sender.location(in: mapView)
		let rect = CGRect(x: location.x - 25, y: location.y - 25, width: 50, height: 50)
		let features = mapView.visibleFeatures(in: rect, styleLayerIdentifiers: ["heatmap"])
		guard let firstFeature = features.first else { return }
		
		let annotation = MGLPointAnnotation()
		annotation.coordinate = firstFeature.coordinate
		annotation.title = firstFeature.attribute(forKey: "name") as? String
		annotation.subtitle = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
		mapView.addAnnotation(annotation)
		mapView.selectAnnotation(annotation, animated: true, completionHandler: nil)
	}
}

extension MapViewController: MGLMapViewDelegate {
	func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
		let tileURLTemplates = ["http://51.144.0.238/tiles/maps/postgis/{z}/{x}/{y}.pbf"]
		let source = MGLVectorTileSource(identifier: "parks", tileURLTemplates: tileURLTemplates, options: [
			.minimumZoomLevel: 4.5,
			.maximumZoomLevel: 16
		])
		style.addSource(source)
		
		let layer = MGLFillStyleLayer(identifier: "parks", source: source)
		layer.sourceLayerIdentifier = "kansallispuisto"
		layer.fillColor = NSExpression(forConstantValue: UIColor.red.withAlphaComponent(0.3))
		style.addLayer(layer)
		
		
		let heatmapLayer = MGLHeatmapStyleLayer(identifier: "heatmap", source: source)
		heatmapLayer.sourceLayerIdentifier = "testipiste"
		
		let colors: [NSNumber: UIColor] = [
			0: .clear,
			0.5: UIColor(red: 0.73, green: 0.23, blue: 0.25, alpha: 0.8),
			0.95: UIColor.orange.withAlphaComponent(0.8),
			1: UIColor.yellow.withAlphaComponent(0.8)
		]
		let colorFormat = "mgl_interpolate:withCurveType:parameters:stops:($heatmapDensity, 'linear', nil, %@)"
		heatmapLayer.heatmapColor = NSExpression(format: colorFormat, colors)
			
		let weights = [
			0: 0,
			10: 1
		]
		let weightFormat = "mgl_interpolate:withCurveType:parameters:stops:(visits, 'linear', nil, %@)"
		heatmapLayer.heatmapWeight = NSExpression(format: weightFormat, weights)
		
		let intensities = [
			0: 1,
			9: 3
		]
		let intensityFormat = "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)"
		heatmapLayer.heatmapIntensity = NSExpression(format: intensityFormat, intensities)
		
		style.addLayer(heatmapLayer)
	}
	
	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
		return true
	}
	
	func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
		mapView.removeAnnotation(annotation)
	}
}
