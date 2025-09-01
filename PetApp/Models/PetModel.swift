import Foundation

struct PetModel: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String = ""
    var age: Int = 0
    var ageType: IntervalType = .day
    var imageData: Data?
}
