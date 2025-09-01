//
//  EditProcedureView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 27.08.2025.
//

import SwiftUI
import FlowGrids

struct EditProcedureView: View {
    let isEditing: Bool
    @State private var procedure: ProcedureModel
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) var dismiss

    @State private var categoryId: UUID? = nil
    @State private var categoryName = "My category"
    @State private var isAddingCategory = false

    init(procedure: ProcedureModel? = nil) {
        if let procedure = procedure {
            self._procedure = State(initialValue: procedure)
            isEditing = true
        } else {
            self._procedure = State(initialValue: ProcedureModel())
            isEditing = false
        }
    }

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 10) {
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
                Text(isEditing ? "Edit procedure" : "Add procedure")
                    .foregroundStyle(.blueMain)
                    .font(.system(size: 41, weight: .semibold))
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                ScrollView {
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Title")
                            .foregroundStyle(.textDark)
                            .font(.system(size: 17, weight: .semibold))
                        TextField("Title", text: $procedure.name)
                            .foregroundStyle(.textDark)
                            .font(.system(size: 14))
                            .lightFramed(isBordered: true)
                            .padding(.bottom)
                        HStack {
                            Text("Category")
                                .foregroundStyle(.textDark)
                                .font(.system(size: 17, weight: .semibold))
                            Spacer()
                            Button {
                                withAnimation {
                                    isAddingCategory = true
                                }
                            } label: {
                                Text("+")
                                    .foregroundStyle(.whiteMain)
                                    .font(.system(size: 17, weight: .semibold))
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.blueMain)
                                    )
                            }
                        }
                        .padding(.bottom)
                        VFlowGrid(rowAlignment: .leading, itemAlignment: .top, rowSpacing: 10, itemSpacing: 5) {
                            ForEach(userService.categories) { category in
                                Button {
                                    withAnimation {
                                        procedure.category = category
                                    }
                                } label: {
                                    Text(category.name)
                                        .font(.system(size: 16))
                                        .foregroundStyle(procedure.category == category ? .whiteMain : .gray)
                                        .padding(.horizontal)
                                        .padding(.vertical, 5)
                                        .background(procedure.category == category ? .blueMain : .whiteMain)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(procedure.category == category ? .whiteMain : .blueMain, lineWidth: 1)
                                        }
                                        .contextMenu {
                                            Button("Delete", role: .destructive) {
                                                withAnimation {
                                                    if let index = userService.categories.firstIndex(where: { $0.id == category.id }) {
                                                        userService.categories.remove(at: index)
                                                    }
                                                }

                                            }
                                            Button("Edit") {
                                                withAnimation {
                                                    if let cat = userService.categories.first(where: { $0.id == category.id }) {
                                                        categoryId = cat.id
                                                        categoryName = cat.name
                                                        isAddingCategory = true
                                                    }
                                                }

                                            }
                                        }

                                }

                            }
                        }
                        .padding(.bottom, 30)
                        Text("Interval")
                            .foregroundStyle(.textDark)
                            .font(.system(size: 17, weight: .semibold))
                        HStack {
                            TextField("Interval", text: Binding(get: {
                                String(procedure.interval)
                            }, set: { newValue in
                                procedure.interval = Int(newValue) ?? 0
                            })
                            )
                            Menu {
                                ForEach(IntervalType.allCases, id: \.self) { interval in
                                    Button {
                                        withAnimation {
                                            procedure.intervalType = interval
                                        }
                                    } label: {
                                        Text(interval.rawValue)
                                    }
                                }
                            } label: {
                                Text(procedure.intervalType.rawValue)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                    .background(.grayMain)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .foregroundStyle(.textDark)
                            }

                        }
                        .lightFramed()
                        Picker("", selection: $procedure.procedureTime) {
                            ForEach(ProcedureTime.allCases, id: \.self) { time in
                                Text(time.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 20)
                        .padding(.bottom, 40)
                        Button {
                            if isEditing {
                                if let index = userService.procedures.firstIndex(where: { $0.id == procedure.id }) {
                                    userService.procedures[index] = procedure
                                }
                            } else {
                                userService.procedures.append(procedure)
                            }
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                                .colorFramed(color: .blueMain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, getSafeAreaBottom() + 40)
                }
            }
            Color.black.ignoresSafeArea().opacity(isAddingCategory ? 0.5 : 0)
            VStack (spacing: 20) {
                Text("Add category")
                    .foregroundStyle(.textDark)
                    .font(.system(size: 17, weight: .semibold))
                TextField("Name", text: $categoryName)
                    .foregroundStyle(.textDark)
                    .font(.system(size: 16))
                    .lightFramed(isBordered: true)
                HStack {
                    Button {
                        withAnimation {
                            if categoryId != nil {
                                if let index = userService.categories.firstIndex(where: { $0.id == categoryId }) {
                                    userService.categories[index].name = categoryName
                                }
                            } else {
                                userService.categories.append(CategoryModel(name: categoryName))
                            }
                            isAddingCategory = false
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                categoryId = nil
                                categoryName = "My category"
                            }
                        }
                    } label: {
                        Text("SAVE")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.whiteMain)
                            .padding(.vertical, 5)
                            .colorFramed(color: .blueMain)
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            isAddingCategory = false
                        }
                    } label: {
                        Text("CANCEL")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .colorFramed(color: .redMain)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.grayFrame)
            )
            .padding(10)
            .opacity(isAddingCategory ? 1 : 0)
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
    }
}
#Preview {
    EditProcedureView()
        .environmentObject(UserService())
}
