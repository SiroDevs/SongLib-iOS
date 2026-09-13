//
//  ShareSheet.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI
import UIKit

/// Thin wrapper around `UIActivityViewController`, used wherever we need to
/// share something that isn't a plain string/URL (e.g. a rendered verse
/// card image), so `ShareLink` alone won't do.
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
