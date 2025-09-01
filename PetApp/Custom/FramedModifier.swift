//
//  GrayFrameBackground.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 24.06.2025.
//

import SwiftUI

extension View {
    func blueFramed(isBordered: Bool = false) -> some View {
        self
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.blueMain)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    func darkFramed(isBordered: Bool = false) -> some View {
        self
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.grayMain)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.redMain.opacity(0.2), lineWidth: isBordered ? 1 : 0)
            }
    }
    func lightFramed(isBordered: Bool = false) -> some View {
        self
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(.whiteMain)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: isBordered ? 1 : 0)
            }
    }
    func colorFramed(color: Color, isBordered: Bool = false, borderColor: Color = .blueMain) -> some View {
        self
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: isBordered ? 1 : 0)
            }
    }
}

#Preview {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .darkFramed()

}

//
//struct GrayFrameBackground: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .padding()
//            .frame(maxWidth: .infinity)
//            .background(.grayAccent)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//    }
//}

