//
//  Created by Fernando Gallo on 09/08/23.
//

import SwiftUI
import AVKit

struct FeedContainerCell: View {
    @StateObject var viewModel: FeedCellViewModel
    
    var body: some View {
        FeedCell(
            state: viewModel.state,
            onRetry: { viewModel.loadVideoData() }
        )
        .onAppear {
            viewModel.loadVideoData()
        }
    }
}

struct FeedCell: View {
    var state: FeedCellViewModel.State
    var onRetry: () -> Void
    
    var body: some View {
        switch state {
        case .loading:
            ProgressView()
        case let .loaded(url):
            videoPlayer(url: url)
        case .error:
            Button {
                onRetry()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(Color.white)
            }
        }
    }
    
    func videoPlayer(url: URL) -> some View {
        let player = AVPlayer(url: url)
        return VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                player.play()
            }
            .onTapGesture {
                player.rate == .zero ? player.play() : player.pause()
            }
    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(state: .loading, onRetry: {})
    }
}
