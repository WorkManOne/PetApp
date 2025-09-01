
import Foundation

struct CategoryModel: Identifiable, Codable, Equatable, Hashable {
    var id: UUID = UUID()
    var name: String = "My category"
}
