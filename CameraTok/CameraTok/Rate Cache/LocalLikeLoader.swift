//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

public final class LocalLikeLoader: RateCache {
    private let store: RateStore
    
    public init(store: RateStore) {
        self.store = store
    }
    
    public func save(_ videoRate: RateItem, completion: @escaping (RateCache.SaveResult) -> Void) {
        cache(videoRate, with: completion)
    }
    
    public func load(_ videoId: String, completion: @escaping (RateCache.LoadResult) -> Void) {
        store.retrieve(videoId) { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .empty:
                completion(.success(nil))
            case let .found(item):
                completion(.success(item))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ videoRate: RateItem, with completion: @escaping (RateCache.SaveResult) -> Void) {
        store.insert(videoRate) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}
