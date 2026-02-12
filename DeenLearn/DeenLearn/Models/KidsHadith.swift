//
//  KidsHadith.swift
//  DeenLearn
//
//  Standalone model for kid-friendly hadith content
//  Used by both PillarsKidsWorldView and HadithKidsWorldView
//

import Foundation

// MARK: - Kids Hadith Model

struct KidsHadith: Identifiable {
    let id: String
    let emoji: String
    let title: String
    let arabicText: String
    let simpleMeaning: String
    let funFact: String
    let collection: String      // e.g., "bukhari"
    let hadithNumber: Int       // API hadith number for enrichment
    let reference: String       // e.g., "Sahih al-Bukhari, Hadith 13"
}
