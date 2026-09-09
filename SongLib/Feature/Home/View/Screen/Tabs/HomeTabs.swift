//
//  HomeTabs.swift
//  SongLib
//
//  Created by Siro Daves on 29/08/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeTabs: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        TabView {
            if !viewModel.songs.isEmpty {
                HomeSearch(viewModel: viewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .background(.primaryContainer)
                
                HomeLikes(viewModel: viewModel)
                    .tabItem {
                        Label("Likes", systemImage: "heart.fill")
                    }
                    .background(.primaryContainer)
                
                HomeListings(viewModel: viewModel)
                    .tabItem {
                        Label("Listings", systemImage: "list.number")
                    }
                    .background(.primaryContainer)
            }
            
            DraftsScreen()
                .tabItem {
                    Label("Drafts", systemImage: "doc.text")
                }
                .background(.primaryContainer)
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .background(.primaryContainer)
        }
//        .onAppear {
//            #if !DEBUG
//            showPaywall = !viewModel.isProUser
//            viewModel.promptReview()
//            #endif
//        }
//        .sheet(isPresented: $showPaywall) {
//            #if !DEBUG
//            PaywallView(displayCloseButton: true)
//            #endif
//        }
    }
}
