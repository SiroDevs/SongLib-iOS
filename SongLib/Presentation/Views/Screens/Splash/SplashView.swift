//
//  SplashView.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel = {
        DiContainer.shared.resolve(SplashViewModel.self)
    }()
    @State private var navigateToNextScreen = false
    private let prefsRepo: PreferencesRepository
    
    init(prefsRepo: PreferencesRepository) {
        self.prefsRepo = prefsRepo
    }
    
    var body: some View {
        Group {
            if navigateToNextScreen {
                destinationView
            } else {
                SplashContent()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            navigateToNextScreen = true
                        }
                    }
            }
        }
        .animation(.easeInOut, value: navigateToNextScreen)
    }
    
    @ViewBuilder
    private var destinationView: some View {
        if prefsRepo.isDataLoaded {
            HomeView()
        } else {
            if prefsRepo.isDataSelected {
                Step2View()
            } else {
                Step1View()
            }
        }
    }
}

struct SplashContent: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(AppAssets.mainIcon)
                .resizable()
                .frame(width: 200, height: 200)

            Text(AppConstants.appTitle)
                .font(.system(size: 50, weight: .bold))
                .kerning(5)
                .foregroundColor(.primary1)
                .padding(.top, 10)

            Spacer()

            Divider()
                .frame(height: 1)
                .padding(.horizontal, 50)
                .background(.onPrimaryContainer)

            HStack {
                Text("with ")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(.onPrimaryContainer)
                Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary1)
                Text(" from")
                    .font(.system(size: 30, weight: .bold))
                    .kerning(5)
                    .foregroundColor(.onPrimaryContainer)
            }

            HStack {
                Text(AppConstants.appCredits1)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary1)
                Text(" & ")
                    .font(.system(size: 20))
                    .foregroundColor(.onPrimaryContainer)
                Text(AppConstants.appCredits2)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary1)
            }
            .padding(.top, 10)

            Spacer().frame(height: 20)
        }
        .padding()
        .background(.onPrimary)
    }
}

#Preview {
    SplashContent()
}
