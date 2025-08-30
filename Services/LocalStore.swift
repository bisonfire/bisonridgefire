import Foundation

/// Very simple JSON file persistence for offline-first data.
final class LocalStore: ObservableObject {
    static let shared = LocalStore()

    private let fileManager = FileManager.default
    private let baseURL: URL

    @Published var projects: [Project] = []
    @Published var geometries: [GeometryRecord] = []
    @Published var photos: [PhotoTag] = []
    @Published var estimates: [Estimate] = []
    @Published var catalog: [CatalogItem] = []

    init() {
        self.baseURL = LocalStore.makeBaseURL()
        loadAll()
    }

    private static func makeBaseURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let dir = urls[0].appendingPathComponent("LocalStore", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    // MARK: - Public API

    func saveProject(_ project: Project) {
        if let idx = projects.firstIndex(where: { $0.id == project.id }) {
            projects[idx] = project
        } else {
            projects.append(project)
        }
        persist("projects.json", value: projects)
    }

    func saveGeometry(_ geometry: GeometryRecord) {
        if let idx = geometries.firstIndex(where: { $0.id == geometry.id }) {
            geometries[idx] = geometry
        } else {
            geometries.append(geometry)
        }
        persist("geometries.json", value: geometries)
    }

    func saveEstimate(_ estimate: Estimate) {
        if let idx = estimates.firstIndex(where: { $0.id == estimate.id }) {
            estimates[idx] = estimate
        } else {
            estimates.append(estimate)
        }
        persist("estimates.json", value: estimates)
    }

    func loadAll() {
        projects = load("projects.json") ?? []
        geometries = load("geometries.json") ?? []
        photos = load("photos.json") ?? []
        estimates = load("estimates.json") ?? []
        catalog = load("catalog.json") ?? defaultCatalog()
    }

    // MARK: - Helpers

    private func persist<T: Encodable>(_ filename: String, value: T) {
        let url = baseURL.appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            print("LocalStore persist error for \(filename): \(error)")
        }
    }

    private func load<T: Decodable>(_ filename: String) -> T? {
        let url = baseURL.appendingPathComponent(filename)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("LocalStore load error for \(filename): \(error)")
            return nil
        }
    }

    private func defaultCatalog() -> [CatalogItem] {
        return [
            CatalogItem(id: UUID(), code: "PUMP-1", name: "Wildfire Pump 5HP", unit: "ea", unitPrice: 2500, category: "Equipment"),
            CatalogItem(id: UUID(), code: "TANK-2K", name: "Poly Tank 2000 gal", unit: "ea", unitPrice: 3400, category: "Equipment"),
            CatalogItem(id: UUID(), code: "PIPE-1", name: "1in PVC Schedule 40", unit: "ft", unitPrice: 1.25, category: "Materials"),
            CatalogItem(id: UUID(), code: "NOZZLE-R", name: "Roof Nozzle", unit: "ea", unitPrice: 45, category: "Materials"),
            CatalogItem(id: UUID(), code: "LABOR-GEN", name: "General Labor", unit: "hr", unitPrice: 85, category: "Labor")
        ]
    }
}

