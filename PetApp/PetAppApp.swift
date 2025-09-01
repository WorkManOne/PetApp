//
//  PetAppApp.swift
//  PetApp
//
//  Created by Кирилл Архипов on 26.08.2025.
//

import SwiftUI

@main
struct PetAppApp: App {
    @ObservedObject var userService = UserService()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userService)
                .preferredColorScheme(.light)
                .fullScreenCover(isPresented: .constant(userService.isFirstLaunch)) {
                    OnboardingView()
                        .environmentObject(userService)
                }
        }
    }
}
