//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation

protocol VideoGalleryLoader {
    typealias Result = Swift.Result<[VideoItem], Error>
    
    func load(with startDate: Date, completion: @escaping (Result) -> Void)
}
