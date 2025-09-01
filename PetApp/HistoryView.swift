//
//  HistoryView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 27.08.2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var userService: UserService
    @State private var searchText = ""
    @State private var selectedEvent: EventStoryModel? = nil
    @State private var commentText = ""
    @State private var isShowingEdit: Bool = false

    var filteredEvents: [EventStoryModel] {
        userService.history.filter { event in
            var petNameContainsSearchText = false
            if let pet = userService.pets.first(where: {$0.id == event.petId} ) {
                petNameContainsSearchText = pet.name.localizedCaseInsensitiveContains(searchText)
            }
            return (searchText.isEmpty || event.procedure.name.localizedCaseInsensitiveContains(searchText) || petNameContainsSearchText)
        }.sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
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
                        ForEach (filteredEvents) { event in
                            SwipeableBlock {
                                VStack (alignment: .leading) {
                                    HStack {
                                        VStack (alignment: .leading) {
                                            Text(event.procedure.name)
                                                .font(.system(size: 19, weight: .semibold))
                                                .foregroundStyle(.blueMain)
                                            Text(userService.dateFormatter(date: event.date))
                                                .font(.system(size: 15, weight: .light))
                                                .foregroundStyle(.textDark)
                                        }
                                        Spacer()
                                        Text(event.isCompleted ? "Complete" : "Overdue")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(event.isCompleted ? .blueMain : .redMain)
                                    }
                                    if !event.comment.isEmpty {
                                        Text(event.comment)
                                            .font(.system(size: 15, weight: .light))
                                            .foregroundStyle(.textDark)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lightFramed(isBordered: true)
                                    }
                                }
                                .lightFramed()
                            } onEdit: {
                                withAnimation {
                                    selectedEvent = event
                                    commentText = event.comment
                                    isShowingEdit = true
                                }
                            } onDelete: {
                                withAnimation {
                                    if let index = userService.history.firstIndex(where: { $0.id == event.id }) {
                                        userService.history.remove(at: index)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .padding(.bottom, 50)
                }
            }
            Color.black.opacity(isShowingEdit ? 0.5 : 0)
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
                        guard let selectedEvent = selectedEvent else { return }

                        if let index = userService.history.firstIndex(where: { $0.id == selectedEvent.id }) {
                            var updatedEvent = selectedEvent
                            updatedEvent.comment = commentText
                            userService.history[index] = updatedEvent
                        }

                        withAnimation {
                            isShowingEdit = false
                        }
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
            .opacity(isShowingEdit ? 1 : 0)
        }
        .padding(.bottom, getSafeAreaBottom() + 40)
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
    HistoryView()
}
