//
//  DirectionsMap.swift
//  NextBus
//
//  Created by Julian Schiavo on 23/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Loadability
import MapKit
import SwiftUI

#if os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#endif

struct DirectionsMap: ViewRepresentable {
    @Binding var annotations: [MKAnnotation]
    @Binding var routing: Routing?
    @Binding var focusedTrack: RoutingTrack?
    @Binding var paths: [RoutingPath]
    
    @StateObject private var pathLoader = GeoPathLoader()
    @State private var isLoadingPath = false
    
    func makeView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateView(_ mapView: MKMapView, context: Context) {
        DispatchQueue.main.async {
            focus(mapView: mapView)
            if paths.isEmpty {
                mapView.removeAnnotations(mapView.annotations)
                mapView.removeOverlays(mapView.overlays)
                mapView.addAnnotations(annotations)
                loadPath(view: mapView)
                #if os(iOS)
                loadStopCircles(view: mapView)
                #endif
            }
        }
    }
    
    private func focus(mapView: MKMapView) {
        if let track = focusedTrack, let path = paths.first(where: { $0.track.id == track.id }) {
            #if os(iOS)
            mapView.setVisibleMapRect(mapRect(for: path.polylines), edgePadding: UIEdgeInsets(top: 60, left: 60, bottom: 200, right: 60), animated: true)
            #else
            mapView.setVisibleMapRect(mapRect(for: path.polylines), edgePadding: NSEdgeInsets(top: 60, left: 60, bottom: 60, right: 60), animated: true)
            #endif
            focusedTrack = nil
        } else {
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func mapRect(for polylines: [MKPolyline]) -> MKMapRect {
        var rect = MKMapRect.null
        for polyline in polylines {
            rect = rect.union(polyline.boundingMapRect)
        }
        return rect
    }
    
    private func loadPath(view: MKMapView) {
        guard let routing = routing, !isLoadingPath else { return }
        isLoadingPath = true
        pathLoader.createPublisher(key: routing)?
            .sink { _ in
                return
            } receiveValue: { paths in
                isLoadingPath = false
                
                let paths = paths
                    .map { path -> RoutingPath in
                        path.polylines = path.polylines.map { polyline -> MKPolyline in
                            polyline.title = String(path.track.isWalking)
                            polyline.subtitle = path.track.company?.rawValue
                            return polyline
                        }
                        return path
                    }
                self.paths = paths
                
                let polylines = paths.flatMap(\.polylines)
                view.addOverlays(polylines, level: .aboveRoads)
            }
            .store(in: &pathLoader.cancellables)
    }
    
    #if os(iOS)
    private func loadStopCircles(view: MKMapView) {
        guard let routing = routing else { return }
        let circles = routing.tracks
            .flatMap { track in
                track.stops.map { stop -> StopAnnotation in
                    let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
                    return StopAnnotation(coordinate: coordinate, color: track.company?.nativeColor ?? .white)
                }
            }
        view.addAnnotations(circles)
    }
    #endif
    
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
        
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
            parent.focus(mapView: mapView)
        }
        
        #if os(iOS)
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? StopAnnotation {
                return StopAnnotationView(annotation: annotation)
            }
            return nil
        }
        #endif
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline, let isWalking = Bool(polyline.title ?? "false") {
                let renderer = MKPolylineRenderer(polyline: polyline)
                let color = isWalking ? .white : Company(rawValue: polyline.subtitle ?? "")?.nativeColor ?? .orange
                renderer.strokeColor = color
                renderer.fillColor = color
                renderer.lineDashPattern = isWalking ? [3, 4] : nil
                renderer.lineWidth = isWalking ? 2 : 5
                return renderer
            } else if let circle = overlay as? MKCircle {
                let renderer = MKCircleRenderer(circle: circle)
                renderer.fillColor = .white
                renderer.lineWidth = 12
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
