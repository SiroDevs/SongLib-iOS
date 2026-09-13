//
//  HowItWorksView.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI

private struct HowItWorksSection: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

private let howItWorksSections: [HowItWorksSection] = [
    HowItWorksSection(
        icon: "checkmark.circle.fill",
        title: "Selection",
        description: "When you first open SongLib, you'll be presented with a list of available songbooks. " +
            "Tap on any songbook to select or deselect it. You can choose one or more songbooks to include " +
            "in your library. Once you're happy with your selection, tap the confirm button to load the songs. " +
            "You can always modify your collection later from App Settings."
    ),
    HowItWorksSection(
        icon: "magnifyingglass",
        title: "Searching",
        description: "The Search tab is your main way to find songs. Type any part of a song title or number " +
            "in the search bar to filter results instantly. For songs with numbers, you can also use the " +
            "dial pad (the floating button) to search by song number - just tap the digits to narrow down " +
            "your search. The results update in real time as you type."
    ),
    HowItWorksSection(
        icon: "heart.fill",
        title: "Song Likes",
        description: "Found a song you love? You can like it while viewing it in the presenter by tapping the " +
            "heart icon in the top bar. All your liked songs are collected in the Likes tab so you can access " +
            "your favourites quickly."
    ),
    HowItWorksSection(
        icon: "list.number",
        title: "Song Listings",
        description: "Listings let you group songs together into custom playlists - useful for worship sets, " +
            "events, or personal collections. Create a new listing from the Listings tab, or while viewing a " +
            "song, tap More then \"Add to a List\". Tap a listing to view or manage its songs."
    ),
    HowItWorksSection(
        icon: "play.rectangle.fill",
        title: "Song Presentation",
        description: "Tap any song to open it in the presenter. The song is displayed verse by verse for easy " +
            "reading. Swipe left or right to move between verses, or tap the dots at the bottom to jump to a " +
            "specific verse. Pinch to zoom in or out on the verse text. Tap the corners of the card to move to " +
            "the previous or next song in your list. Use the floating share button to share the whole song, or " +
            "the copy/share buttons under a verse to share just that verse."
    ),
]

struct HowItWorksView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Learn how to get the most out of SongLib")
                    .font(.subheadline)
                    .foregroundColor(Color("onSurfaceVariant"))
                    .padding(.bottom, 4)

                ForEach(howItWorksSections) { section in
                    HowItWorksCard(section: section)
                }
            }
            .padding(16)
        }
        .background(.surface)
        .navigationTitle("How It Works")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HowItWorksCard: View {
    fileprivate let section: HowItWorksSection
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primaryContainer)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: section.icon)
                                .foregroundColor(.onPrimaryContainer)
                        )

                    Text(section.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.scrim)

                    Spacer()

                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("onSurfaceVariant"))
                        .font(.caption)
                }
            }
            .buttonStyle(PlainButtonStyle())

            if expanded {
                Divider()
                    .padding(.vertical, 12)

                Text(section.description)
                    .font(.footnote)
                    .foregroundColor(Color("onSurfaceVariant"))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(.onPrimary)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    NavigationStack {
        HowItWorksView()
    }
}
