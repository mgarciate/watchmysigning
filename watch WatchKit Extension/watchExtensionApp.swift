//
//  watchExtensionApp.swift
//  watch WatchKit Extension
//
//  Created by mgarciate on 23/4/22.
//

import Foundation

import SwiftUI

@main
struct justatestApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
