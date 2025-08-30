import SwiftUI
import PDFKit

struct PDFProposalView: View {
    @ObservedObject var store = LocalStore.shared
    @State private var pdfData: Data?

    var body: some View {
        VStack {
            HStack {
                Button("Generate Sample Proposal") { generate() }
                    .buttonStyle(.borderedProminent)
                Spacer()
                if let data = pdfData {
                    ShareLink(item: data, preview: .init("Proposal.pdf")) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .padding()
            Divider()
            if let data = pdfData, let pdf = PDFDocument(data: data) {
                PDFKitRepresentedView(pdf: pdf)
            } else {
                Text("No PDF yet")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Proposal PDF")
    }

    private func generate() {
        let meta = [
            "title": "Wildfire Roof Sprinkler Proposal",
            "company": "Your Company",
            "disclaimer": "This proposal is advisory. Final design requires professional engineering review."
        ]
        let renderer = ProposalPDFRenderer()
        pdfData = renderer.renderSimple(meta: meta, items: store.catalog.prefix(3).map { $0.name })
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdf: PDFDocument
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdf
        pdfView.autoScales = true
        return pdfView
    }
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

final class ProposalPDFRenderer {
    func renderSimple(meta: [String: String], items: [String]) -> Data {
        let format = UIGraphicsPDFRendererFormat()
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        return renderer.pdfData { ctx in
            ctx.beginPage()
            let title = meta["title"] ?? "Proposal"
            let company = meta["company"] ?? "Company"
            let disclaimer = meta["disclaimer"] ?? ""
            let margin: CGFloat = 36
            var y: CGFloat = margin

            draw(text: company, at: CGPoint(x: margin, y: y), font: .boldSystemFont(ofSize: 18))
            y += 28
            draw(text: title, at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 24, weight: .semibold))
            y += 36
            draw(text: "Scope Items:", at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 16, weight: .semibold))
            y += 20
            for item in items {
                draw(text: "• \(item)", at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 14))
                y += 18
            }
            y += 24
            draw(text: "Notes & Disclaimers:", at: CGPoint(x: margin, y: y), font: .systemFont(ofSize: 16, weight: .semibold))
            y += 20
            drawWrapped(text: disclaimer, in: CGRect(x: margin, y: y, width: pageRect.width - margin*2, height: 200), font: .systemFont(ofSize: 12))
        }
    }

    private func draw(text: String, at point: CGPoint, font: UIFont) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black
        ]
        text.draw(at: point, withAttributes: attrs)
    }

    private func drawWrapped(text: String, in rect: CGRect, font: UIFont) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ]
        (text as NSString).draw(in: rect, withAttributes: attrs)
    }
}

