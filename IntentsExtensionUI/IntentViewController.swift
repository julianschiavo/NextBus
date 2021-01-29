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
class IntentViewController: UIHostingController<SimpleBusInfoView>, INUIHostedViewControlling {

    private let info = SimpleBusInfo()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(rootView: SimpleBusInfoView(info: info))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(rootView: SimpleBusInfoView(info: info))
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

        info.route = route
        info.stop = stop

        var size = extensionContext?.hostedViewMaximumAllowedSize ?? .zero
        size.height = 300
        completion(true, parameters, size)
    }
}
