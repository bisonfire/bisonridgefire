import Foundation

struct QuickSprinklerInputs: Codable, Hashable {
    var roofAreaSquareFeet: Double
    var ridgeLengthFeet: Double
    var eaveLengthFeet: Double
    var nozzleSpacingFeet: Double // along ridge/eave
    var flowPerNozzleGPM: Double  // gallons per minute
}

struct QuickSprinklerOutputs: Codable, Hashable {
    var nozzleCount: Int
    var totalFlowGPM: Double
    var suggestedPumpHP: Double
    var suggestedTankGallons: Int
    var notes: String
}

final class EstimatingEngine {
    static let shared = EstimatingEngine()

    private init() {}

    func priceItem(catalogCode: String, quantity: Decimal, catalog: [CatalogItem]) -> EstimateItem? {
        guard let item = catalog.first(where: { $0.code == catalogCode }) else { return nil }
        let total = item.unitPrice * quantity
        return EstimateItem(
            id: UUID(),
            catalogCode: item.code,
            description: item.name,
            quantity: quantity,
            unit: item.unit,
            unitPrice: item.unitPrice,
            lineTotal: total
        )
    }

    func buildEstimate(items: [EstimateItem], taxRate: Decimal = 0.0) -> Estimate {
        let subtotal = items.map({ $0.lineTotal }).reduce(0, +)
        let tax = subtotal * taxRate
        let total = subtotal + tax
        return Estimate(id: UUID(), projectId: UUID(), version: 1, items: items, bundleType: nil, subtotal: subtotal, tax: tax, total: total, createdAt: Date())
    }

    // Very simple pump/tank sizing heuristic for proposal-only quick-calc
    func sprinklerQuickCalc(_ input: QuickSprinklerInputs) -> QuickSprinklerOutputs {
        let ridgeNozzles = Int(ceil(input.ridgeLengthFeet / input.nozzleSpacingFeet))
        let eaveNozzles = Int(ceil(input.eaveLengthFeet / input.nozzleSpacingFeet))
        let nozzleCount = max(1, ridgeNozzles + eaveNozzles)
        let totalFlow = Double(nozzleCount) * input.flowPerNozzleGPM

        // Pump HP rough estimate: HP = (Flow(GPM) * Pressure(psi)) / 1714 / efficiency
        // Assume 60 psi target, 55% efficiency; then round to nearest half HP above
        let assumedPressurePSI = 60.0
        let efficiency = 0.55
        let hpRaw = (totalFlow * assumedPressurePSI) / 1714.0 / efficiency
        let suggestedHP = (hpRaw * 2.0).rounded(.up) / 2.0

        // Tank sizing for 30 minutes runtime
        let minutes: Double = 30
        let gallons = Int(ceil(totalFlow * minutes))
        // round to common sizes
        let tankSuggested: Int
        if gallons <= 1000 { tankSuggested = 1000 }
        else if gallons <= 1500 { tankSuggested = 1500 }
        else if gallons <= 2000 { tankSuggested = 2000 }
        else if gallons <= 2500 { tankSuggested = 2500 }
        else { tankSuggested = Int(ceil(Double(gallons) / 500.0)) * 500 }

        return QuickSprinklerOutputs(
            nozzleCount: nozzleCount,
            totalFlowGPM: totalFlow,
            suggestedPumpHP: suggestedHP,
            suggestedTankGallons: tankSuggested,
            notes: "Preliminary values for proposal only. Subject to engineering validation."
        )
    }
}

// Decimal helpers
fileprivate func + (lhs: Decimal, rhs: Decimal) -> Decimal { var x = lhs; x += rhs; return x }
fileprivate func * (lhs: Decimal, rhs: Decimal) -> Decimal { var x = lhs; x *= rhs; return x }
