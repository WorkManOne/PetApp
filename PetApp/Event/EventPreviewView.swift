//
//  EventPreviewView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 29.08.2025.
//

import SwiftUI

struct EventPreviewView: View {
    @EnvironmentObject var userService: UserService
    @Binding var event: EventModel
    var editView: EditEventView?
    var onComplete: (() -> Void)?
    var body: some View {
        HStack {
            ZStack {
                Color.grayFrame
                if let pet = userService.pets.first(where: {$0.id == event.petId} ), let data = pet.imageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                }
                Circle()
                    .stroke(.blueMain, lineWidth: 5)
            }
            .clipShape(Circle())
            .frame(width: 60, height: 60)
            VStack (alignment: .leading) {
                Text(event.procedure.name)
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.blueMain)
                Text(userService.pets.first(where: {$0.id == event.petId} )?.name ?? "")
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.gray)
                Text(event.status().label)
                    .font(.system(size: 12, weight: .light))
                    .foregroundStyle(.whiteMain)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(event.status().color)
                    )
            }
            Spacer()
            VStack {
                Button {
                    onComplete?()
                } label: {
                    Text("Complete")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)

                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(.blueMain)
                        )
                }
                if let view = editView {
                    NavigationLink {
                        view
                    } label: {
                        Text("Edit")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.redDark)
                            )
                    }

                }
            }
            .frame(width: 110)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
    }
}

#Preview {
    EventPreviewView(event: .constant(EventModel(procedure: ProcedureModel(name: "Procedure", category: CategoryModel(name: "categry"), interval: 2, intervalType: .day, procedureTime: .day), petId: UUID(), date: Date(timeIntervalSinceNow: 350000))), editView: EditEventView())
        .environmentObject(UserService())
        .background(.black)
}
