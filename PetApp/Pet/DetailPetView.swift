//
//  DetailPetView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 29.08.2025.
//

import SwiftUI

struct DetailPetView: View {
    let petId: UUID?
    @State var pet: PetModel
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) var dismiss
    @State private var commentText = ""
    @State private var selectedEvent: EventModel? = nil
    @State private var isShowingCommentWindow = false

    init(petId: UUID? = nil) {
        self.petId = petId

        if let petId = petId {
            let service = UserService()
            self._pet = State(initialValue: service.pets.first { $0.id == petId } ?? PetModel())
        } else {
            self._pet = State(initialValue: PetModel())
        }
    }

    var body: some View {
        ZStack {
            VStack (spacing: 5) {
                HStack (spacing: 5) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    NavigationLink {
                        EditPetView(petId: petId)
                    } label: {
                        Image("pen")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.white)
                            .background(.lightblueMain)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 30, height: 30)
                    }
                    NavigationLink {
                        EditEventView(petId: pet.id)
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.white)
                    }
                    .background(.blueMain)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 30, height: 30)
                    Button {
                        withAnimation {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                withAnimation {
                                    if let index = userService.pets.firstIndex(of: pet) {
                                        userService.pets.remove(at: index)
                                    }
                                }
                            }
                        }
                    } label: {
                        Image("trash")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .padding(5)
                            .foregroundColor(.white)
                    }
                    .background(.redMain)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 30, height: 30)
                }
                .padding(.horizontal, 20)
                ZStack {
                    Color.grayFrame
                    if let data = pet.imageData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
                    Circle()
                        .stroke(.blueMain, lineWidth: 5)
                }
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .center)
                Text(pet.name)
                    .foregroundStyle(.blueMain)
                    .font(.system(size: 41, weight: .semibold))
                Text("\(pet.age) \(pet.ageType.localizedUnit(pet.age)) old")
                    .foregroundStyle(.textDark)
                    .font(.system(size: 15, weight: .light))
                HStack (spacing: 10) {
                    VStack {
                        Text("Completed in 30 days")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.blueMain)
                            .multilineTextAlignment(.center)
                        Rectangle()
                            .fill(.grayFrame)
                            .frame(height: 1)
                        let count = userService.history.filter { event in
                            event.isCompleted &&
                            event.petId == pet.id &&
                            Calendar.current.dateComponents([.day], from: event.date, to: Date()).day ?? 0 <= 30 &&
                            event.date <= Date()
                        }.count
                        Text("\(count)")
                            .font(.system(size: 43, weight: .semibold))
                            .foregroundStyle(.textDark)
                    }
                    .lightFramed()
                    VStack {
                        Text("Overdue")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.red)
                        Rectangle()
                            .fill(.grayFrame)
                            .frame(height: 1)
                        let count = userService.history.filter { event in
                            !event.isCompleted &&
                            event.petId == pet.id &&
                            Calendar.current.dateComponents([.day], from: event.date, to: Date()).day ?? 0 <= 30 &&
                            event.date <= Date()
                        }.count
                        Text("\(count)")
                            .font(.system(size: 43, weight: .semibold))
                            .foregroundStyle(.textDark)
                    }
                    .lightFramed()
                }
                .padding(.horizontal, 20)
                ScrollView {
                    VStack {
                        ForEach (userService.events.filter { $0.petId == pet.id }) { event in
                            if let index = userService.events.firstIndex(where: { $0.id == event.id } ) {
                                EventPreviewView(event: $userService.events[index], editView: EditEventView(event: event, petId: pet.id)) {
                                    withAnimation {
                                        isShowingCommentWindow = true
                                        selectedEvent = event
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, getSafeAreaBottom() + 40)
                }
            }
            Color.black.opacity(isShowingCommentWindow ? 0.5 : 0)
            VStack {
                Text("Сommentary")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(.textDark)
                TextField("Сommentary", text: $commentText, axis: .vertical)
                    .font(.system(size: 15, weight: .light))
                    .foregroundStyle(.textDark)
                    .lightFramed(isBordered: true)
                Button {
                    withAnimation {
                        if let selectedEvent = selectedEvent {
                            userService.addToHistory(event: selectedEvent, comment: commentText)
                            commentText = ""
                        }
                        isShowingCommentWindow = false
                    }
                } label: {
                    Text("Complete")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundStyle(.whiteMain)
                        .blueFramed()
                }
            }
            .lightFramed()
            .padding()
            .opacity(isShowingCommentWindow ? 1 : 0)
        }
        .background(.grayMain)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let nav = window.rootViewController?.children.first as? UINavigationController {
                nav.interactivePopGestureRecognizer?.isEnabled = true
                nav.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        .onAppear {
            if let newPet = userService.pets.first(where: { $0.id == petId }) {
                pet = newPet
            }
        }
    }
}

#Preview {
    DetailPetView()
        .environmentObject(UserService())
}
