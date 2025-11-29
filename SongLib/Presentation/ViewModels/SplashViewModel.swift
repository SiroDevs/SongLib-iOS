//
//  SplashViewModel.swift
//  SongLib
//
//  Created by Siro Daves on 13/10/2025.
//

import Foundation
import SwiftUI
import Network

final class SplashViewModel: ObservableObject {
    private let netUtils: NetworkUtils
    let prefsRepo: PrefsRepo
    private let subsRepo: SubsRepoProtocol
    
    @Published var isInitialized = false

    init(
        netUtils: NetworkUtils = .shared,
        prefsRepo: PrefsRepo,
        subsRepo: SubsRepoProtocol,
    ) {
        self.netUtils = netUtils
        self.prefsRepo = prefsRepo
        self.subsRepo = subsRepo
    }
    
    func initializeApp() {
        Task { @MainActor in
            do {
                let isOnline = await netUtils.checkNetworkAvailability()
                try await validateSubscription(isOnline: isOnline)
            } catch {
                print("Subscription check failed: \(error)")
            }
            isInitialized = true
        }
    }
    
    private func validateSubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser(isOnline: isOnline) { isActive in
                Task { @MainActor in
                    continuation.resume()
                }
            }
        }
    }
}
