//
//  Created by Fernando Gallo on 08/08/23.
//

import SwiftUI
import CameraTok

public final class GalleryUIComposer {
    private init() {}
    
    static func galleryComposedWith(videoGalleryLoader: VideoGalleryLoader,
                                    imageDataLoader: ThumbnailDataLoader,
                                    selection: @escaping (Feed) -> Void) -> VideoGalleryContainerView {
        
        let videoGalleryViewModel = VideoGalleryViewModel(
            videoGalleryLoader: videoGalleryLoader
        )
        
        let videoGalleryView = VideoGalleryContainerView(
            viewModel: videoGalleryViewModel,
            makeVideoGalleryCell: adaptModelToCell(videoGalleryViewModel: videoGalleryViewModel, imageLoader: imageDataLoader),
            onModelSelection: { index in
                guard case .loaded(let items) = videoGalleryViewModel.state, index < items.count else {
                    return
                }
                
                selection(Feed(videoItems: items, startIndex: index))
            }
        )
        
        return videoGalleryView
    }
    
    private static func adaptModelToCell(videoGalleryViewModel: VideoGalleryViewModel, imageLoader: ThumbnailDataLoader) -> (Int, CGSize) -> VideoGalleryContainerCell? {
        return { index, size in
            guard case .loaded(let items) = videoGalleryViewModel.state, index < items.count else {
                return nil
            }
            
            let model = items[index]
            let videoGalleryCellViewModel = VideoGalleryCellViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init)
            return VideoGalleryContainerCell(viewModel: videoGalleryCellViewModel, size: size)
        }
    }
}
