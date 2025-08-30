import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var images: [UIImage] = []

    var onImagesPicked: ([UIImage]) -> Void

    var body: some View {
        PhotosPicker(selection: $selectedItems, maxSelectionCount: 10, matching: .images) {
            Label("Add Photos", systemImage: "photo.on.rectangle")
        }
        .onChange(of: selectedItems) { _, newItems in
            Task {
                var loaded: [UIImage] = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let img = UIImage(data: data) {
                        loaded.append(img)
                    }
                }
                images = loaded
                onImagesPicked(loaded)
            }
        }
    }
}

