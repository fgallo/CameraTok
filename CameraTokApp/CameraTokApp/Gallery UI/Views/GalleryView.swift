//
//  Created by Fernando Gallo on 07/08/23.
//

import SwiftUI

struct GalleryContainerView: View {
    @StateObject var viewModel: GalleryViewModel
    let makeVideoGalleryCell: (Int, CGSize) -> GalleryContainerCell?
    let onModelSelection: (Int) -> Void
    
    var body: some View {
        GalleryView(
            state: viewModel.state,
            makeVideoGalleryCell: makeVideoGalleryCell,
            onModelSelection: onModelSelection
        )
        .onAppear {
            viewModel.loadGallery()
        }
        .navigationTitle("CameraTok")
        .toolbar {
            DatePicker("", selection: $viewModel.startDate, displayedComponents: .date)
        }
    }
}

struct GalleryView: View {
    let state: GalleryViewModel.State
    let makeVideoGalleryCell: (Int, CGSize) -> GalleryContainerCell?
    let onModelSelection: (Int) -> Void
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 2), count: 3)
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                VStack {
                    Spacer()
                    ProgressView("Loading Gallery")
                    Spacer()
                }
                
            case let .loaded(items):
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(items.indices, id: \.self) { index in
                            Button {
                                onModelSelection(index)
                            } label: {
                                GeometryReader { geo in
                                    let size = CGSize(width: geo.size.width, height: geo.size.width * 2)
                                    makeVideoGalleryCell(index, size)
                                }
                                .cornerRadius(0)
                                .aspectRatio(0.5, contentMode: .fit)
                            }
                        }
                    }
                }
                
            case let .error(error as NSError):
                Text("\(error.domain)")
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(
            state: .loading,
            makeVideoGalleryCell: { _, _ in nil },
            onModelSelection: { _ in }
        )
    }
}
