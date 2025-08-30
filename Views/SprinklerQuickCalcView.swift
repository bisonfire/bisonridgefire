import SwiftUI

struct SprinklerQuickCalcView: View {
    @State private var roofArea: String = "1800"
    @State private var ridgeFeet: String = "60"
    @State private var eaveFeet: String = "120"
    @State private var spacingFeet: String = "12"
    @State private var flowPerNozzle: String = "3.0"

    @State private var result: QuickSprinklerOutputs?

    var body: some View {
        Form {
            Section("Inputs") {
                TextField("Roof Area (sqft)", text: $roofArea)
                    .keyboardType(.decimalPad)
                TextField("Ridge Length (ft)", text: $ridgeFeet)
                    .keyboardType(.decimalPad)
                TextField("Eave Length (ft)", text: $eaveFeet)
                    .keyboardType(.decimalPad)
                TextField("Nozzle Spacing (ft)", text: $spacingFeet)
                    .keyboardType(.decimalPad)
                TextField("Flow per Nozzle (GPM)", text: $flowPerNozzle)
                    .keyboardType(.decimalPad)
                Button("Calculate") { calculate() }
            }

            if let r = result {
                Section("Outputs") {
                    LabeledContent("Nozzle Count", value: "\(r.nozzleCount)")
                    LabeledContent("Total Flow (GPM)", value: String(format: "%.1f", r.totalFlowGPM))
                    LabeledContent("Suggested Pump (HP)", value: String(format: "%.1f", r.suggestedPumpHP))
                    LabeledContent("Suggested Tank (gal)", value: "\(r.suggestedTankGallons)")
                    Text(r.notes).font(.footnote).foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Sprinkler Quick-Calc")
    }

    private func calculate() {
        let input = QuickSprinklerInputs(
            roofAreaSquareFeet: Double(roofArea) ?? 0,
            ridgeLengthFeet: Double(ridgeFeet) ?? 0,
            eaveLengthFeet: Double(eaveFeet) ?? 0,
            nozzleSpacingFeet: max(1.0, Double(spacingFeet) ?? 12.0),
            flowPerNozzleGPM: max(0.1, Double(flowPerNozzle) ?? 3.0)
        )
        result = EstimatingEngine.shared.sprinklerQuickCalc(input)
    }
}

