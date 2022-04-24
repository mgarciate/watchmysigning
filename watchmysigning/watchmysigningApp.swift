//
//  watchmysigningApp.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import Firebase

@main
struct watchmysigningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
