import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MeasureHomeView()
                .tabItem {
                    Label("Measure", systemImage: "ruler")
                }

            ProjectsView()
                .tabItem {
                    Label("Projects", systemImage: "folder")
                }

            EstimatesView()
                .tabItem {
                    Label("Estimates", systemImage: "doc.text")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct MeasureHomeView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Map Measurement", destination: MapMeasureView())
                NavigationLink("LiDAR Roof Scan", destination: LidarRoofScanView())
                NavigationLink("Sprinkler Quick-Calc", destination: SprinklerQuickCalcView())
            }
            .navigationTitle("Measure")
        }
    }
}

struct ProjectsView: View {
    var body: some View {
        NavigationStack {
            ProjectsListView()
                .navigationTitle("Projects")
        }
    }
}

struct EstimatesView: View {
    var body: some View {
        NavigationStack {
            EstimateBuilderView()
                .navigationTitle("Estimates")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Proposal PDF Preview", destination: PDFProposalView())
                Text("Settings and sync options")
            }
                .navigationTitle("Settings")
        }
    }
}

struct MapMeasurePlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "map")
                .font(.system(size: 48))
            Text("Map measurement UI coming next: polygon drawing, area/length")
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Map Measure")
    }
}

struct LidarMeasurePlaceholder: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "viewfinder")
                .font(.system(size: 48))
            Text("LiDAR roof scan UI coming next: ridge/eave, roof area")
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("LiDAR Scan")
    }
}

 

