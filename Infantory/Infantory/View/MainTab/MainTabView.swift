//
//  MainTabView.swift
//  Infantory
//
//  Created by 김성훈 on 2023/09/21.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeMainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(0)
            
            AuctionMainView()
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("경매")
                }
                .tag(1)
            
            ApplyMainView()
                .tabItem {
                    Image(systemName: "ticket")
                    Text("응모")
                }
                .tag(2)
            
            ActivityMainView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("활동")
                }
                .tag(3)
            
            MyMainView()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이")
                }
                .tag(4)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}