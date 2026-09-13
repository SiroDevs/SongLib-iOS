//
//  TabBarHider.swift
//  SongLib
//
//  Created by @sirodevs on 13/09/2026.
//

import SwiftUI
import UIKit

struct TabBarHider: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.tabBarController?.tabBar.isHidden = true
        }
    }

    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        DispatchQueue.main.async {
            uiViewController.tabBarController?.tabBar.isHidden = false
        }
    }
}

extension View {
    func hidesTabBar() -> some View {
        background(TabBarHider())
    }
}

final class TabBarVisibility: ObservableObject {
    @Published var isHidden = false
}
