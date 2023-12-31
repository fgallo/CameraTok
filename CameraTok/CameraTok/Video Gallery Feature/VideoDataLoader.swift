//
//  Created by Fernando Gallo on 08/08/23.
//

import Foundation

public protocol VideoDataLoader {
    typealias Result = Swift.Result<URL, Error>
    
    func loadVideoData(from videoId: String, completion: @escaping (Result) -> Void)
}
