//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

public final class LocalLikeLoader: VideoRateAction {
    private let store: RateStore
    
    public init(store: RateStore) {
        self.store = store
    }
    
    public func save(_ videoRate: RateItem, completion: @escaping (VideoRateAction.SaveResult) -> Void) {
        cache(videoRate, with: completion)
    }
    
    public func load(completion: @escaping (VideoRateAction.LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .empty:
                completion(.success([]))
            case let .found(items):
                completion(.success(items))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func cache(_ videoRate: RateItem, with completion: @escaping (VideoRateAction.SaveResult) -> Void) {
        store.insert(videoRate) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}
