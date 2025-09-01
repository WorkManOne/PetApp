//
//  HomeView.swift
//  PetApp
//
//  Created by Кирилл Архипов on 27.08.2025.
//

import SwiftUI

enum EventFilter: String, CaseIterable {
    case today = "Today"
    case soon = "Soon"
    case overdue = "Overdue"
    case all = "All"
}

struct HomeView: View {
    @EnvironmentObject var userService: UserService
    @State private var searchText = ""
    @State private var selectedAnimalId: UUID? = nil
    @State private var selectedFilter: EventFilter = .today
    @State private var commentText = ""
    @State private var selectedEvent: EventModel? = nil
    @State private var isShowingCommentWindow = false

    var filteredEvents: [EventModel] {
        userService.events.filter { event in
            var petNameContainsSearchText = false
            if let pet = userService.pets.first(where: {$0.id == event.petId} ) {
                petNameContainsSearchText = pet.name.localizedCaseInsensitiveContains(searchText)
            }
            return (searchText.isEmpty || event.procedure.name.localizedCaseInsensitiveContains(searchText) || petNameContainsSearchText) && (selectedAnimalId == nil || event.petId == selectedAnimalId) && filterByDate(event.date)
        }.sorted(by: { $0.date < $1.date })
    }

    private func filterByDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        switch selectedFilter {
        case .today:
            return calendar.isDateInToday(date)

        case .soon:
            if let thresholdDate = calendar.date(byAdding: userService.thresholdType.toComponent(), value: userService.threshold, to: Date()) {
                return date > Date() && date <= thresholdDate
            }
            return false
        case .overdue:
            return date < Date()

        case .all:
            return true
        }
    }

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0) {
                Picker("", selection: $selectedFilter) {
                    ForEach(EventFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                ScrollView(.horizontal) {
                    HStack {
                        NavigationLink {
                            EditPetView()
                        } label: {
                            ZStack {
                                Color.grayFrame
                                Image(systemName: "plus.square.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.blueMain)
                                    .padding(20)
                            }
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                        }
                        ForEach (userService.pets) { pet in
                            Button {
                                selectedAnimalId = selectedAnimalId == pet.id ? nil : pet.id
                            } label: {
                                ZStack {
                                    Color.grayFrame
                                    if let data = pet.imageData, let image = UIImage(data: data) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                    }
                                    Circle()
                                        .stroke(.blueMain, lineWidth: selectedAnimalId == pet.id ? 5 : 0)
                                }
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            }
                            .contextMenu {
                                NavigationLink("Details") {
                                    DetailPetView(petId: pet.id)
                                }
                            }
                            
                        }
                    }
                    .padding(.vertical, 20)
                }
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
                        ForEach (filteredEvents) { event in
                            if let index = userService.events.firstIndex(where: { $0.id == event.id } ) {
                                EventPreviewView(event: $userService.events[index]) {
                                    withAnimation {
                                        isShowingCommentWindow = true
                                        selectedEvent = event
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .padding(.bottom, 40)
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
    HomeView()
}
