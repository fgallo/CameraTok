//
//  Created by Fernando Gallo on 09/08/23.
//

import Foundation
import CameraTok

struct Feed: Hashable {
    let videoItems: [VideoItem]
    let startIndex: Int
}
