//
//  CalculatorModel.swift
//  ChickenFeed
//
//  Created by Кирилл Архипов on 29.06.2025.
//

import Foundation
import SwiftUICore

struct EventModel: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var procedure: ProcedureModel
    var petId: UUID?
    var date: Date = Date()
    var isNotificationEnabled: Bool = false
    var timeRepeat: IntervalType = .day
    var procedureTime: ProcedureTime = .morning

    func status() -> EventStatus {
        let now = Date()
        let cal = Calendar.current

        if cal.isDateInToday(date) {
            return .today
        }
        if date < now {
            return .overdue
        }

        let days = cal.dateComponents([.day], from: now, to: date).day ?? 0
        if days <= 7 {
            return .upcoming(days, .day)
        }

        let weeks = cal.dateComponents([.weekOfYear], from: now, to: date).weekOfYear ?? 0
        if weeks <= 4 {
            return .upcoming(weeks, .week)
        }

        let months = cal.dateComponents([.month], from: now, to: date).month ?? 0
        if months <= 12 {
            return .upcoming(months, .month)
        }

        let years = cal.dateComponents([.year], from: now, to: date).year ?? 0
        return .upcoming(years, .year)
    }

    mutating func updateDateForNextOccurrence() {
        let calendar = Calendar.current
        let now = Date()

        if date >= now || calendar.isDateInToday(date) {
            if let nextDate = calendar.date(
                byAdding: timeRepeat.toComponent(),
                value: procedure.interval,
                to: date
            ) {
                date = nextDate
            }
        } else {
            calculateNextSuitableDate()
        }
    }

    private mutating func calculateNextSuitableDate() {
        let calendar = Calendar.current
        let now = Date()
        let component = timeRepeat.toComponent()

        var candidateDate = now
        var attempts = 0
        let maxAttempts = 1000

        while candidateDate <= date && attempts < maxAttempts {
            if let nextDate = calendar.date(
                byAdding: component,
                value: procedure.interval,
                to: candidateDate
            ) {
                candidateDate = nextDate
            }
            attempts += 1
        }

        date = candidateDate
    }
}

enum EventStatus {
    case today
    case overdue
    case upcoming(Int, IntervalType)

    var label: String {
        switch self {
        case .today:
            return "Today"
        case .overdue:
            return "Overdue"
        case .upcoming(let value, let type):
            return "in \(value) \(type.localizedUnit(value))"
        }
    }

    var color: Color {
        switch self {
        case .today: return .yellowMain
        case .overdue: return .red
        case .upcoming: return .greenMain
        }
    }
}
