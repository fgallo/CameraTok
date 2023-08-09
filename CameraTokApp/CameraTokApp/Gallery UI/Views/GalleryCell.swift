//
//  Created by Fernando Gallo on 08/08/23.
//

import SwiftUI

struct GalleryContainerCell: View {
    @StateObject var viewModel: GalleryCellViewModel<UIImage>
    let size: CGSize
    
    var body: some View {
        GalleryCell(
            state: viewModel.state,
            size: size,
            onRetry: { viewModel.loadImageData(size: size) }
        )
        .onAppear {
            viewModel.loadImageData(size: size)
        }
    }
}

struct GalleryCell: View {
    var state: GalleryCellViewModel<UIImage>.State
    let size: CGSize
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
        .frame(width: size.width, height: size.height)
        .background(Color.gray.opacity(0.5))
    }
}

struct GalleryCell_Previews: PreviewProvider {
    static var previews: some View {
        GalleryCell(state: .loading, size: CGSize(width: 100, height: 200), onRetry: {})
    }
}
