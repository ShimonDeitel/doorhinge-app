import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [HingeFixEntry] = []
    @Published var isPro: Bool = false

    /// Free-tier cap. Kept comfortably above seed count so a fresh install
    /// never hits the paywall immediately.
    static let freeLimit = 8

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("doorhinge_entries.json")
        load()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(_ entry: HingeFixEntry) {
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: HingeFixEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: HingeFixEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([HingeFixEntry].self, from: data) else {
            seed()
            return
        }
        entries = decoded
    }

    private func seed() {
        entries = [
            HingeFixEntry(title: "Sample HingeFix 1", rating: 3, location: "Sample", fixUsed: "Sample", dateFixed: Date()),
            HingeFixEntry(title: "Sample HingeFix 2", rating: 4, location: "Sample", fixUsed: "Sample", dateFixed: Date()),
            HingeFixEntry(title: "Sample HingeFix 3", rating: 5, location: "Sample", fixUsed: "Sample", dateFixed: Date())
        ]
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
