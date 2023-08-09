//
//  Created by Fernando Gallo on 07/08/23.
//

import Foundation

public struct VideoItem: Hashable {
    public let id: String
    public let duration: Double
    public let creationDate: Date
    
    public init(id: String, duration: Double, creationDate: Date) {
        self.id = id
        self.duration = duration
        self.creationDate = creationDate
    }
}
