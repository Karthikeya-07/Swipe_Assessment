//
//  NetworkMonitor.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 06/02/25.
//

import Network
import Combine

/// `NetworkMonitor` observes network changes and updates the `isConnected` property accordingly.
class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var isConnected = false
    /// Initializes the network monitor and starts monitoring network changes.
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
