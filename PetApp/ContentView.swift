//
//  ContentView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 26.08.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var userService: UserService
    @State private var showNotificationAlert = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.grayMain.ignoresSafeArea()
                TabView (selection: $selectedTab) {
                    HomeView()
                        .tag(0)
                    ProceduresView()
                        .tag(1)
                    HistoryView()
                        .tag(2)
                    SettingsView()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
                ZStack {
                    Color.black.opacity(0.25)
                    VStack (spacing: 20) {
                        Text("Disclaimer")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.blueMain)
                        Text("This app is not a medical device and does not provide medical advice. For health questions, please consult your veterinarian.")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.redDark)
                            .multilineTextAlignment(.center)
                        Button {
                            withAnimation {
                                userService.isShowDisclaimer = false
                            }
                        } label: {
                            Text("OK")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.whiteMain)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blueMain)
                                )
                        }

                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.grayMain)
                    )
                }
                .opacity(userService.isShowDisclaimer ? 1 : 0)

            }
            .ignoresSafeArea()
        }
        .onAppear {
            NotificationManager.shared.requestPermission { _ in }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(UserService())
}
