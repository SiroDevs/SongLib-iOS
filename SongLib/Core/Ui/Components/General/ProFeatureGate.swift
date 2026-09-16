//
//  ProFeatureGate.swift
//  SongLib
//
//  Created by Siro Daves on 16/09/2026.
//

import SwiftUI

/// Drives the "free trial" gating for a `ProFeature`: tracks how many
/// times a non-Pro user has used it, and decides whether a tap should
/// go ahead, show a one-time "here's how this works" notice, or show
/// the "upgrade to keep using this" lock.
///
/// Usage:
/// ```
/// @StateObject private var searchGate = ProFeatureGateModel(feature: .searchByNumber)
/// @State private var showPaywall = false
/// ...
/// Button {
///     searchGate.attemptUse { performSearch() }
/// } label: { ... }
/// ...
/// .proFeatureAlerts(searchGate) { showPaywall = true }
/// ```
final class ProFeatureGateModel: ObservableObject {
    /// Number of free (non-Pro) uses allowed before the feature locks.
    static let freeUseLimit = 3

    let feature: ProFeature
    private let prefsRepo: PrefsRepoProtocol

    @Published var showFirstUseNotice = false
    @Published var showUpgradeNotice = false

    private var pendingAction: (() -> Void)?

    init(feature: ProFeature, prefsRepo: PrefsRepoProtocol = PrefsRepo()) {
        self.feature = feature
        self.prefsRepo = prefsRepo
    }

    /// Call this from the gated action's button. Pro users run `action`
    /// immediately. Free users run it too, as long as uses remain - on
    /// the very first use, `action` is deferred until the "you get 3
    /// free uses" notice is dismissed. Once the limit is hit, `action`
    /// is withheld entirely and the upgrade notice shows instead.
    func attemptUse(_ action: @escaping () -> Void) {
        guard !prefsRepo.isProUser else {
            action()
            return
        }

        let uses = prefsRepo.proFeatureUseCount(feature)
        guard uses < Self.freeUseLimit else {
            showUpgradeNotice = true
            return
        }

        prefsRepo.recordProFeatureUse(feature)
        if uses == 0 {
            pendingAction = action
            showFirstUseNotice = true
        } else {
            action()
        }
    }

    func confirmFirstUseNotice() {
        showFirstUseNotice = false
        let action = pendingAction
        pendingAction = nil
        action?()
    }
}

private struct ProFeatureAlerts: ViewModifier {
    @ObservedObject var gate: ProFeatureGateModel
    let onUpgrade: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(
                "This is a PRO Feature, you can use it 3 times before upgrading to PRO",
                isPresented: $gate.showFirstUseNotice
            ) {
                Button("Got it") { gate.confirmFirstUseNotice() }
            }
            .alert(
                "This is a PRO Feature, upgrade to keep using it.",
                isPresented: $gate.showUpgradeNotice
            ) {
                Button("Not Now", role: .cancel) {}
                Button("Upgrade") { onUpgrade() }
            }
    }
}

extension View {
    /// Attaches the two alerts a `ProFeatureGateModel` needs: the
    /// first-use notice and the upgrade lock. `onUpgrade` fires when
    /// the user taps "Upgrade" on the lock dialog - hook it up to the
    /// screen's own `showPaywall` state.
    func proFeatureAlerts(_ gate: ProFeatureGateModel, onUpgrade: @escaping () -> Void) -> some View {
        modifier(ProFeatureAlerts(gate: gate, onUpgrade: onUpgrade))
    }
}
