//
//  Created by Fernando Gallo on 07/08/23.
//

import SwiftUI

struct VideoGalleryContainerView: View {
    @StateObject var viewModel: VideoGalleryViewModel
    let makeVideoGalleryCell: (Int, CGSize) -> VideoGalleryContainerCell?
    
    var body: some View {
        VideoGalleryView(
            state: viewModel.state,
            makeVideoGalleryCell: makeVideoGalleryCell
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

struct VideoGalleryView: View {
    let state: VideoGalleryViewModel.State
    let makeVideoGalleryCell: (Int, CGSize) -> VideoGalleryContainerCell?
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
                            GeometryReader { geo in
                                let size = CGSize(width: geo.size.width, height: geo.size.width * 2)
                                makeVideoGalleryCell(index, size)
                            }
                            .cornerRadius(0)
                            .aspectRatio(0.5, contentMode: .fit)
                        }
                    }
                }
                
            case let .error(error as NSError):
                Text("\(error.domain)")
            }
        }
    }
}

struct VideoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGalleryView(
            state: .loading,
            makeVideoGalleryCell: { _, _ in nil }
        )
    }
}
