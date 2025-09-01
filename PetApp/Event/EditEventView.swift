//
//  EditEventView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 29.08.2025.
//

import SwiftUI

struct EditEventView: View {
    let isEditing: Bool
    @State private var event: EventModel
    @EnvironmentObject var userService: UserService
    @Environment(\.dismiss) var dismiss
    @State private var isShowingProcedures = false
    @State private var isShowingDatePicker = false
    @State private var searchText = ""

    var filteredProcedures: [ProcedureModel] {
        userService.procedures.filter { procedure in
            return (searchText.isEmpty || procedure.name.localizedCaseInsensitiveContains(searchText) || procedure.category?.name.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    init(event: EventModel? = nil, petId: UUID? = nil) {
        if let event = event {
            self._event = State(initialValue: event)
            isEditing = true
        } else {
            let procedure = UserService().procedures.first ?? ProcedureModel(name: "Unknown")
            let dateWithTime = Date().setTimeBasedOn(procedureTime: procedure.procedureTime)
            let event = EventModel(
                procedure: procedure,
                petId: petId,
                date: dateWithTime,
                timeRepeat: procedure.intervalType,
                procedureTime: procedure.procedureTime
            )
            self._event = State(initialValue: event)
            isEditing = false
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.gray)
                    }
                    Text("Setting up the procedure")
                        .foregroundStyle(.blueMain)
                        .font(.system(size: 41, weight: .semibold))
                    Button {
                        withAnimation {
                            isShowingProcedures = true
                        }
                    } label: {
                        Text(event.procedure.name)
                            .foregroundStyle(.textDark)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lightFramed(isBordered: true)
                    }
                    Picker("", selection: $event.timeRepeat) {
                        ForEach(IntervalType.allCases, id: \.self) { time in
                            Text(time.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    Picker("", selection: $event.procedureTime) {
                        ForEach(ProcedureTime.allCases, id: \.self) { time in
                            Text(time.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: event.procedureTime) { newValue in
                        event.date = event.date.setTimeBasedOn(procedureTime: newValue)
                    }
                    HStack {
                        Text("Notifications")
                            .foregroundStyle(.textDark)
                            .font(.system(size: 19, weight: .medium))
                        Toggle("", isOn: $event.isNotificationEnabled)
                    }
                    .lightFramed()
                    Button {
                        isShowingDatePicker = true
                    } label: {
                        HStack {
                            Text("Next date")
                                .foregroundStyle(.textDark)
                                .font(.system(size: 19, weight: .medium))
                            Spacer()
                            Text(userService.dateFormatter(date: event.date))
                                .foregroundStyle(.textDark)
                                .font(.system(size: 15, weight: .light))
                        }
                        .lightFramed()
                    }
                    Button {
                        event.date = Date()
                    } label: {
                        Text("MARK TODAY")
                            .foregroundStyle(.white)
                            .font(.system(size: 15, weight: .semibold))
                            .blueFramed()
                    }
                    Rectangle()
                        .fill(.grayFrame)
                        .frame(height: 1)
                    Text("Сompletion history")
                        .foregroundStyle(.textDark)
                        .font(.system(size: 24, weight: .semibold))
                    let filteredEventStory = userService.history.filter { $0.eventId == event.id }
                    ForEach (filteredEventStory) { story in
                        HStack {
                            VStack (alignment: .leading) {
                                Text(story.procedure.name)
                                    .foregroundStyle(.blueMain)
                                    .font(.system(size: 19, weight: .semibold))
                                Text(userService.dateFormatter(date: story.date))
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 15, weight: .light))
                            }
                            Spacer()
                            Text(story.isCompleted ? "Completed" : "Overdue")
                                .foregroundStyle(story.isCompleted ? .blueMain : .redMain)
                                .font(.system(size: 15, weight: .semibold))
                        }
                        .lightFramed()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, getSafeAreaBottom() + 40)
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
        .onDisappear {
            if isEditing {
                userService.updateEvent(event)
            } else {
                userService.addEvent(event)
            }
        }
        .sheet(isPresented: $isShowingProcedures) {
            VStack {
                ZStack {
                    Button {
                        isShowingProcedures = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(.grayMain)
                            )
                            .frame(width: 40, height: 40)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Procedures")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.textDark)
                }
                .padding(20)
                HStack {
                    Image("search")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    TextField("Search", text: $searchText)
                }
                .colorFramed(color: .grayMain, isBordered: true, borderColor: .blueMain.opacity(0.5))
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                ScrollView {
                    VStack {
                        ForEach (filteredProcedures) { procedure in
                            Button {
                                event.procedure = procedure
                                event.procedureTime = procedure.procedureTime
                                event.timeRepeat = procedure.intervalType
                                event.date = event.date.setTimeBasedOn(procedureTime: procedure.procedureTime)
                                isShowingProcedures = false
                            } label: {
                                Text(procedure.name)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16))
                                    .blueFramed()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isShowingDatePicker) {
            CustomDatePickerSheet(selectedDate: $event.date)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    EditEventView()
        .environmentObject(UserService())
}
