//
//  Step1View.swift
//  SongLib
//
//  Created by Siro Daves on 30/04/2025.
//

import SwiftUI

struct Step1View: View {
    @StateObject private var viewModel: SelectionViewModel = {
        DiContainer.shared.resolve(SelectionViewModel.self)
    }()
    @State private var showAlertDialog = false
    @State private var navigateToNextScreen = false

    var body: some View {
        Group {
            if navigateToNextScreen {
                AnyView(Step2View())
            } else {
                AnyView(mainContent)
            }
        }
    }
    
    private var mainContent: some View {
        VStack {
            Text("Select Songbooks")
                .font(.title2)
                .foregroundColor(.onPrimaryContainer)
            stateContent.background(.surface)
        }
        .background(.primaryContainer)
        .alert(isPresented: $showAlertDialog) {
            selectionAlert
        }
        .task({viewModel.fetchBooks()})
        .onChange(of: viewModel.uiState, perform: handleStateChange)
    }
    
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.uiState {
            case .loading(let msg):
                LoadingState(
                    title: msg ?? "Loading books ...",
                    fileName: "loading-hand"
                )
                
            case .saving(let msg):
                LoadingState(
                    title: msg ?? "Loading books ...",
                    fileName: "cloud-download"
                )
                
            case .saved:
                LoadingView()
                
            case .error(let msg):
                ErrorView(message: msg) {
                    Task { viewModel.fetchBooks() }
                }
                
            default:
                BookSelectionView(
                    viewModel: viewModel,
                    showAlertDialog: $showAlertDialog
                )
        }
    }
    
    private var selectionAlert: Alert {
        if viewModel.selectedBooks().isEmpty {
            Alert(
                title: Text("Oops! No selection found"),
                message: Text("Please select at least 1 song book to proceed to the next step."),
                dismissButton: .default(Text("OKAY")),
            )
        } else {
            Alert(
                title: Text("Are you done selecting?"),
                message: Text("If you are done selecting please proceed ahead. We can always bring you back here to reselect afresh."),
                primaryButton: .default(Text("CANCEL")),
                secondaryButton: .default(Text("OKAY")) {
                    viewModel.saveBooks()
                }
            )
        }
    }
    
    private func handleStateChange(_ state: UiState) {
        navigateToNextScreen = .saved == state
    }
}

struct BookSelectionView: View {
    @ObservedObject var viewModel: SelectionViewModel
    @Binding var showAlertDialog: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    LazyVGrid(columns: columns(for: geometry.size.width), spacing: 10) {
                        ForEach(viewModel.books.indices, id: \.self) { index in
                            let selectable = viewModel.books[index]
                            SongBook(
                                book: selectable.data,
                                isSelected: selectable.isSelected
                            ) {
                                viewModel.toggleSelection(for: selectable.data)
                            }
                        }
                    }
                    .padding(10)
                }

                Button(action: {
                     showAlertDialog = true
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "checkmark")
                        Text("Proceed")
                    }
                    .frame(width: 150)
                    .padding()
                    .foregroundColor(.onPrimaryContainer)
                    .background(.primaryContainer)
                    .cornerRadius(10)
                }
            }
        }
    }
    
    private func columns(for width: CGFloat) -> [GridItem] {
        let itemWidth: CGFloat = 160 // Approximate width of each SongBook
        let spacing: CGFloat = 16
        let availableWidth = width - 40 // Account for horizontal padding
        
        let numberOfColumns = max(2, Int(availableWidth / (itemWidth + spacing)))
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: numberOfColumns)
    }
}

#Preview {
    Step1View()
}
