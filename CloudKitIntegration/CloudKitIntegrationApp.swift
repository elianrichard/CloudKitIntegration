//
//  CloudKitIntegrationApp.swift
//  CloudKitIntegration
//
//  Created by Elian Richard on 30/05/24.
//

import SwiftUI

@main
struct CloudKitIntegrationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(CloudPersonViewModel())
        }
    }
}
