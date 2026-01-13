//
//  ReachabilityManager.swift
//  GithubClient
//
//  Created by Zaven Hovhannisyan on 13.01.26.
//

import Foundation

final class ReachabilityManager: ReachabilityManagerInput {
    var isReachable: Bool = true
}

//final class ReachabilityManager: ReachabilityManagerInput {
//
//    private let monitor: NWPathMonitor
//    private let queue = DispatchQueue(label: "ReachabilityManager.queue")
//
//    private(set) var isReachable: Bool = true
//
//    init(monitor: NWPathMonitor = NWPathMonitor()) {
//        self.monitor = monitor
//
//        monitor.pathUpdateHandler = { [weak self] path in
//            DispatchQueue.main.async {
//                self?.isReachable = (path.status == .satisfied)
//            }
//        }
//        monitor.start(queue: queue)
//    }
//
//    deinit {
//        monitor.cancel()
//    }
//}
