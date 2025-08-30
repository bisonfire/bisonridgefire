import SwiftUI

struct EstimateBuilderView: View {
    @ObservedObject var store = LocalStore.shared
    @State private var selectedBundle: BundleType = .good
    @State private var items: [EstimateItem] = []
    @State private var subtotal: Decimal = 0

    var body: some View {
        Form {
            Section("Bundle") {
                Picker("Type", selection: $selectedBundle) {
                    Text("Good").tag(BundleType.good)
                    Text("Better").tag(BundleType.better)
                    Text("Best").tag(BundleType.best)
                }
                .pickerStyle(.segmented)
                Button("Load Template") { loadBundleTemplate() }
            }

            Section("Items") {
                if items.isEmpty {
                    Text("No items yet")
                } else {
                    ForEach(items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.description)
                                Text("\(item.quantity.description) \(item.unit) × $\(item.unitPrice)")
                                    .font(.footnote).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("$\(item.lineTotal as NSNumber, formatter: currencyFormatter)")
                        }
                    }
                }
            }

            Section("Totals") {
                LabeledContent("Subtotal", value: "$\(subtotal as NSNumber, formatter: currencyFormatter)")
            }

            Section {
                Button("Save Draft Estimate") { saveEstimate() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("Estimate Builder")
    }

    private func loadBundleTemplate() {
        // Simple templates: Good adds pump + nozzles, Better adds tank, Best adds extra labor
        let catalog = store.catalog
        var loaded: [EstimateItem] = []
        func add(_ code: String, qty: Decimal) {
            if let item = EstimatingEngine.shared.priceItem(catalogCode: code, quantity: qty, catalog: catalog) {
                loaded.append(item)
            }
        }
        switch selectedBundle {
        case .good:
            add("PUMP-1", 1)
            add("NOZZLE-R", 10)
            add("PIPE-1", 200)
        case .better:
            add("PUMP-1", 1)
            add("TANK-2K", 1)
            add("NOZZLE-R", 12)
            add("PIPE-1", 250)
        case .best:
            add("PUMP-1", 1)
            add("TANK-2K", 1)
            add("NOZZLE-R", 16)
            add("PIPE-1", 350)
            add("LABOR-GEN", 16)
        }
        items = loaded
        subtotal = items.map({ $0.lineTotal }).reduce(0, +)
    }

    private func saveEstimate() {
        let est = EstimatingEngine.shared.buildEstimate(items: items, taxRate: 0)
        LocalStore.shared.saveEstimate(est)
    }
}

fileprivate var currencyFormatter: NumberFormatter {
    let nf = NumberFormatter()
    nf.numberStyle = .currency
    return nf
}

