//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

public enum RetrieveCachedRatesResult {
    case empty
    case found([RateItem])
    case failure(Error)
}

public protocol RateStore {
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrieveCompletion = (RetrieveCachedRatesResult) -> Void

    func insert(_ rate: RateItem, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrieveCompletion)
}
