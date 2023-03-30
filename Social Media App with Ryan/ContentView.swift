//
//  ContentView.swift
//  Social Media App with Ryan
//
//  Created by Brayton Lordianto on 3/19/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = RequestHandler()
    
    private func logIn() {
        model.send(status: "logged in")
    }

    var body: some View {
        List {
            Text("hey there")
            ForEach(model.onlineUsers, id: \.self) { user in
                Text(user)
            }
            Button("log in") {
                logIn()
            }
        }
        .onAppear {
            model.connect()
        }
        .onDisappear {
            model.disconnect()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
