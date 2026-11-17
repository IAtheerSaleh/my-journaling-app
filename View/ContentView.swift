//
//  ContentView.swift.swift
//  my journaling app
//
//  Created by ATHEER SALEH ALZHRANI on 30/05/1448 AH.
//


import SwiftUI

struct ContentView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel = JournalViewModel()

    // MARK: - Page States

    @State private var showJournalEditor = false
    @State private var selectedJournalForEditing: JournalEntry?

    // MARK: - Delete Alert

    @State private var showDeleteAlert = false
    @State private var journalToDelete: JournalEntry?

    // MARK: - Colors

    let purple = Color(
        red: 0.67,
        green: 0.55,
        blue: 1.0
    )


    var body: some View {

        VStack(spacing: 0) {

            // MARK: Header

            HStack {

                Text("Journal")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                // Sort Button

                Menu {

                    Button("Sort by Bookmark") {
                        viewModel.sortByBookmark = true
                    }

                    Button("Sort by Entry Date") {
                        viewModel.sortByBookmark = false
                    }

                } label: {

                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .frame(width: 55, height: 60)
                }

                // Add Button

                Button {

                    selectedJournalForEditing = nil
                    showJournalEditor = true

                } label: {

                    Image(systemName: "plus")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 55, height: 60)
                }
            }
            .padding(.horizontal, 25)
            .padding(.top, 15)


            // MARK: Journal List

            if viewModel.filteredJournals.isEmpty {

                Spacer()

                if viewModel.journals.isEmpty {

                    // Empty State

                    VStack(spacing: 20) {

                        Image("mainPic")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 210, height: 170)

                        Text("Begin Your Journal")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(purple)

                        Text("Craft your personal diary, tap the\nplus icon to begin")
                            .font(.system(size: 23))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }

                } else {

                    Text("No journals found")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }

                Spacer()

            } else {

                List {

                    ForEach(viewModel.filteredJournals) { journal in

                        VStack(alignment: .leading, spacing: 12) {

                            // Title and Bookmark

                            HStack {

                                Text(journal.title)
                                    .font(.system(size: 27, weight: .bold))
                                    .foregroundColor(purple)

                                Spacer()

                                // Bookmark Button

                                Button {

                                    viewModel.toggleBookmark(journal)

                                } label: {

                                    Image(systemName:
                                        journal.isBookmarked
                                        ? "bookmark.fill"
                                        : "bookmark"
                                    )
                                    .font(.system(size: 27))
                                    .foregroundColor(purple)
                                }
                                .buttonStyle(.plain)
                            }

                            // Date

                            Text(journal.date.formatted(
                                date: .numeric,
                                time: .omitted
                            ))
                            .font(.system(size: 18))
                            .foregroundColor(.gray)

                            // Journal Content

                            Text(journal.content)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .lineLimit(5)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                        }
                        .padding(25)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .background(
                            Color(
                                red: 0.11,
                                green: 0.11,
                                blue: 0.12
                            )
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 35)
                        )

                        // Tap to Edit

                        .contentShape(Rectangle())
                        .onTapGesture {

                            selectedJournalForEditing = journal
                            showJournalEditor = true
                        }

                        // Swipe to Delete

                        .swipeActions(
                            edge: .trailing,
                            allowsFullSwipe: false
                        ) {

                            Button(role: .destructive) {

                                journalToDelete = journal
                                showDeleteAlert = true

                            } label: {

                                Label(
                                    "Delete",
                                    systemImage: "trash"
                                )
                            }
                        }

                        .listRowInsets(
                            EdgeInsets(
                                top: 10,
                                leading: 25,
                                bottom: 10,
                                trailing: 25
                            )
                        )

                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.black)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.black)
            }


            // MARK: Search Bar

            HStack(spacing: 12) {

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 25))
                    .foregroundColor(.gray)

                TextField("Search", text: $viewModel.searchText)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .tint(purple)

                Image(systemName: "mic")
                    .font(.system(size: 23))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 18)
            .frame(height: 65)
            .background(Color.white.opacity(0.10))
            .clipShape(Capsule())
            .overlay {

                Capsule()
                    .stroke(
                        Color.white.opacity(0.20),
                        lineWidth: 1
                    )
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)


        // MARK: Add and Edit Sheet

        .sheet(isPresented: $showJournalEditor) {

            NewJournalView(

                initialTitle: selectedJournalForEditing?.title ?? "",

                initialContent: selectedJournalForEditing?.content ?? "",

                initialDate: selectedJournalForEditing?.date ?? Date()

            ) { title, content in

                if let journal = selectedJournalForEditing {

                    // Edit Existing Journal

                    viewModel.editJournal(
                        journal,
                        title: title,
                        content: content
                    )

                } else {

                    // Add New Journal

                    viewModel.addJournal(
                        title: title,
                        content: content
                    )
                }
            }
        }


        // MARK: Delete Alert

        .alert(
            "Delete Journal?",
            isPresented: $showDeleteAlert
        ) {

            Button("Cancel", role: .cancel) {

                journalToDelete = nil
            }

            Button("Delete", role: .destructive) {

                if let journal = journalToDelete {

                    viewModel.deleteJournal(journal)
                }

                journalToDelete = nil
            }

        } message: {

            Text("Are you sure you want to delete this journal?")
        }
    }
}
#Preview{
    ContentView()
}
