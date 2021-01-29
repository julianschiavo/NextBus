//
//  DirectionsMap.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import MapKit
import SwiftUI

#if os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#endif

struct DirectionsMap: ViewRepresentable {
    @Binding var annotations: [MKAnnotation]
    @Binding var directions: Directions?
    
    @StateObject private var pathLoader = GeoPathLoader()
    @State private var isLoadingPath = false
    
    func makeView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
//        mapView.showsTraffic = true
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateView(_ view: MKMapView, context: Context) {
        DispatchQueue.main.async {
            view.removeAnnotations(view.annotations)
            view.removeOverlays(view.overlays)
            view.addAnnotations(annotations)
            view.showAnnotations(view.annotations, animated: true)
            loadPath(view: view)
            loadStopCircles(view: view)
        }
    }
    
    private func loadPath(view: MKMapView) {
        guard let directions = directions, !isLoadingPath else { return }
        isLoadingPath = true
        pathLoader.createPublisher(key: directions)?
            .sink { _ in
                return
            } receiveValue: { paths in
                isLoadingPath = false
                
                let polylines = paths
                    .flatMap { path in
                        path.polylines.map { polyline -> MKPolyline in
                            polyline.title = String(path.track.specialType == 5)
                            return polyline
                        }
                    }
                view.addOverlays(polylines, level: .aboveRoads)
            }
            .store(in: &pathLoader.cancellables)
    }
    
    private func loadStopCircles(view: MKMapView) {
        guard let directions = directions else { return }
        let circles = directions.tracks
            .flatMap(\.stops)
            .map { stop -> MKCircle in
                let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
                return MKCircle(center: coordinate, radius: 10)
            }
        view.addOverlays(circles, level: .aboveLabels)
    }
    
    #if os(iOS)
    func makeUIView(context: Context) -> MKMapView {
        makeView(context: context)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        updateView(view, context: context)
    }
    #elseif os(macOS)
    func makeNSView(context: Context) -> MKMapView {
        makeView(context: context)
    }
    
    func updateNSView(_ view: MKMapView, context: Context) {
        updateView(view, context: context)
    }
    #endif
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: DirectionsMap
        
        init(_ parent: DirectionsMap) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline, let isWalking = Bool(polyline.title ?? "false") {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = isWalking ? .white : .orange
                renderer.fillColor = isWalking ? .white : .orange
                renderer.lineDashPattern = isWalking ? [2, 5] : nil
                renderer.lineWidth = 6
                return renderer
            } else if let circle = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circle)
                renderer.fillColor = .white
                renderer.lineWidth = 10
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
