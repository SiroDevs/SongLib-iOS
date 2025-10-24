//
//  HomeViewMock.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

private struct HomeViewMock: View {
    @State private var selection: Int = 0

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
    }
    
    @ViewBuilder
    private var iPhoneLayout: some View {
        TabView(selection: $selection) {
            HomeSearchMock()
                .tag(0)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .background(.primaryContainer)
            
            HomeLikesMock()
                .tag(1)
                .tabItem {
                    Label("Likes", systemImage: "heart.fill")
                }
                .background(.primaryContainer)
            
            HomeListingsMock()
                .tag(2)
                .tabItem {
                    Label("Listings", systemImage: "list.number")
                }
                .background(.primaryContainer)
        }
    }
    
    private var iPadLayout: some View {
//        HStack(spacing: 0) {
//            iPhoneLayout
//                .frame(width: 350)
//                .environment(\.horizontalSizeClass, .compact)
//            
//            Divider()
//            
//            Group {
//                Text("Select a tab")
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
        NavigationSplitView {
        } content: {
            iPhoneLayout
        } detail: {
            Text("Select a department")
        }
    }
}

#Preview
{
    HomeViewMock()
}
