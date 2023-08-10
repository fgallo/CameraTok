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
            rateState: viewModel.rateState,
            onRetry: { viewModel.loadVideoData() },
            onLike: { viewModel.like() },
            onDislike: { viewModel.dislike() }
        )
        .onAppear {
            viewModel.loadVideoData()
            viewModel.loadRate()
        }
    }
}

struct FeedCell: View {
    @State private var videoPos: Double = 0
    @State private var videoDuration: Double = 0
    @State private var seeking = false
    @State private var mute = false
    
    var state: FeedCellViewModel.State
    var rateState: FeedCellViewModel.RateState
    var onRetry: () -> Void
    var onLike: () -> Void
    var onDislike: () -> Void
    
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
    
    var rateView: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    
                    Button {
                        mute.toggle()
                    } label: {
                        Image(systemName: mute ? "speaker.slash" : "speaker")
                    }
                    .padding(.bottom)
                    
                    Button {
                        onLike()
                    } label: {
                        Image(systemName: rateState == .liked ? "hand.thumbsup.fill" : "hand.thumbsup")
                    }
                    .padding(.bottom)
                    
                    Button {
                        onDislike()
                    } label: {
                        Image(systemName: rateState == .disliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                    }
                    
                    
                }
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(.white)
            }
        }
        
    }
    
    func videoPlayer(url: URL) -> some View {
        let player = AVPlayer(url: url)
        return ZStack {
            VideoPlayerView(
                videoPos: $videoPos,
                videoDuration: $videoDuration,
                seeking: $seeking,
                player: player
            )
            .onAppear {
                player.seek(to: .zero)
                player.play()
            }
            .onTapGesture {
                player.rate == .zero ? player.play() : player.pause()
            }
            
            VStack {
                Spacer()
                
                rateView
                
                VideoPlayerControlsView(
                    videoPos: $videoPos,
                    videoDuration: $videoDuration,
                    seeking: $seeking,
                    mute: $mute,
                    player: player
                )
            }
            .padding()
        }
    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(
            state: .loading,
            rateState: .liked,
            onRetry: {},
            onLike: {},
            onDislike: {}
        )
    }
}
