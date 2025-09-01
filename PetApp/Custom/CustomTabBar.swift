//
//  CustomTabBar.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 23.06.2025.
//

import SwiftUI

func getSafeAreaBottom() -> CGFloat {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {
        return 44
    }
    return window.safeAreaInsets.bottom
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            Spacer()
            TabBarButton(icon: Image("home"), title: "Home", index: 0, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: Image("procedures"), title: "Procedures", index: 1, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: Image("history"), title: "History", index: 2, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: Image("settings"), title: "Settings", index: 3, selectedTab: $selectedTab)
            Spacer()
        }
        .padding(.vertical, 20)
        .padding(.bottom, getSafeAreaBottom())
        .background(
            Color(.whiteMain)
                .shadow(radius: 10)
        )
    }
}

struct TabBarButton: View {
    let icon: Image
    let title: String
    let index: Int
    @Binding var selectedTab: Int

    var body: some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 4) {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.system(size: 10))
            }
            .foregroundColor(selectedTab == index ? .blueMain : .gray)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
        .ignoresSafeArea()
        .background(.black)
}
