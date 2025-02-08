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
    private var monitor: NWPathMonitor
    private let networkMonitorQueue = DispatchQueue(label: "NetworkMonitor")
    @Published var isConnected = false
    /// Initializes the network monitor and starts monitoring network changes.
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = handleNetworkChange
        monitor.start(queue: networkMonitorQueue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    func handleNetworkChange(_ path: NWPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isConnected = path.status == .satisfied
        }
    }
}
