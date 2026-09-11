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
            // HomeTabs is only ever shown once viewModel.isDatabaseReady is
            // true (see HomeView), so songs has already been populated by
            // then - these tabs no longer need to be gated on it, which is
            // what used to make them pop in after the fact.
            //
            // Drafts and Settings used to be tabs here too; they're now
            // reached from the Drafts icon / More menu each of these three
            // tabs carries in its own top bar (see HomeTopBarActions).
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
