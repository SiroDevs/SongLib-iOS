//
//  HomeTopBarActions.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

struct HomeToolbarAction: OptionSet {
    let rawValue: Int

    static let drafts = HomeToolbarAction(rawValue: 1 << 0)
    static let more = HomeToolbarAction(rawValue: 1 << 1)
    static let add = HomeToolbarAction(rawValue: 1 << 2)

    static let all: HomeToolbarAction = [.drafts, .more, .add]
}

private struct HomeTopBarActions: ViewModifier {
    @ObservedObject var viewModel: HomeViewModel
    let actions: HomeToolbarAction
    var onAdd: (() -> Void)? = nil

    @State private var showDrafts = false
    @State private var showHowItWorks = false
    @State private var showHelp = false

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if actions.contains(.add) {
                        Button {
                            onAdd?()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }

                    if actions.contains(.drafts) {
                        Button {
                            showDrafts = true
                        } label: {
                            Image(systemName: "doc.text")
                        }
                    }

                    if actions.contains(.more) {
                        Menu {
                            Button {
                                showHowItWorks = true
                            } label: {
                                Label("How It Works", systemImage: "info.circle")
                            }

                            Button {
                                showHelp = true
                            } label: {
                                Label("Help & Feedback", systemImage: "questionmark.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showDrafts) {
                DraftsScreen()
                    .toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(isPresented: $showHowItWorks) {
                HowItWorksView()
                    .toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(isPresented: $showHelp) {
                HelpFeedbackView()
                    .toolbar(.hidden, for: .tabBar)
            }
    }
}

extension View {
    func homeToolbar(
        viewModel: HomeViewModel,
        actions: HomeToolbarAction = .more,
        onAdd: (() -> Void)? = nil
    ) -> some View {
        modifier(HomeTopBarActions(viewModel: viewModel, actions: actions, onAdd: onAdd))
    }
}
