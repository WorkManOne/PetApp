//
//  EventStoryModel.swift
//  PetApp
//
//  Created by Кирилл Архипов on 30.08.2025.
//
import Foundation

struct EventStoryModel: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var eventId: UUID
    var procedure: ProcedureModel
    var petId: UUID?
    var isCompleted: Bool
    var date: Date = Date()
    var comment: String
}
