//
//  Client.swift
//  TCP_IP_Client
//
//  Created by 장준석 on 2023/04/27.
//

import Network
import Foundation

public class TCPClient {
    private let connection: NWConnection
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port) {
        connection = NWConnection(host: host, port: port, using: .tcp)
    }

    func start() {
        connection.start(queue: .main)
        receive()
    }

    func send(message: String) {
        let content = message.data(using: .utf8)
        connection.send(content: content, completion: .contentProcessed { error in
            if let error = error {
                print("Error sending data: \(error)")
            } else {
                print("Data sent successfully!")
            }
        })
    }

    func receive() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { (data, context, isComplete, error) in
            if let data = data, !data.isEmpty {
                print("Received data: \(data)")
            }
            if let error = error {
                print("Error receiving data: \(error)")
            }
            if isComplete {
                print("All data received!")
            } else {
                self.receive()
            }
        }
    }

    func cancel() {
        connection.cancel()
    }
}
