//
//  RoutesLoader.swift
//  NextBus
//
//  Created by Julian Schiavo on 8/1/2021.
//  Copyright © 2021 Julian Schiavo. All rights reserved.
//

import Combine
import Foundation
import Loadability

class RoutesCache: AnySharedCache {
    typealias Key = GenericKey
    typealias Value = [CompanyRoutes]
//    static let shared = SerializableCache<GenericKey, [CompanyRoutes]>.load(name: "Routes", folderURL: Store.appGroupFolderURL)
    
    private static var fileURL: URL?
    
    private static var routes = [CompanyRoutes]()
    
    private static func getFileURL() -> URL {
        if let fileURL = fileURL {
            return fileURL
        }
        
        guard let folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Failed to find Documents directory.")
        }
        let url = folderURL.appendingPathComponent("Routes.cache")
        fileURL = url
        return url
    }
    
    static func value(for key: GenericKey) async throws -> [CompanyRoutes]? {
        let task = Task { () throws -> [CompanyRoutes] in
            let fileURL = getFileURL()
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([CompanyRoutes].self, from: data)
        }
        return try await task.value
    }
    
    static func update(key: GenericKey, to value: [CompanyRoutes]) async throws {
        let task = Task { () throws -> Void in
            let fileURL = getFileURL()
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL)
        }
        try await task.value
    }
    
    static func removeValue(for key: GenericKey) async throws {
        let task = Task { () throws -> Void in
            let fileURL = getFileURL()
            try FileManager.default.removeItem(at: fileURL)
        }
        try await task.value
    }
    
    static func isValueStale(_ key: GenericKey) -> Bool {
        false
    }
    
//    /// Encodes and saves the cache to disk.
//    public final func save() {
//        guard !name.isEmpty else { return }
//        let fileURL = folderURL.appendingPathComponent(self.name + ".cache")
//
//        DispatchQueue.global(qos: .default).async {
//            do {
//                let data = try JSONEncoder().encode(self)
//                try data.write(to: fileURL)
//            } catch {
//                print("[Cache] Failed to save.",
//                      error.localizedDescription,
//                      (error as NSError).localizedRecoverySuggestion ?? "")
//            }
//        }
//    }
//
//    /// Loads a previously-serialized cache from disk.
//    /// - Parameters:
//    ///   - name: The unique name of the cache.
//    ///   - shouldAutomaticallyRemoveStaleItems: Whether to automatically remove stale items, defaults to `false`.
//    ///   - itemLifetime: How many milliseconds items are valid for, defaults to 3600. This is not used if `autoRemoveStaleItems` is equal to `false`.
//    ///   - folderURL: The folder in which to store the cache, defaults to the system cache directory.
//    /// - Returns: The loaded cache.
//    public static func load(
//        name: String,
//        shouldAutomaticallyRemoveStaleItems autoRemoveStaleItems: Bool = false,
//        itemLifetime: TimeInterval = 3600,
//        folderURL: URL? = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
//    ) -> SerializableCache<Key, Value> {
//
//        guard let folderURL = folderURL else {
//            fatalError("Invalid Folder URL")
//        }
//
//        do {
//            let fileURL = folderURL.appendingPathComponent(name + ".cache")
//            let data = try Data(contentsOf: fileURL)
//            let cache = try JSONDecoder().decode(self, from: data)
//            cache.name = name // Setting after decoding avoids re-saving cache to disk unnescessarily
//            return cache
//        } catch {
//            print("[Cache] Failed to load (Name: \(name)).",
//                  error.localizedDescription,
//                  (error as NSError).localizedRecoverySuggestion ?? "")
//
//            let empty = SerializableCache(name: name, shouldAutomaticallyRemoveStaleItems: autoRemoveStaleItems, itemLifetime: itemLifetime)
//            empty.save()
//            return empty
//        }
//    }
}


class RoutesLoader: CachedLoader {
    private let baseURL = URL(string: "https://nextbusapi.schiavo.me")!
    private let urlMethod = "routes"
    
    typealias Key = GenericKey
    
    @Published var object: [CompanyRoutes]?
    @Published var filteredRoutes = [Company: [Route]]()
    @Published var routes: [Route]?
    @Published var error: Error?
    
    var cache = RoutesCache.self
    var cancellable: AnyCancellable?
    var task: Task<[CompanyRoutes], Error>?
    
    private let ctbNWFBLoader = CTBNWFB.RoutesLoader(key: .bus)
    private let gmbLoader = GMB.RoutesLoader(key: .minibus)
    private let nlbLoader = NLB.RoutesLoader(key: .bus)
    private let busLoader = GOV.RoutesLoader(key: .bus)
    private let minibusLoader = GOV.RoutesLoader(key: .minibus)
    
    required init() {
        
    }
    
    func loadData(key: GenericKey) async throws -> [CompanyRoutes] {
        async let ctbNWFBRoutes = ctbNWFBLoader.load()
        async let gmbRoutes = gmbLoader.load()
        async let nlbRoutes = nlbLoader.load()
        async let busRoutes = busLoader.load()
        async let minibusRoutes = minibusLoader.load()
        let routes = try await ctbNWFBRoutes + gmbRoutes + nlbRoutes + busRoutes + minibusRoutes
        self.routes = routes
        
        Task.detached {
            await SpotlightBuddy.shared.index(routes: routes)
        }
        
        let task = Task { () -> [CompanyRoutes] in
            let dictionary = Dictionary(grouping: routes, by: \.company)
            return dictionary
                .map { company, routes in
                    CompanyRoutes(company: company, routes: routes)
                }
                .sorted {
                    $0.company.name < $1.company.name
                }
        }
        return await task.value
    }
}
