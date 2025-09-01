//
//  ProcedureView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 27.08.2025.
//

import SwiftUI

struct ProceduresView: View {
    @EnvironmentObject var userService: UserService
    @State private var searchText = ""
    @State private var selectedProcedure: ProcedureModel?
    @State private var isShowingEdit = false

    var filteredProcedures: [ProcedureModel] {
        userService.procedures.filter { procedure in
            return (searchText.isEmpty || procedure.name.localizedCaseInsensitiveContains(searchText) || procedure.category?.name.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                Text("Procedures")
                    .foregroundStyle(.blueMain)
                    .font(.system(size: 41, weight: .semibold))
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                HStack {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    TextField("Search", text: $searchText)
                }
                .colorFramed(color: .grayMain, isBordered: true, borderColor: .blueMain.opacity(0.5))
                .padding(.horizontal, 20)
                ScrollView {
                    VStack (alignment: .leading, spacing: 15) {
                        ForEach (filteredProcedures) { procedure in
                            SwipeableRow(
                                title: procedure.name,
                                onEdit: {
                                    selectedProcedure = procedure
                                    isShowingEdit = true
                                }, onDelete: {
                                    withAnimation {
                                        if let index = userService.procedures.firstIndex(where: { $0.id == procedure.id }) {
                                            userService.procedures.remove(at: index)
                                        }
                                    }
                                }, onCopy: {
                                    var newProcedure = procedure
                                    newProcedure.id = UUID()
                                    userService.procedures.append(newProcedure)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .padding(.bottom, 90)
                }
            }
            NavigationLink {
                EditProcedureView()
            } label: {
                Text("ADD PROCEDURE")
                    .foregroundStyle(.whiteMain)
                    .font(.system(size: 15, weight: .semibold))
                    .blueFramed()
                    .shadow(radius: 10)
                    .padding(.horizontal, 20)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 60)
        }
        .padding(.bottom, getSafeAreaBottom() + 40)
        .navigationDestination(isPresented: $isShowingEdit) {
            if let procedure = selectedProcedure {
                EditProcedureView(procedure: procedure)
            }
        }
        .background(.grayMain)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

#Preview {
    ProceduresView()
        .environmentObject(UserService())
}
