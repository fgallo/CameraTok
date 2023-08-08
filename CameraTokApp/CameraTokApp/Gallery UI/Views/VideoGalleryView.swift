//
//  Created by Fernando Gallo on 07/08/23.
//

import SwiftUI

struct VideoGalleryContainerView: View {
    @StateObject var viewModel: VideoGalleryViewModel
    let makeVideoGalleryCell: (Int, Double) -> VideoGalleryContainerCell?
    
    var body: some View {
        VideoGalleryView(
            startDate: $viewModel.startDate,
            state: viewModel.state,
            makeVideoGalleryCell: makeVideoGalleryCell
        )
        .onAppear {
            viewModel.loadGallery()
        }
    }
}

struct VideoGalleryView: View {
    @Binding var startDate: Date
    let state: VideoGalleryViewModel.State
    let makeVideoGalleryCell: (Int, Double) -> VideoGalleryContainerCell?
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
                                makeVideoGalleryCell(index, geo.size.width)
                            }
                            .cornerRadius(0)
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
                
            case let .error(error as NSError):
                Text("\(error.domain)")
            }
        }
        
        DatePicker("Start Date", selection: $startDate)
    }
}

struct VideoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGalleryView(
            startDate: .constant(Date()),
            state: .loading,
            makeVideoGalleryCell: { _, _ in nil }
        )
    }
}