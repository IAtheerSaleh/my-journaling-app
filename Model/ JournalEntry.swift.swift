//
//   JournalEntry.swift.swift
//  my journaling app
//
//  Created by ATHEER SALEH ALZHRANI on 30/05/1448 AH.
//


import Foundation

struct JournalEntry: Identifiable {

    let id = UUID()

    var title: String
    var content: String
    var date: Date
    var isBookmarked: Bool
}
