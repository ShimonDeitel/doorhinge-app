import Foundation

struct HingeFixEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var rating: Int = 3
    var dateAdded: Date = Date()
    var location: String
    var fixUsed: String
    var dateFixed: Date

    init(id: UUID = UUID(), title: String, rating: Int = 3, dateAdded: Date = Date(), location: String = "", fixUsed: String = "", dateFixed: Date = Date()) {
        self.id = id
        self.title = title
        self.rating = rating
        self.dateAdded = dateAdded
        self.location = location
        self.fixUsed = fixUsed
        self.dateFixed = dateFixed
    }
}
