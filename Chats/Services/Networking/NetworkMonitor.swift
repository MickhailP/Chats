//
//  NetworkMonitor.swift
//  Chats
//
//  Created by Миша Перевозчиков on 12.05.2023.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {

	 private let networkMonitor = NWPathMonitor()
	 private let workerQueue = DispatchQueue(label: "Monitor")

	 @Published private(set) var isConnected: Bool = true


	 init() {
		  networkMonitor.pathUpdateHandler = { [weak self] path in
				DispatchQueue.main.async {
					 self?.isConnected = path.status == .satisfied
				}
		  }
		  networkMonitor.start(queue: workerQueue)
	 }
}
