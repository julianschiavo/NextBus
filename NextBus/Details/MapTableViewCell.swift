//
//  MapTableViewCell.swift
//  NextBus
//
//  Created by Julian Schiavo on 19/9/2019.
//  Copyright © 2019 Julian Schiavo. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit

class MapTableViewCell: UITableViewCell, ReusableTableViewCell, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var name = ""
    var location = CLLocation(latitude: 0, longitude: 0)
    var overlays = [MKOverlay]()
    
    let manager = CLLocationManager()
    var mapView = MKMapView()
    
    // MARK: Init/Setup
    
    static let reuseIdentifier = "MapTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupMapView()
        setupGestureRecognizer()
        
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMapView() {
        mapView.layer.cornerRadius = 10
        mapView.layer.masksToBounds = true
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsTraffic = true
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: [.publicTransport])
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        mapView.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openEventLocationInMaps))
        addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Public
    
    func setup(name: String, latitude: Double, longitude: Double) {
        setup(name: name, location: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    private func setup(name: String, location: CLLocation) {
        self.name = name
        self.location = location
        resetOverlays()
        
        let regionRadius: CLLocationDistance = 400
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = location.coordinate
        self.mapView.addAnnotation(annotation)
    }
    
    private func resetOverlays() {
        for overlay in overlays {
            mapView.removeOverlay(overlay)
        }
        overlays = [MKOverlay]()
    }
    
    private func calculateDirections(from userLocation: CLLocation) {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.transportType = .walking
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            guard let response = response, error == nil else { return }
            
            for route in response.routes {
                self?.resetOverlays()
                self?.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    // MARK: Open Maps with directions
    
    @objc func openEventLocationInMaps() {
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else { return }
        calculateDirections(from: mostRecentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
    
    // MARK: MKMapViewDelegate (tell UI Testing that the map has finished loading)
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay) }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .systemGreen
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        accessibilityIdentifier = "MapViewFinishedLoading"
    }
}
