//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Photos
import PhotosUI

public final class PhotoKitVideoDataLibrary: VideoDataLibrary {
    public init() {}
    
    public func fetchVideoAsset(id: String) -> PHAsset {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
        let asset = result.object(at: 0)
        
        return asset
    }
    
    public func getThumbnailDataFromAsset(_ asset: PHAsset, size: CGSize, completion: @escaping (Data?) -> Void) {
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { image, info in
            completion(image?.pngData())
        }
    }
    
    public func getVideoURLFromAsset(_ asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true

        let imageManager = PHCachingImageManager()
        imageManager.requestAVAsset(forVideo: asset, options: options) { avAsset, audioMix, info in
            let url = (avAsset as? AVURLAsset)?.url
            completion(url)
        }
    }
}
