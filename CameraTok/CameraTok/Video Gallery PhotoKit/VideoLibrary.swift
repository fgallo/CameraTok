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
