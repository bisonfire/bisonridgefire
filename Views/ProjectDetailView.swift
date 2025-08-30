import SwiftUI

struct ProjectDetailView: View {
    @ObservedObject var store = LocalStore.shared
    let project: Project
    @State private var showPhotos = false
    @State private var attached: [UIImage] = []

    var body: some View {
        List {
            Section("Info") {
                LabeledContent("Name", value: project.name)
                if let client = project.clientName { LabeledContent("Client", value: client) }
                if let address = project.address { LabeledContent("Address", value: address) }
            }

            Section("Photos") {
                if attached.isEmpty {
                    Text("No photos yet")
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(attached.indices, id: \.self) { idx in
                                Image(uiImage: attached[idx])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(height: 140)
                }
                PhotoPicker { images in
                    attached.append(contentsOf: images)
                }
            }
        }
        .navigationTitle("Project")
    }
}

