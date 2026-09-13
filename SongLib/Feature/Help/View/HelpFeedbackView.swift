//
//  HelpFeedbackView.swift
//  SongLib
//
//  Created by Siro Daves on 11/09/2026.
//

import SwiftUI
import PhotosUI
import MessageUI
import UIKit

struct HelpFeedbackView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var titleError = false
    @State private var descriptionError = false

    @State private var pickerItems: [PhotosPickerItem] = []
    @State private var attachments: [(image: UIImage, fileName: String)] = []

    @State private var showMailComposer = false
    @State private var showMailUnavailableAlert = false

    private let recipient = "futuristicken@gmail.com"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                infoCard

                VStack(alignment: .leading, spacing: 6) {
                    Text("Title *")
                        .font(.caption)
                        .foregroundColor(Color("onSurfaceVariant"))
                    TextField("Brief summary of your issue or suggestion", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: title) { _ in titleError = false }
                    if titleError {
                        Text("Title is required")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Description *")
                        .font(.caption)
                        .foregroundColor(Color("onSurfaceVariant"))
                    TextEditor(text: $description)
                        .frame(minHeight: 120)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("outline").opacity(0.4), lineWidth: 1)
                        )
                        .onChange(of: description) { _ in descriptionError = false }
                    if descriptionError {
                        Text("Description is required")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }

                attachmentsSection

                Divider()

                Button(action: submit) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Contact Us")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.primary1)
                .foregroundColor(.onPrimary)
                .cornerRadius(12)
            }
            .padding(16)
        }
        .background(.surface)
        .navigationTitle("Help & Feedback")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: pickerItems) { newItems in
            loadAttachments(from: newItems)
        }
        .sheet(isPresented: $showMailComposer) {
            MailComposeView(
                recipient: recipient,
                subject: "SongLib: \(title)",
                body: emailBody,
                attachments: attachments.map { attachment in
                    (
                        data: attachment.image.jpegData(compressionQuality: 0.85) ?? Data(),
                        mimeType: "image/jpeg",
                        fileName: attachment.fileName
                    )
                },
                onFinish: { dismiss() }
            )
        }
        .alert("Mail isn't set up", isPresented: $showMailUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Add a Mail account in Settings, or reach us directly at \(recipient).")
        }
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("We're here to help!")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.onPrimaryContainer)
            Text("If you are experiencing any issues or have suggestions, fill in the form below and we'll get back to you.")
                .font(.footnote)
                .foregroundColor(.onPrimaryContainer)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryContainer)
        .cornerRadius(12)
    }

    private var attachmentsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Screenshots (optional)")
                .font(.caption)
                .foregroundColor(Color("onSurfaceVariant"))

            PhotosPicker(
                selection: $pickerItems,
                maxSelectionCount: 5,
                matching: .images
            ) {
                VStack(spacing: 8) {
                    Image(systemName: "paperclip")
                        .foregroundColor(.primary1)
                    Text("Tap to attach images")
                        .font(.footnote)
                        .foregroundColor(.primary1)
                    Text("Up to 5 files")
                        .font(.caption2)
                        .foregroundColor(Color("onSurfaceVariant"))
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("outline").opacity(0.4), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())

            ForEach(attachments, id: \.fileName) { attachment in
                HStack(spacing: 8) {
                    Image(uiImage: attachment.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 6))

                    Text(attachment.fileName)
                        .font(.caption)
                        .lineLimit(1)

                    Spacer()

                    Button {
                        attachments.removeAll { $0.fileName == attachment.fileName }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color("onSurfaceVariant"))
                    }
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("outline").opacity(0.3), lineWidth: 1)
                )
            }
        }
    }

    private var emailBody: String {
        var text = "Description:\n\(description)\n\n"
        text += "---\nDevice Info:\n"
        text += "Model: \(UIDevice.current.model)\n"
        text += "iOS: \(UIDevice.current.systemVersion)\n"
        return text
    }

    private func loadAttachments(from items: [PhotosPickerItem]) {
        Task {
            var loaded: [(image: UIImage, fileName: String)] = []
            for (index, item) in items.enumerated() {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    loaded.append((image: image, fileName: "attachment_\(index + 1).jpg"))
                }
            }
            await MainActor.run {
                attachments = loaded
            }
        }
    }

    private func submit() {
        titleError = title.trimmingCharacters(in: .whitespaces).isEmpty
        descriptionError = description.trimmingCharacters(in: .whitespaces).isEmpty
        guard !titleError, !descriptionError else { return }

        if MFMailComposeViewController.canSendMail() {
            showMailComposer = true
        } else {
            let encodedSubject = "SongLib: \(title)"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let encodedBody = emailBody
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            if let url = URL(string: "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showMailUnavailableAlert = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        HelpFeedbackView()
    }
}
