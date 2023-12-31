//
//  Know_Your_WorthApp.swift
//  Know Your Worth
//
//  Created by Kenny Albert on 11/27/23.
//

import SwiftUI
import SwiftData

@main
struct Know_Your_WorthApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: TimeSheet.self)
    }
}
