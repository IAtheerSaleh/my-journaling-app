//
//  NewJournalView.swift.swift
//  my journaling app
//
//  Created by ATHEER SALEH ALZHRANI on 30/05/1448 AH.
//


import SwiftUI

struct NewJournalView: View {

    @Environment(\.dismiss) var dismiss

    // MARK: - Text Fields

    @State private var title: String
    @State private var content: String

    // MARK: - Date

    let initialDate: Date

    // MARK: - Save Action

    var onSave: (String, String) -> Void

    // MARK: - Color

    let purple = Color(
        red: 0.50,
        green: 0.47,
        blue: 1.0
    )


    // MARK: - Initializer

    init(
        initialTitle: String = "",
        initialContent: String = "",
        initialDate: Date = Date(),
        onSave: @escaping (String, String) -> Void
    ) {

        _title = State(initialValue: initialTitle)

        _content = State(initialValue: initialContent)

        self.initialDate = initialDate

        self.onSave = onSave
    }


    var body: some View {

        VStack(spacing: 20) {

            // MARK: Top Buttons

            HStack {

                // Cancel Button

                Button {

                    dismiss()

                } label: {

                    Image(systemName: "xmark")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width: 65, height: 65)
                        .background(Color.black.opacity(0.25))
                        .clipShape(Circle())
                }

                Spacer()

                // Save Button

                Button {

                    if !title.trimmingCharacters(
                        in: .whitespacesAndNewlines
                    ).isEmpty {

                        onSave(title, content)

                        dismiss()
                    }

                } label: {

                    Image(systemName: "checkmark")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .frame(width: 65, height: 65)
                        .background(purple)
                        .clipShape(Circle())
                }
            }


            // MARK: Title

            TextField("Title", text: $title)
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(.white)
                .tint(purple)


            // MARK: Date

            Text(initialDate.formatted(
                date: .numeric,
                time: .omitted
            ))
            .font(.system(size: 23))
            .foregroundColor(.gray)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )


            // MARK: Journal Content

            ZStack(alignment: .topLeading) {

                TextEditor(text: $content)
                    .font(.system(size: 17))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .tint(purple)

                if content.isEmpty {

                    Text("Type your Journal...")
                        .font(.system(size: 17))
                        .foregroundColor(.gray.opacity(0.7))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 25)
        .background(
            Color(
                red: 0.11,
                green: 0.11,
                blue: 0.12
            )
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}
