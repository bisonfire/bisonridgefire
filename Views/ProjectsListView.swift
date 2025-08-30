import SwiftUI

struct ProjectsListView: View {
    @ObservedObject var store = LocalStore.shared
    @State private var isPresentingNew = false

    var body: some View {
        List {
            ForEach(store.projects) { project in
                NavigationLink(value: project) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(project.name).font(.headline)
                        if let address = project.address { Text(address).font(.subheadline).foregroundStyle(.secondary) }
                    }
                }
            }
        }
        .navigationDestination(for: Project.self) { project in
            ProjectDetailView(project: project)
        }
        .toolbar {
            Button {
                isPresentingNew = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isPresentingNew) {
            NewProjectSheet(isPresented: $isPresentingNew)
        }
    }
}

struct NewProjectSheet: View {
    @ObservedObject var store = LocalStore.shared
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var client: String = ""
    @State private var address: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Project Name", text: $name)
                TextField("Client Name", text: $client)
                TextField("Address", text: $address)
            }
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let now = Date()
                        let p = Project(
                            id: UUID(),
                            createdAt: now,
                            updatedAt: now,
                            name: name.isEmpty ? "Untitled Project" : name,
                            clientName: client.isEmpty ? nil : client,
                            address: address.isEmpty ? nil : address,
                            latitude: nil,
                            longitude: nil,
                            notes: nil
                        )
                        store.saveProject(p)
                        isPresented = false
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

