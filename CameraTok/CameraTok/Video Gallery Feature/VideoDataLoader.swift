//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

public protocol VideoDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadVideoData(from videoId: String, withSize size: CGSize, completion: @escaping (Result) -> Void)
}
