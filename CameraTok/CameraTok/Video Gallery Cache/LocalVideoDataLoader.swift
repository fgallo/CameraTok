//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

public final class LocalVideoDataLoader: VideoDataLoader {
    private let videoLibrary: VideoLibrary
    private let videoDataLibrary: VideoDataLibrary
    
    public init(videoLibrary: VideoLibrary, videoDataLibrary: VideoDataLibrary) {
        self.videoLibrary = videoLibrary
        self.videoDataLibrary = videoDataLibrary
    }
    
    public func loadVideoData(from videoId: String, completion: @escaping (VideoDataLoader.Result) -> Void) {
        guard videoLibrary.isPhotoAccessAuthorized() else {
            let error = NSError(domain: "Access to device gallery is not allowed.", code: 0)
            completion(.failure(error))
            return
        }
        
        let asset = videoDataLibrary.fetchVideoAsset(id: videoId)
        
        videoDataLibrary.getVideoURLFromAsset(asset) { url in
            guard let url = url else {
                let error = NSError(domain: "It was not possible to retrieve video url from this asset.", code: 0)
                completion(.failure(error))
                return
            }
            
            completion(.success(url))
        }
    }
}
