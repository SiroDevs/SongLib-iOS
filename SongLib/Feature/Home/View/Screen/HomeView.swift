//
//  HomeView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = {
        DiContainer.shared.resolve(HomeViewModel.self)
    }()
    
    @State private var showSettings: Bool = false
    @State private var isLandscape = false
        
    var body: some View {
        GeometryReader { geo in
            let landscape = geo.size.width > geo.size.height
            
            Group {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadLayout(landscape: landscape)
                } else {
                    iPhoneLayout
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
            .task { viewModel.fetchData() }
            .onChange(of: viewModel.uiState, perform: handleStateChange)
        }
    }
    
    @ViewBuilder
    private var iPhoneLayout: some View {
        if case .error(let msg) = viewModel.uiState {
            ErrorView(message: msg) {
                Task { viewModel.fetchData() }
            }
        } else if !viewModel.isDatabaseReady {
            HomeSkeleton()
        } else {
            HomeContent(viewModel: viewModel)
        }
    }
    
    private func iPadLayout(landscape: Bool) -> some View {
//        Group {
//            if landscape {
//                NavigationSplitView {
//                } content: {
//                    iPhoneLayout
//                } detail: {
//                    Text("Detail")
//                }
//            } else {
//                iPhoneLayout
//                    .environment(\.horizontalSizeClass, .compact)
//            }
//        }
        iPhoneLayout
            .environment(\.horizontalSizeClass, .compact)
    }
    
    private func handleStateChange(_ state: UiState) {
        if case .fetched = state {
            viewModel.filterSongs(book: viewModel.books[viewModel.selectedBook].bookId)
        }
    }
}

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
