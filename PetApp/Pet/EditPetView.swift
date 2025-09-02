//
//  EditPetView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 27.08.2025.
//

import SwiftUI

struct EditPetView: View {
    let isEditing: Bool
    let petId: UUID?
    @State private var pet: PetModel
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) var dismiss

    @State private var isEmptyNameAlert = false
    @State private var showImagePicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceSheet = false

    init(petId: UUID? = nil) {
        self.petId = petId

        if let petId = petId {
            let service = UserService()
            self._pet = State(initialValue: service.pets.first { $0.id == petId } ?? PetModel())
            isEditing = true
        } else {
            self._pet = State(initialValue: PetModel())
            isEditing = false
        }
    }

    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 20)
            Text(isEditing ? "Editing a pet" : "Adding a pet")
                .foregroundStyle(.blueMain)
                .font(.system(size: 41, weight: .semibold))
                .padding(.horizontal, 20)
            ScrollView {
                VStack (alignment: .leading, spacing: 10) {
                    Button {
                        showSourceSheet = true
                    } label: {
                        ZStack {
                            Color.grayFrame
                            Image(systemName: "plus.square.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blueMain)
                                .padding(40)
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
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, alignment: .center)
                    Text("Nickname")
                        .foregroundStyle(.textDark)
                        .font(.system(size: 16, weight: .semibold))
                    TextField("Nickname", text: $pet.name)
                        .foregroundStyle(.textDark)
                        .font(.system(size: 14))
                        .lightFramed(isBordered: true)
                        .padding(.bottom)
                    Text("Age")
                        .foregroundStyle(.textDark)
                        .font(.system(size: 16, weight: .semibold))
                    HStack {
                        TextField("", text: Binding(get: {
                            String(pet.age)
                        }, set: { newValue in
                            pet.age = Int(newValue) ?? 0
                        })
                        )
                        Menu {
                            ForEach(IntervalType.allCases, id: \.self) { interval in
                                Button {
                                    withAnimation {
                                        pet.ageType = interval
                                    }
                                } label: {
                                    Text(interval.rawValue)
                                }
                            }
                        } label: {
                            Text(pet.ageType.rawValue)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(.grayMain)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .foregroundStyle(.textDark)
                        }

                    }
                    .lightFramed()
                    Button {
                        guard !pet.name.isEmpty else {
                            isEmptyNameAlert = true
                            return
                        }
                        if isEditing {
                            if let index = userService.pets.firstIndex(where: { $0.id == pet.id }) {
                                userService.pets[index] = pet
                            }
                        } else {
                            userService.pets.append(pet)
                        }
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .blueFramed()
                            .shadow(radius: 10)
                    }
                    .padding(.top, 50)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, getSafeAreaBottom() + 40)
            }
        }
        .confirmationDialog("Select Source", isPresented: $showSourceSheet, titleVisibility: .visible) {
            Button("Camera") {
                pickerSource = .camera
                showImagePicker = true
            }
            Button("Photo Library") {
                pickerSource = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: pickerSource) { selectedImage in
                pet.imageData = selectedImage
            }
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
        .alert("Incorrect data", isPresented: $isEmptyNameAlert) {
            Button("Ок", role: .cancel) { }
        } message: {
            Text("Pet should have name")
        }
    }
}

#Preview {
    EditPetView()
}
