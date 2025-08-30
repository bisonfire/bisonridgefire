import SwiftUI

struct AboutEmbesafeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Embesafe Wildfire Protection")
                    .font(.title)
                    .bold()
                Text("Embesafe delivers practical wildfire risk mitigation, roof sprinkler solutions, and advisory proposals. Field-ready tools support map and LiDAR measurements, quick sizing, and branded estimates.")
                Divider()
                Text("Compliance & Safety")
                    .font(.headline)
                Text("All proposal outputs are advisory and require professional engineering validation. Weather, access, and site conditions affect design.")
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

