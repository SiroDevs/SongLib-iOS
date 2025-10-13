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
    private let prefsRepo: PreferencesRepositoryProtocol
    private let subsRepo: SubscriptionRepositoryProtocol
    private let networkMonitor = NWPathMonitor()

    init(
        prefsRepo: PreferencesRepositoryProtocol,
        subsRepo: SubscriptionRepositoryProtocol
    ) {
        self.prefsRepo = prefsRepo
        self.subsRepo = subsRepo
        setupNetworkMonitoring()
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    func initializeApp() {
        Task { @MainActor in
            do {
                let isOnline = await checkNetworkAvailability()
                try await checkSubscriptionAndTime(isOnline: isOnline)
                determineNextRoute()
            } catch {
                determineNextRoute()
            } finally {
                isLoading = false
            }
        }
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            // Network status changes can be handled here if needed
        }
        networkMonitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    private func checkNetworkAvailability() async -> Bool {
        return await withCheckedContinuation { continuation in
            let currentPath = networkMonitor.currentPath
            continuation.resume(returning: currentPath.status == .satisfied)
        }
    }
    
    private func checkSubscriptionAndTime(isOnline: Bool) async throws {
        if !isProUser && hasTimeExceeded(hours: 5) {
            try await verifySubscription(isOnline: isOnline)
        }
        updateAppOpenTime()
    }
    
    private func verifySubscription(isOnline: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            subsRepo.isProUser { [weak self] isActive in
                DispatchQueue.main.async {
//                    self?.isProUser = isActive
//                    self?.canShowPaywall = !isActive
                    continuation.resume()
                }
            }
        }
    }
    
}
