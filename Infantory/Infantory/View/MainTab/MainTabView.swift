//
//  MainTabView.swift
//  Infantory
//
//  Created by 김성훈 on 2023/09/21.
//

import SwiftUI
import Photos

struct MainTabView: View {
    @EnvironmentObject var loginStore: LoginStore
    @State private var selectedIndex = 0
    @StateObject var applyProductStore: ApplyProductStore = ApplyProductStore()

    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeMainView()
                .tabItem {
                    Image(systemName: "house")
                        .environment(\.symbolVariants, .none)
                    Text("홈")
                }
                .foregroundColor(.black)
                .tag(0)
            
            AuctionMainView()
                .tabItem {
                    Image("auction")
                        .renderingMode(.template)
                    Text("경매")
                }
                .tag(1)
            
            ApplyMainView(applyProductStore: applyProductStore)
                .tabItem {
                    Image("apply")
                        .renderingMode(.template)
                    Text("응모")
                }
                .tag(2)
            
            ActivityMainView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundColor(selectedIndex == 3 ? .infanMain : .black)
                    Text("활동")
                }
                .tag(3)
            
            MyMainView()
                .tabItem {
                    Image(systemName: "person")
                        .environment(\.symbolVariants, .none)
                    Text("마이")
                }
                .tag(4)
        }
        .tint(Color.infanMain)
        .onAppearFetchUser()
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(LoginStore())
    }
}
