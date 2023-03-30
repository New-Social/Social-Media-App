//
//  VaporRequestHandler.swift
//  Social Media App with Ryan
//
//  Created by Brayton Lordianto on 3/30/23.
//

import Foundation

class RequestHandler: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published private(set) var onlineUsers: [String] = []
    
    
    // MARK: - Connection
    func connect() { // 2
        let url = URL(string: "ws://127.0.0.1:8080/session")! // 3
        webSocketTask = URLSession.shared.webSocketTask(with: url) // 4
        webSocketTask?.receive(completionHandler: onReceive) // 5
        webSocketTask?.resume() // 6
    }
    
    func disconnect() { // 7
        webSocketTask?.cancel(with: .normalClosure, reason: nil) // 8
    }
    
    deinit {
        disconnect()
    }
    
    // MARK: - Sending Log In Status
    func send(status: String) {
        let plaintext = StatusRequest(status: status)
        guard let json = try? JSONEncoder().encode(plaintext), // 2
              let jsonString = String(data: json, encoding: .utf8)
        else { return }
        
        // using ws task which contains url and all setups, send the json string
        webSocketTask?.send(.string(jsonString)) { error in // 3
            if let error = error {
                print("Error sending message", error) // 4
            }
        }
    }
    
    // MARK: - Receiving Online Users
    private func onResponse(_ response: URLSessionWebSocketTask.Message) {
        if case .string(let text) = response { // 5
            guard let data = text.data(using: .utf8),
                  let onlineResponse = try? JSONDecoder().decode(OnlineResponse.self, from: data)
            else {
                return
            }
            
            // because URLSessionWebSocketTask can call the receive handler on a different thread, and because SwiftUI only works on the main thread, we have to wrap our modification in a DispatchQueue.main.async {}, assuring we're actually performing the modification on the main thread
            // any UI changes have to be in main
            DispatchQueue.main.async { // 6
                self.onlineUsers = onlineResponse.onlineUsers
            }
        }
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive) // receive handlers only bind once so you have to rebind it.
        if case .success(let response) = incoming { // 2
            onResponse(response)
        }
        else if case .failure(let error) = incoming { // 3
            print("Error", error)
        }
    }

    
}
