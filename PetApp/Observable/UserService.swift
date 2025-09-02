//
//  UserDataModel.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 23.06.2025.
//

import Foundation
import SwiftUI

class UserService: ObservableObject {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("isShowDisclaimer") var isShowDisclaimer: Bool = true
    @AppStorage("isFullHours") var isFullHours: Bool = true
    @AppStorage("dateFormat") var dateFormat: Int = 0
    @AppStorage("threshold") var threshold: Int = 7
    @AppStorage("thresholdType") var thresholdType: IntervalType = .day

    @Published var pets: [PetModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(pets), forKey: "pets")
        }
    }
    @Published var events: [EventModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(events), forKey: "events")
        }
    }

    @Published var history: [EventStoryModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(history), forKey: "history")
        }
    }

    @Published var procedures: [ProcedureModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(procedures), forKey: "procedures")
        }
    }
    @Published var categories: [CategoryModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(categories), forKey: "categories")
        }
    }

    init() {
        let health = CategoryModel(name: "Health")
        let grooming = CategoryModel(name: "Grooming")
        let hygiene = CategoryModel(name: "Hygiene")
        let defaultCategories = [health, hygiene, grooming, CategoryModel(name: "Other")]
        let defaultProcedures = [
            ProcedureModel(name: "Vaccines", category: health, interval: 1, intervalType: .year, procedureTime: .morning),
            ProcedureModel(name: "Deworming", category: health, interval: 2, intervalType: .month, procedureTime: .day),
            ProcedureModel(name: "Fleas/ticks", category: health, interval: 2, intervalType: .day, procedureTime: .day),
            ProcedureModel(name: "Claws", category: grooming, interval: 2, intervalType: .month, procedureTime: .evening),
            ProcedureModel(name: "Trimming/clipping", category: grooming, interval: 1, intervalType: .year, procedureTime: .morning),
            ProcedureModel(name: "Ears", category: hygiene, interval: 1, intervalType: .year, procedureTime: .morning),
            ProcedureModel(name: "Teeth", category: hygiene, interval: 1, intervalType: .year, procedureTime: .morning),
            ProcedureModel(name: "Bathing", category: hygiene, interval: 1, intervalType: .year, procedureTime: .morning),
            ProcedureModel(name: "Combing", category: grooming, interval: 3, intervalType: .month, procedureTime: .evening)
        ]
        let petId = UUID()
        var imageData = Data()
        if let image = UIImage(named: "jack_pet_image"),
           let data = image.jpegData(compressionQuality: 0.8) {
            imageData = data
        }
        let defaultPets = [PetModel(id: petId, name: "Jack", age: 3, ageType: .year, imageData: imageData)]
        let defaultEvents = [
            EventModel(procedure: defaultProcedures[1], petId: petId, date: .now, isNotificationEnabled: false, timeRepeat: .week, procedureTime: .day),
            EventModel(procedure: defaultProcedures[0], petId: petId, date: .now, isNotificationEnabled: false, timeRepeat: .year, procedureTime: .morning)
        ]

        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "pets"),
           let decoded = try? JSONDecoder().decode([PetModel].self, from: data) {
            pets = decoded
        } else {
            pets = defaultPets
        }
        if let data = userDefaults.data(forKey: "events"),
           let decoded = try? JSONDecoder().decode([EventModel].self, from: data) {
            events = decoded
        } else {
            events = defaultEvents
        }
        if let data = userDefaults.data(forKey: "history"),
           let decoded = try? JSONDecoder().decode([EventStoryModel].self, from: data) {
            history = decoded
        } else {
            history = []
        }

        if let data = userDefaults.data(forKey: "procedures"),
           let decoded = try? JSONDecoder().decode([ProcedureModel].self, from: data) {
            procedures = decoded
        } else {
            procedures = defaultProcedures
        }
        if let data = userDefaults.data(forKey: "categories"),
           let decoded = try? JSONDecoder().decode([CategoryModel].self, from: data) {
            categories = decoded
        } else {
            categories = defaultCategories
        }
    }

    func dateFormatter(date: Date) -> String {
        let df = DateFormatter()
        if dateFormat == 0 {
            df.dateFormat = "dd.MM.yyyy"
        } else if dateFormat == 1 {
            df.dateFormat = "yyyy-MM-dd"
        } else if dateFormat == 2 {
            df.dateFormat = "dd MMM yyyy"
        } else if dateFormat == 3 {
            df.dateFormat = "dd/MM/yyyy"
        }
        if isFullHours {
            df.dateFormat += " HH:mm"
        } else {
            df.dateFormat += " h:mm a"
        }

        return df.string(from: date)
    }

    func addToHistory(event: EventModel?, comment: String = "") {
        guard let event = event else { return }
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }

        let calendar = Calendar.current
        let now = Date()

        let isCompletedOnTime: Bool = {
            let eventDateOnly = calendar.startOfDay(for: event.date)
            let nowDateOnly = calendar.startOfDay(for: now)
            return nowDateOnly <= eventDateOnly
        }()

        let story = EventStoryModel(
            eventId: event.id,
            procedure: event.procedure,
            petId: event.petId,
            isCompleted: isCompletedOnTime,
            date: now,
            comment: comment
        )
        history.append(story)

        var updatedEvent = events[index]
        NotificationManager.shared.removeNotification(for: updatedEvent.id)
        updatedEvent.updateDateForNextOccurrence()
        events[index] = updatedEvent
        if updatedEvent.isNotificationEnabled {
            NotificationManager.shared.scheduleNotification(for: updatedEvent)
        }
    }

    func addEvent(_ event: EventModel) {
        events.append(event)
        if event.isNotificationEnabled && event.date > Date() {
            NotificationManager.shared.scheduleNotification(for: event)
        }
    }

    func updateEvent(_ event: EventModel) {
        guard let index = events.firstIndex(where: { $0.id == event.id }) else { return }

        let oldEvent = events[index]
        if oldEvent.isNotificationEnabled != event.isNotificationEnabled ||
            oldEvent.date != event.date ||
            oldEvent.procedure.name != event.procedure.name {
            NotificationManager.shared.removeNotification(for: event.id)
            if event.isNotificationEnabled && event.date > Date() {
                NotificationManager.shared.scheduleNotification(for: event)
            }
        }

        events[index] = event
    }
}
