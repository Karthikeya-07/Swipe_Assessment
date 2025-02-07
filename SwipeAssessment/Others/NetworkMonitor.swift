//
//  NetworkMonitor.swift
//  SwipeAssessment
//
//  Created by Akepati Karthikeya Reddy on 06/02/25.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var isConnected = false
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
