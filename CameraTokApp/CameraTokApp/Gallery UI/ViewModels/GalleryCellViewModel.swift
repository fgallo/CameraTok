//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation
import CameraTok

class GalleryCellViewModel<Image>: ObservableObject {
    private let model: VideoItem
    private let imageLoader: ThumbnailDataLoader
    private let rateCache: RateCache
    private let imageTransformer: (Data) -> Image?
    
    @Published var state: State = .loading
    @Published var rateState: RateState = .undefined
    
    init(model: VideoItem, imageLoader: ThumbnailDataLoader, rateCache: RateCache, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.rateCache = rateCache
        self.imageTransformer = imageTransformer
    }
    
    func loadImageData(size: CGSize) {
        state = .loading
        imageLoader.loadThumbnailData(from: model.id, withSize: size) { [weak self] result in
            guard let self = self else { return }
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
    
    func loadRate() {
        rateCache.load(model.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(item):
                DispatchQueue.main.async {
                    guard let item = item else {
                        self.rateState = .undefined
                        return
                    }
                    
                    self.rateState = self.rateToRateState(item.rate)
                }
                
            case .failure:
                DispatchQueue.main.async {
                    self.rateState = .undefined
                }
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

extension GalleryCellViewModel {
    enum RateState {
        case liked
        case disliked
        case undefined
    }
    
    private func rateToRateState(_ rate: Rate) -> RateState {
        switch rate {
        case .like:
            return .liked
            
        case .dislike:
            return .disliked
        }
    }
}
