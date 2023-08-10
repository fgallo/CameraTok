//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation

public class CodableRateStore: RateStore {
    private let storeURL: URL
    
    private let queue = DispatchQueue(label: "\(CodableRateStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func insert(_ rate: RateItem, completion: @escaping InsertionCompletion) {
        let storeURL = getStoreURL(rate.videoId)
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let encoded = try encoder.encode(rate)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(_ videoId: String, completion: @escaping RetrieveCompletion) {
        let storeURL = getStoreURL(videoId)
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.empty)
            }
            
            do {
                let decoder = JSONDecoder()
                let rate = try decoder.decode(RateItem.self, from: data)
                completion(.found(rate))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func getStoreURL(_ videoId: String) -> URL {
        self.storeURL.appending(path: videoId.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "-", with: ""))
    }
}
