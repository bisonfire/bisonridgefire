import SwiftUI
import MapKit

struct MapMeasureView: View {
    @State private var mapPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var coordinates: [CLLocationCoordinate2D] = []
    @State private var areaSquareMeters: Double = 0
    @State private var lengthMeters: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            Map(position: $mapPosition, interactionModes: .all, showsUserLocation: true) {
                if coordinates.count >= 2 {
                    let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
                    MapPolyline(Polyline(polyline))
                        .stroke(.blue, lineWidth: 3)
                }
                if coordinates.count >= 3 {
                    let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
                    MapPolygon(Polygon(polygon))
                        .foregroundStyle(.blue.opacity(0.2))
                        .stroke(.blue, lineWidth: 2)
                }
                ForEach(Array(coordinates.enumerated()), id: \.offset) { _, c in
                    Annotation("", coordinate: c) {
                        Circle().fill(.red).frame(width: 8, height: 8)
                    }
                }
            }
            .onTapGesture(perform: handleTap)
            .overlay(alignment: .topLeading) {
                VStack(alignment: .leading) {
                    Text("Perimeter: \(formatMeters(lengthMeters))")
                    Text("Area: \(formatArea(areaSquareMeters))")
                }
                .padding(8)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding()
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Button("Undo") { if !coordinates.isEmpty { coordinates.removeLast(); recalc() } }
                        .buttonStyle(.bordered)
                    Button("Clear") { coordinates.removeAll(); recalc() }
                        .buttonStyle(.bordered)
                    Spacer()
                    Button("Close") { closePolygon() }
                        .buttonStyle(.borderedProminent)
                        .disabled(coordinates.count < 3)
                }
                .padding()
            }
        }
        .navigationTitle("Map Measure")
    }

    private func handleTap() {
        // SwiftUI Map doesn't expose tap coordinate directly yet; placeholder for integration
        // In a production build, use a UIViewRepresentable MKMapView + gesture recognizer to obtain coordinate.
    }

    private func closePolygon() {
        if coordinates.count >= 3 {
            coordinates.append(coordinates.first!)
            recalc()
        }
    }

    private func recalc() {
        lengthMeters = perimeter(of: coordinates)
        areaSquareMeters = polygonArea(of: coordinates)
    }

    private func formatMeters(_ meters: Double) -> String {
        if meters > 1000 { return String(format: "%.2f km", meters / 1000.0) }
        return String(format: "%.0f m", meters)
    }

    private func formatArea(_ sqm: Double) -> String {
        if sqm > 1_000_000 { return String(format: "%.2f km²", sqm / 1_000_000.0) }
        if sqm > 10_000 { return String(format: "%.2f ha", sqm / 10_000.0) }
        return String(format: "%.0f m²", sqm)
    }
}

// Basic geodesic perimeter using Haversine
private func perimeter(of coords: [CLLocationCoordinate2D]) -> Double {
    guard coords.count >= 2 else { return 0 }
    var total: Double = 0
    for i in 1..<coords.count {
        total += haversineDistance(coords[i-1], coords[i])
    }
    return total
}

private func polygonArea(of coords: [CLLocationCoordinate2D]) -> Double {
    // Approximate area using spherical excess on WGS84 assumed sphere radius
    // Requires closed polygon
    guard coords.count >= 4 else { return 0 }
    let radius = 6_371_000.0
    var area = 0.0
    for i in 0..<(coords.count - 1) {
        let p1 = coords[i]
        let p2 = coords[i+1]
        area += degreesToRadians(p2.longitude - p1.longitude) * (2 + sin(degreesToRadians(p1.latitude)) + sin(degreesToRadians(p2.latitude)))
    }
    area = -area * radius * radius / 2.0
    return abs(area)
}

private func haversineDistance(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D) -> Double {
    let R = 6_371_000.0
    let dLat = degreesToRadians(b.latitude - a.latitude)
    let dLon = degreesToRadians(b.longitude - a.longitude)
    let lat1 = degreesToRadians(a.latitude)
    let lat2 = degreesToRadians(b.latitude)
    let h = sin(dLat/2)*sin(dLat/2) + cos(lat1)*cos(lat2)*sin(dLon/2)*sin(dLon/2)
    let c = 2 * atan2(sqrt(h), sqrt(1-h))
    return R * c
}

private func degreesToRadians(_ deg: Double) -> Double { deg * .pi / 180 }

