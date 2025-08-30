import Foundation

struct Project: Identifiable, Codable, Hashable {
    var id: UUID
    var createdAt: Date
    var updatedAt: Date
    var name: String
    var clientName: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var notes: String?
}

struct GeometryRecord: Identifiable, Codable, Hashable {
    var id: UUID
    var projectId: UUID
    var type: GeometryType
    var coordinates: [[Double]] // [ [lon, lat], ... ] for Polygon/LineString
    var areaSquareMeters: Double?
    var lengthMeters: Double?
    var accuracyBadge: String?
    var createdAt: Date
}

enum GeometryType: String, Codable {
    case polygon
    case lineString
    case point
}

struct PhotoTag: Identifiable, Codable, Hashable {
    var id: UUID
    var projectId: UUID
    var url: URL
    var caption: String?
    var latitude: Double?
    var longitude: Double?
    var createdAt: Date
}

struct Estimate: Identifiable, Codable, Hashable {
    var id: UUID
    var projectId: UUID
    var version: Int
    var items: [EstimateItem]
    var bundleType: BundleType?
    var subtotal: Decimal
    var tax: Decimal
    var total: Decimal
    var createdAt: Date
}

struct EstimateItem: Identifiable, Codable, Hashable {
    var id: UUID
    var catalogCode: String
    var description: String
    var quantity: Decimal
    var unit: String
    var unitPrice: Decimal
    var lineTotal: Decimal
}

enum BundleType: String, Codable {
    case good
    case better
    case best
}

struct CatalogItem: Identifiable, Codable, Hashable {
    var id: UUID
    var code: String
    var name: String
    var unit: String
    var unitPrice: Decimal
    var category: String
}

