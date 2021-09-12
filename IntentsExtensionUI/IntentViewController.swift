    //
    //  IntentViewController.swift
    //  IntentsExtensionUI
    //
    //  Created by Julian Schiavo on 28/9/2019.
    //  Copyright © 2019 Julian Schiavo. All rights reserved.
    //

import IntentsUI
import SwiftUI

@objc(IntentViewController)
class IntentViewController: UIViewController, INUIHostedViewControlling {
    private var desiredSize: CGSize {
        let width = extensionContext?.hostedViewMaximumAllowedSize.width ?? 320
        return CGSize(width: width, height: 300)
    }
    
    func configureView(for parameters: Set<INParameter>, of interaction: INInteraction, interactiveBehavior: INUIInteractiveBehavior, context: INUIHostedViewContext, completion: @escaping (Bool, Set<INParameter>, CGSize) -> Void) {
        guard let response = interaction.intentResponse as? GetUpcomingBusesIntentResponse,
              let inRoute = response.route,
              let route = Route.from(inRoute),
              let inStop = response.stop,
              let stop = Stop.from(inStop)
        else {
            completion(false, [], .zero)
            return
        }
        
        let info = SimpleBusInfo()
        info.route = route
        info.stop = stop
        
        let view = SimpleBusInfoView(info: info)
        let hostingController = UIHostingController(rootView: view)
        attachChild(hostingController)
        
        var size = extensionContext?.hostedViewMaximumAllowedSize ?? .zero
        size.height = 300
        completion(true, parameters, size)
    }
    
    private func attachChild(_ viewController: UIViewController) {
        addChild(viewController)
        
        if let subview = viewController.view {
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            
                // Set the child controller's view to be the exact same size as the parent controller's view.
            subview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            subview.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        viewController.didMove(toParent: self)
    }
}
