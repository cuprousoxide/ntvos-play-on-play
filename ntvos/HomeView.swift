//
//  HomeView.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/3/22.
//

import Foundation
import SwiftUI


struct HomeView: View {
    var response: Response?
    @State var openChannel: String?
    @EnvironmentObject var player: Player
    @FocusState private var focusedChannel: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.cyan, .secondary]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                .ignoresSafeArea()
                .opacity(0.2)
                VStack(alignment: .center) {
                    Spacer()
                    if response == nil {
                        LoadingView()
                    } else {
                        HStack {
                            ForEach(response!.results, id: \.channelName) { result in
                                NavigationLink(destination: ChannelView(result: result), tag: result.channelName, selection: $openChannel) {
                                    ChannelCardView(result: result)
                                }
                                .buttonStyle(.card)
                                .focused($focusedChannel, equals: result.channelName)
                            }
                        }
                        // Focus the first card once the cards load, so Play/Pause has a station to start.
                        .onAppear {
                            DispatchQueue.main.async {
                                if focusedChannel == nil {
                                    focusedChannel = response?.results.first?.channelName
                                }
                            }
                        }
                        // Before anything has played, Play/Pause opens the focused channel (same as Select).
                        // Otherwise it keeps the usual pause/resume toggle.
                        .onPlayPauseCommand {
                            print("[PLAYPAUSE-DEBUG] HomeView handler: status=\(player.customerPlayerStatus) focused=\(String(describing: focusedChannel))")
                            if player.customerPlayerStatus == .None, let channel = focusedChannel {
                                openChannel = channel
                            } else {
                                player.toggle()
                            }
                        }
                    }
                    Spacer()
                }
            }
            
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct HomeViewManager: View {
    @EnvironmentObject var liveData: LiveDataModel
    
    
    
    
    var body: some View {
        HomeView(response: liveData.response)
    }
}



struct HomeView_Preview: PreviewProvider {
    

    static var previews: some View {
        HomeView(response: FakeResponses().mainResponse)
    }
}

