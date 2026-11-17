//
//  JournalViewModel.swift.swift
//  my journaling app
//
//  Created by ATHEER SALEH ALZHRANI on 30/05/1448 AH.
//


import Combine
import SwiftUI

class JournalViewModel: ObservableObject {

    // MARK: - Journal List

    @Published var journals: [JournalEntry] = []

    // MARK: - Search

    @Published var searchText = ""

    // MARK: - Sorting

    @Published var sortByBookmark = false


    // MARK: - Search and Sort

    var filteredJournals: [JournalEntry] {

        var result = journals.filter {

            searchText.isEmpty ||
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.content.localizedCaseInsensitiveContains(searchText)
        }

        result.sort {

            if sortByBookmark && $0.isBookmarked != $1.isBookmarked {
                return $0.isBookmarked
            }

            return $0.date > $1.date
        }

        return result
    }


    // MARK: - Add Journal

    func addJournal(title: String, content: String) {

        let journal = JournalEntry(
            title: title,
            content: content,
            date: Date(),
            isBookmarked: false
        )

        journals.insert(journal, at: 0)
    }


    // MARK: - Edit Journal

    func editJournal(
        _ journal: JournalEntry,
        title: String,
        content: String
    ) {

        if let index = journals.firstIndex(
            where: { $0.id == journal.id }
        ) {

            journals[index].title = title
            journals[index].content = content
        }
    }


    // MARK: - Delete Journal

    func deleteJournal(_ journal: JournalEntry) {

        journals.removeAll {
            $0.id == journal.id
        }
    }


    // MARK: - Bookmark

    func toggleBookmark(_ journal: JournalEntry) {

        if let index = journals.firstIndex(
            where: { $0.id == journal.id }
        ) {

            journals[index].isBookmarked.toggle()
        }
    }
}
