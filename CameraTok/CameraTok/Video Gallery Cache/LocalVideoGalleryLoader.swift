//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation

public final class LocalVideoGalleryLoader: VideoGalleryLoader {
    private let videoLibrary: VideoLibrary
    
    public init(videoLibrary: VideoLibrary) {
        self.videoLibrary = videoLibrary
    }
    
    public func load(with startDate: Date, completion: @escaping (VideoGalleryLoader.Result) -> Void) {
        if !videoLibrary.isPhotoAccessAuthorized() {
            videoLibrary.requestAuthorization { authorized in
                if authorized {
                    completion(.success(self.fetchAssetsAndMapToModel(startDate)))
                } else {
                    completion(.failure(NSError(domain: "Please, you need to allow access to your gallery.", code: 0)))
                }
            }
        } else {
            completion(.success(fetchAssetsAndMapToModel(startDate)))
        }
    }
    
    private func fetchAssetsAndMapToModel(_ startDate: Date) -> [VideoItem] {
        let assets = videoLibrary.fetchVideoAssets(startDate: startDate)
        let videoItems = assets.map { VideoItem(id: $0.localIdentifier, duration: $0.duration, creationDate: $0.creationDate ?? Date()) }
        return videoItems
    }
}
