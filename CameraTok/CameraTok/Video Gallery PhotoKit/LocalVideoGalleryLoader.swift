//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation

public final class LocalVideoGalleryLoader: VideoGalleryLoader {
    private let videoLibrary: VideoLibrary
    
    init(videoLibrary: VideoLibrary) {
        self.videoLibrary = videoLibrary
    }
    
    public func load(with startDate: Date, completion: @escaping (VideoGalleryLoader.Result) -> Void) {
        guard videoLibrary.isPhotoAccessAuthorized() else {
            let error = NSError(domain: "Access to device gallery is not allowed.", code: 0)
            completion(.failure(error))
            return
        }
        
        let assets = videoLibrary.fetchVideoAssets(startDate: startDate)
        let videoItems = assets.map { VideoItem(id: $0.localIdentifier, duration: $0.duration, liked: false) }
        
        completion(.success(videoItems))
    }
}
