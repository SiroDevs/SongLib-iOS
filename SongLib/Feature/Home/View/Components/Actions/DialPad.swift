//
//  DialPad.swift
//  SongLib
//
//  Created by Siro Daves on 19/08/2025.
//

import SwiftUI

struct DialPad: View {
    let onNumberClick: (String) -> Void
    let onBackspaceClick: () -> Void
    let onSearchClick: () -> Void

    private let rows: [[DialKey]]

    init(
        onNumberClick: @escaping (String) -> Void,
        onBackspaceClick: @escaping () -> Void,
        onSearchClick: @escaping () -> Void
    ) {
        self.onNumberClick = onNumberClick
        self.onBackspaceClick = onBackspaceClick
        self.onSearchClick = onSearchClick

        if UIDevice.current.userInterfaceIdiom == .pad {
            self.rows = [
                [.digit("1"), .digit("2"), .digit("3"), .digit("4"), .digit("5"), .digit("6")],
                [.digit("7"), .digit("8"), .digit("9"), .digit("0"), .backspace, .confirm]
            ]
        } else {
            self.rows = [
                [.digit("1"), .digit("2"), .digit("3")],
                [.digit("4"), .digit("5"), .digit("6")],
                [.digit("7"), .digit("8"), .digit("9")],
                [.digit("0"), .backspace, .confirm]
            ]
        }
    }

    var body: some View {
        VStack(spacing: 14) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: 14) {
                    ForEach(rows[rowIndex]) { key in
                        switch key {
                        case .digit(let label):
                            DialButton(label: label) { onNumberClick(label) }
                        case .backspace:
                            DialIconButton(systemName: "delete.left", action: onBackspaceClick)
                        case .confirm:
                            DialIconButton(systemName: "checkmark", action: onSearchClick)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

private enum DialKey: Identifiable {
    case digit(String)
    case backspace
    case confirm

    var id: String {
        switch self {
        case .digit(let label): return label
        case .backspace: return "backspace"
        case .confirm: return "confirm"
        }
    }
}

struct DialButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.primary1)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.primary1.opacity(0.6), lineWidth: 1.5)
        )
    }
}

struct DialIconButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary1)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.primary1.opacity(0.6), lineWidth: 1.5)
        )
    }
}

//#Preview {
//    DialPad(
//        onNumberClick: {_ in },
//        onBackspaceClick: {},
//        onSearchClick: {}
//    )
//}

#Preview {
    HomeSearchMock()
}
