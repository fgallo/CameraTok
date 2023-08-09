//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation
import CameraTok

class GalleryCellViewModel<Image>: ObservableObject {
    private let model: VideoItem
    private let imageLoader: ThumbnailDataLoader
    private let imageTransformer: (Data) -> Image?
    
    @Published var state: State = .loading
    
    init(model: VideoItem, imageLoader: ThumbnailDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    func loadImageData(size: CGSize) {
        state = .loading
        imageLoader.loadThumbnailData(from: model.id, withSize: size) { result in
            guard let image = (try? result.get()).flatMap(self.imageTransformer) else {
                self.state = .error
                return
            }
            
            let duration = TimeFormatter.formatSecondsToHMS(self.model.duration)
            
            DispatchQueue.main.async {
                self.state = .loaded(image, duration)
            }
        }
    }
}

extension GalleryCellViewModel {
    enum State {
        case loading
        case loaded(_ image: Image, _ duration: String)
        case error
    }
}
