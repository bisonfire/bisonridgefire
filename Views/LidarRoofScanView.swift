import SwiftUI
import ARKit

struct LidarRoofScanView: View {
    var body: some View {
        VStack {
            if ARWorldTrackingConfiguration.isSupported && ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
                Text("LiDAR scanning placeholder. Integrate ARViewRepresentable with raycasts and mesh capture.")
                    .padding()
            } else {
                Text("LiDAR not supported on this device.")
                    .padding()
            }
        }
        .navigationTitle("LiDAR Scan")
    }
}

