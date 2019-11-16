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
	
	var heatmapLayers = [MGLHeatmapStyleLayer]()
	
	let sliderStepsView = MapFooterView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		mapView.setCenter(CLLocationCoordinate2D(latitude: 65.4, longitude: 26.5), zoomLevel: 4.5, animated: false)
		mapView.delegate = self
		
		sliderStepsView.sliderCallback = { [weak self] value in
			guard let self = self else { return }
			let month = Int((value * 11).rounded())
			for (index, heatmapLayer) in self.heatmapLayers.enumerated() {
				heatmapLayer.heatmapOpacity = NSExpression(forConstantValue: 1 - min(1, abs(Double(month - index))))
			}
		}
		
		sliderStepsView.focusCallback = { [weak self] lat, lon, zoom in
			guard let self = self else { return }
			self.mapView.setCenter(CLLocationCoordinate2D(latitude: lat, longitude: lon), zoomLevel: zoom, animated: true)
		}
		
		[mapView, sliderStepsView].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview($0)
		}
		
		NSLayoutConstraint.activate([
			mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			mapView.topAnchor.constraint(equalTo: view.topAnchor),
			mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			
			sliderStepsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			sliderStepsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			sliderStepsView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
	
	private func addAreaLayer(to style: MGLStyle, source: MGLSource) {
		let layer = MGLFillStyleLayer(identifier: "parks", source: source)
		layer.sourceLayerIdentifier = "kansallispuisto"
		layer.fillColor = NSExpression(forConstantValue: UIColor.red.withAlphaComponent(0.3))
		style.addLayer(layer)
	}
	
	private func addHeatmapLayers(to style: MGLStyle, source: MGLSource) {
		heatmapLayers.removeAll()
		
		for i in 0...11 {
			let heatmapLayer = MGLHeatmapStyleLayer(identifier: "heatmap\(i)", source: source)
			heatmapLayer.sourceLayerIdentifier = "monthly\(i + 1)"
			heatmapLayer.heatmapOpacity = NSExpression(forConstantValue: i == 0 ? 1 : 0)
			
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
				1000: 0.1,
				20000: 1
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
			heatmapLayers.append(heatmapLayer)
		}
	}
	
	private func addPathLayer(to style: MGLStyle, source: MGLSource) {
		let layer = MGLLineStyleLayer(identifier: "path", source: source)
		layer.sourceLayerIdentifier = "polku"
		layer.lineWidth = NSExpression(forConstantValue: 5)
		layer.lineColor = NSExpression(forConstantValue: UIColor.red)
		style.addLayer(layer)
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
		
		// addAreaLayer(to: style, source: source)
		addHeatmapLayers(to: style, source: source)
		addPathLayer(to: style, source: source)
		
		let annotation = MGLPointFeature()
		annotation.coordinate = CLLocationCoordinate2D(latitude: 65.4, longitude: 26.5)
		mapView.addAnnotation(annotation)
	}
	
	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
		return true
	}
	
	func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {
		mapView.removeAnnotation(annotation)
	}
	
	func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
		return WeatherView(frame: CGRect(x: 0, y: 0, width: 96, height: 58))
	}
	
	func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
		let image = MGLAnnotationImage(image: UIImage(named: "reindeer")!, reuseIdentifier: "reindeer")
		return image
	}
}
