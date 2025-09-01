//
//  SwipeableRow.swift
//  PetApp
//
//  Created by Кирилл Архипов on 27.08.2025.
//

import SwiftUI

struct SwipeableRow: View {
    let title: String
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onCopy: () -> Void

    @State private var offset: CGFloat = 0
    private let maxOffset: CGFloat = -130

    var body: some View {
        HStack {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.textDark)
                .frame(maxHeight: .infinity)
                .lightFramed(isBordered: true)
                .frame(height: 40)
        }
        .offset(x: offset)
        .onTapGesture {
            withAnimation {
                offset = (offset == 0 ? maxOffset : 0)
            }
        }
        .background(
            HStack(spacing: 3) {
                Spacer()
                buttonView(color: .lightblueMain, icon: "pen", action: onEdit)
                buttonView(color: .blueMain, icon: "copy", action: onCopy)
                buttonView(color: .redMain, icon: "trash", action: onDelete)
            }
        )
    }

    private func buttonView(color: Color, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .padding(10)
                .foregroundColor(.white)
        }
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(width: 40, height: 40)
    }
}


#Preview {
    SwipeableRow(title: "text", onEdit: {}, onDelete: {}, onCopy: {})
}
