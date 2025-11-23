//
//  ProfileEditorView.swift
//  phonics-flashcards
//
//  Created by ChatGPT on 22/11/2025.
//

import SwiftUI

struct ProfileEditorView: View {
    enum Mode {
        case new
        case edit
    }

    let mode: Mode
    @State private var name: String
    @State private var selectedColor: ProfileColor
    let onSave: (String, ProfileColor) -> Void
    @Environment(\.dismiss) private var dismiss

    init(mode: Mode, initialName: String, initialColor: ProfileColor, onSave: @escaping (String, ProfileColor) -> Void) {
        self.mode = mode
        _name = State(initialValue: initialName)
        _selectedColor = State(initialValue: initialColor)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .accessibilityLabel("Profile name")
                }

                Section("Color") {
                    colorGrid
                }
            }
            .navigationTitle(mode == .new ? "New Profile" : "Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(name, selectedColor)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private var colorGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
            ForEach(ProfileColor.allCases) { color in
                Button {
                    selectedColor = color
                } label: {
                    VStack(spacing: 6) {
                        Circle()
                            .fill(color.color)
                            .frame(width: 48, height: 48)
                            .overlay(
                                Circle()
                                    .stroke(style: StrokeStyle(lineWidth: selectedColor == color ? 4 : 1))
                                    .foregroundColor(selectedColor == color ? .white : .black.opacity(0.15))
                            )

                        Text(color.label)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(color.label) color")
                .accessibilityHint(selectedColor == color ? "Currently selected" : "Double tap to select this color")
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ProfileEditorView(mode: .new, initialName: "Explorer", initialColor: .coral) { _, _ in }
}
