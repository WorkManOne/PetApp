//
//  MatchModel.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 23.06.2025.
//

import Foundation

struct ProcedureModel: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var category: CategoryModel? = nil
    var interval: Int = 7
    var intervalType: IntervalType = .day
    var procedureTime: ProcedureTime = .morning
}

enum ProcedureTime: String, Codable, CaseIterable {
    case morning = "Morning"
    case day = "Day"
    case evening = "Evening"
}

enum IntervalType: String, Codable, CaseIterable {
    case day = "Day"
    case week = "Week"
    case hour = "Hour"
    case month = "Month"
    case year = "Year"
    
    func toComponent() -> Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .hour: return .hour
        case .month: return .month
        case .year: return .year
        }
    }
    
    func localizedUnit(_ value: Int) -> String {
        switch self {
        case .day: return value == 1 ? "day" : "days"
        case .week: return value == 1 ? "week" : "weeks"
        case .hour: return value == 1 ? "hour" : "hours"
        case .month: return value == 1 ? "month" : "months"
        case .year: return value == 1 ? "year" : "years"
        }
    }
}
