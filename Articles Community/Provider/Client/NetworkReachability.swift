//
//  NetworkReachability.swift
//  Articles Community
//
//  Created by Veeru Masal on 08/10/26.
//


import Foundation
import Reachability

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private var reachability: Reachability?

    /// Same API as before, so no other file needs to change.
    var isConnected: Bool {
        guard let reachability else { return true }   // if setup failed, don't show a false "offline"
        return reachability.connection != .unavailable
    }

    /// Optional: called on the main thread whenever connectivity changes.
    var onChange: ((Bool) -> Void)?

    private init() {
        do {
            let reachability = try Reachability()
            self.reachability = reachability

            reachability.whenReachable = { [weak self] _ in
                DispatchQueue.main.async { self?.onChange?(true) }
            }
            reachability.whenUnreachable = { [weak self] _ in
                DispatchQueue.main.async { self?.onChange?(false) }
            }

            try reachability.startNotifier()
        } catch {
            print("Reachability setup failed: \(error)")
        }
    }
}
