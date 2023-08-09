//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation
import Photos

public protocol VideoLibrary {
    func isPhotoAccessAuthorized() -> Bool
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func fetchVideoAssets(startDate: Date) -> [PHAsset]
}

public protocol VideoDataLibrary {
    func fetchVideoAsset(id: String) -> PHAsset
    func getThumbnailDataFromAsset(_ asset: PHAsset, size: CGSize, completion: @escaping (Data?) -> Void)
    func getVideoDataFromAsset(_ asset: PHAsset, completion: @escaping (Data?) -> Void)
}
