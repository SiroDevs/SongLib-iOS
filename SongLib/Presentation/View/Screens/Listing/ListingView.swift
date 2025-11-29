//
//  ListingView.swift
//  SongLib
//
//  Created by Siro Daves on 27/08/2025.
//

import SwiftUI

struct ListingView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ListingViewModel = {
        DiContainer.shared.resolve(ListingViewModel.self)
    }()
    let listing: Listing
    
    @State private var showToast = false
    @State private var toastMessage: String = ""
    @State private var showEditAlert = false
    @State private var showDeleteAlert = false
    @State private var editedTitle: String = ""

    var body: some View {
        ZStack {
            NavigationStack {
                stateContent
            }
            if showToast {
                ToastView(message: toastMessage)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task { viewModel.loadListing(listing: listing) }
        .onChange(of: viewModel.uiState) { newState in
            if case .liked = newState {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showToast = false
                }
            }
        }
        .navigationTitle(viewModel.listingTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: { Image(systemName: "chevron.backward") }
            }
        
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    editedTitle = viewModel.listingTitle
                    showEditAlert = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button {
                    showDeleteAlert = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .alert("Edit List Title", isPresented: $showEditAlert) {
            TextField("New title", text: $editedTitle)
            Button("Cancel", role: .cancel) {}
            Button("Update") {
                viewModel.updateListing(listing, title: editedTitle)
            }
        }
        .alert("Delete List?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteListing(listing.id, parent: 0)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }

    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading:
                LoadingState()
                
            case .loaded:
                Group {
                    if viewModel.listItems.isEmpty {
                        EmptyState(
                            message: L10n.emptySongList,
                            messageIcon: Image(systemName: "plus")
                        )
                    } else {
                        ListingContent(
                            viewModel: viewModel,
                            songs: viewModel.listedSongs
                        )
                    }
                }

            case .error(let msg):
                ErrorView(message: msg) { }

            default:
                LoadingView()
        }
    }
}
