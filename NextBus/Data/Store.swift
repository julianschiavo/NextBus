//
//  Store.swift
//  NextBus
//
//  Created by Julian Schiavo on 9/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation

class Store: ObservableObject {
    @Published var favorites = [Favorite]() {
        didSet {
            setFavorites(favorites)
        }
    }
    
    let appGroupFolderURL: URL
    
    private var decoder = JSONDecoder()
    
    init() {
        guard let folder = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.julianschiavo.nextbus") else {
            fatalError("Failed to find app group folder")
        }
        appGroupFolderURL = folder
        updateFavorites()
    }
    
    // MARK: - Favorites
    
    lazy private var favoritesURL = appGroupFolderURL.appendingPathComponent("UserFavorites").appendingPathExtension("json")
    
    func isFavorite(route: Route, stop: Stop) -> Bool {
        let favorite = Favorite(route: route, stop: stop)
        return favorites.contains(favorite)
    }
    
    func setFavorite(_ isFavorite: Bool, favorite: Favorite) {
        if isFavorite {
            favorites.append(favorite)
        } else {
            favorites.removeAll { $0 == favorite }
        }
    }
    
    private func getFavorites() -> [Favorite] {
        guard let data = FileManager.default.contents(atPath: favoritesURL.path),
              let favorites = try? decoder.decode([Favorite].self, from: data)
        else { return [] }
        return favorites
    }
    
    private func updateFavorites() {
        DispatchQueue.main.async {
            self.favorites = self.getFavorites()
        }
    }
    
    private func setFavorites(_ favorites: [Favorite]) {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        try? data.write(to: favoritesURL, options: [.atomic])
    }
}
