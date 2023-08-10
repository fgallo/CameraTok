//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

public enum Rate: Codable {
    case like
    case dislike
}

public protocol RateCache {
    typealias SaveResult = Error?
    typealias LoadResult = Swift.Result<RateItem?, Error>
    
    func save(_ videoRate: RateItem, completion: @escaping (SaveResult) -> Void)
    func load(_ videoId: String, completion: @escaping (LoadResult) -> Void)
}
