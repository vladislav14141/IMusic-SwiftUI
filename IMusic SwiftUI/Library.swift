//
//  Library.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 18.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell?
    var tabBarDelegate: MainTabBarControllerDelegate?
    
    var body: some View {
        NavigationView {
            VStack{
                GeometryReader { (geometry) in
                    HStack(spacing: 20){
                        Button(action: {
                            self.track = self.tracks[0]
                            self.tabBarDelegate?.muximizeTrackDetailController(viewModel: self.track)
                        }) {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1901220034)))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }) {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                                .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.1901220034)))
                                .cornerRadius(10)
                        }
                        
                    }
                }.padding().frame( height: 50)
                Divider().padding(.leading).padding(.trailing)
                
                List {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track)
                            .gesture(LongPressGesture()
                                .onEnded({ _tracks in
                                    self.showingAlert = true
                                    self.track = track
                                }))
                            .simultaneousGesture(TapGesture()
                                .onEnded({ _ in
                                    
                                    let keyWindow = UIApplication.shared.connectedScenes
                                        .filter({$0.activationState == .foregroundActive})
                                        .map({$0 as? UIWindowScene})
                                        .compactMap({$0})
                                        .first?.windows
                                        .filter({$0.isKeyWindow}).first
                                    let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
                                    tabBarVC?.trackDetailView.delegate = self

                                    self.track = track
                                    self.tabBarDelegate?.muximizeTrackDetailController(viewModel: self.track)
                                }))
                    }.onDelete(perform: delete)
                }
                
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Delete this track?"),
                            buttons: [
                                .cancel(),
                                .destructive(
                                    Text("Удалить"),
                                    action: {
                                        guard let track = self.track else {return}
                                        self.delete(track: track)
                                    })
                ])
            })
                
            
            .navigationBarTitle("Library")
        }
    }
    func delete(at Offsets: IndexSet){
        tracks.remove(atOffsets: Offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
    
    func delete(track: SearchViewModel.Cell){
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else {return}
        tracks.remove(at: myIndex)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}



struct LibraryCell: View {
    var cell: SearchViewModel.Cell
    var body: some View {
        HStack {
            //Image(systemName: "arrow.2.circlepath").resizable().frame(width: 64, height: 64)
            URLImage(URL(string: cell.iconUrlString ?? "")!).resizable().frame(width: 64, height: 64)
            VStack(alignment: .leading){
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}

extension Library: TrackMovingDelegate {
    func moveBackForPreviusTrack() -> SearchViewModel.Cell? {
        
        guard let track = track else {return nil}
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else {return nil}
        
        var nextTrack: SearchViewModel.Cell
        if myIndex == 0 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[myIndex - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func moveForwardForNextTrack() -> SearchViewModel.Cell? {
        guard let track = track else {return nil}
        let index = tracks.firstIndex(of: track)
        guard let myIndex = index else {return nil}
        
        var nextTrack: SearchViewModel.Cell
        if myIndex + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[myIndex + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    
}
