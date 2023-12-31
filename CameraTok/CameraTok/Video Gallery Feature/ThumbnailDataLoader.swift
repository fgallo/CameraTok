//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation

public protocol ThumbnailDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadThumbnailData(from videoId: String, withSize size: CGSize, completion: @escaping (Result) -> Void)
}
