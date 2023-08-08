//
//  Created by Fernando Gallo on 08/08/23.
//

import SwiftUI

struct VideoGalleryContainerCell: View {
    @StateObject var viewModel: VideoGalleryCellViewModel<UIImage>
    let size: Double
    
    var body: some View {
        VideoGalleryCell(
            state: viewModel.state,
            size: size,
            onRetry: { viewModel.loadImageData(size: CGSize(width: size, height: size)) }
        )
        .onAppear {
            viewModel.loadImageData(size: CGSize(width: size, height: size))
        }
    }
}

struct VideoGalleryCell: View {
    var state: VideoGalleryCellViewModel<UIImage>.State
    let size: Double
    var onRetry: () -> Void
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                ProgressView()
            case let .loaded(image, duration):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .overlay(Color.black.opacity(0.1))
                    .overlay(
                        Text(duration)
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .padding(4)
                    )
            case .error:
                Button {
                    onRetry()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundColor(Color.white)
                }
            }
        }
        .frame(width: size, height: size)
        .background(Color.gray.opacity(0.5))
    }
}

struct VideoGalleryCell_Previews: PreviewProvider {
    static var previews: some View {
        VideoGalleryCell(state: .loading, size: 200, onRetry: {})
    }
}
