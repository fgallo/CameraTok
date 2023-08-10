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
            rateState: viewModel.rateState,
            size: size,
            onRetry: { viewModel.loadImageData(size: size) }
        )
        .onAppear {
            viewModel.loadImageData(size: size)
            viewModel.loadRate()
        }
    }
}

struct GalleryCell: View {
    var state: GalleryCellViewModel<UIImage>.State
    var rateState: GalleryCellViewModel<UIImage>.RateState
    let size: CGSize
    var onRetry: () -> Void
    
    var body: some View {
        VStack {
            switch state {
            case .loading:
                loadingView
                
            case let .loaded(image, duration):
                imageView(image, duration)
                
            case .error:
                errorView
            }
        }
        .frame(width: size.width, height: size.height)
        .background(Color.gray.opacity(0.5))
    }
}

extension GalleryCell {
    var loadingView: some View {
        ProgressView()
    }
    
    var errorView: some View {
        Button {
            onRetry()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color.white)
        }
    }
    
    func imageView(_ image: UIImage, _ duration: String) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .overlay(Color.black.opacity(0.1))
            .overlay {
                ZStack {
                    if rateState != .undefined {
                        Image(systemName: rateState == .disliked ? "hand.thumbsdown.fill" : "hand.thumbsup.fill")
                            .padding(.bottom, 38)
                    }
                    
                    Text(duration)
                }
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            }
    }
}

struct GalleryCell_Previews: PreviewProvider {
    static var previews: some View {
        GalleryCell(
            state: .loading,
            rateState: .liked,
            size: CGSize(width: 100, height: 200),
            onRetry: {}
        )
    }
}
