import SwiftUI

// MARK: - Adult Hadith Data Models

struct HadithCollection: Identifiable {
    let id = UUID()
    let name: String
    let arabicName: String
    let apiName: String
    let icon: String
    let description: String
    let totalHadith: Int
}

struct HadithTopic: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let keywords: [String]
    let description: String
}

struct HadithBookmark: Codable, Identifiable {
    var id: String { "\(collection)_\(hadithNumber)" }
    let collection: String
    let hadithNumber: Int
    let arabicText: String
    let englishText: String
    let narrator: String
    let isFavorite: Bool
    let dateAdded: Date
}

struct HadithReflection: Codable, Identifiable {
    let id: String
    let collection: String
    let hadithNumber: Int
    let whatTeaches: String
    let howApply: String
    let dateCreated: Date
}

// MARK: - Hadith Adult View Model

@MainActor
class HadithAdultViewModel: ObservableObject {
    @Published var collections: [HadithCollection] = []
    @Published var currentHadiths: [(number: Int, arabic: String, english: String, narrator: String, grade: String)] = []
    @Published var bookmarks: [HadithBookmark] = []
    @Published var reflections: [HadithReflection] = []
    @Published var searchResults: [(collection: String, number: Int, arabic: String, english: String)] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var dailyHadith: (arabic: String, english: String, collection: String, number: Int)?

    private let hadithAPI = HadithAPIService.shared
    private let bookmarksKey = "hadith_bookmarks"
    private let reflectionsKey = "hadith_reflections"

    init() {
        setupCollections()
        loadBookmarks()
        loadReflections()
        loadDailyHadith()
    }

    func setupCollections() {
        collections = [
            HadithCollection(name: "Sahih Bukhari", arabicName: "صحيح البخاري", apiName: "bukhari", icon: "📗", description: "Most authentic hadith collection", totalHadith: 7563),
            HadithCollection(name: "Sahih Muslim", arabicName: "صحيح مسلم", apiName: "muslim", icon: "📘", description: "Second most authentic collection", totalHadith: 7470),
            HadithCollection(name: "Sunan Abu Dawud", arabicName: "سنن أبي داود", apiName: "abu-dawud", icon: "📙", description: "Sunan collection by Abu Dawud", totalHadith: 5274),
            HadithCollection(name: "Jami at-Tirmidhi", arabicName: "جامع الترمذي", apiName: "tirmidhi", icon: "📕", description: "Collection by Imam Tirmidhi", totalHadith: 3956),
            HadithCollection(name: "40 Nawawi", arabicName: "الأربعون النووية", apiName: "nawawi40", icon: "📒", description: "40 essential hadiths by Imam Nawawi", totalHadith: 42),
            HadithCollection(name: "Riyad as-Salihin", arabicName: "رياض الصالحين", apiName: "riyadussalihin", icon: "📓", description: "Gardens of the Righteous", totalHadith: 1896)
        ]
    }

    func fetchHadiths(collection: String, range: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let hadiths = try await hadithAPI.fetchHadithRange(collection: collection, range: range)
            currentHadiths = hadiths.map { hadith in
                (number: hadith.number, arabic: hadith.arab, english: "", narrator: "", grade: "")
            }
        } catch {
            // Use sample data as fallback
            currentHadiths = []
        }
    }

    func fetchSingleHadith(collection: String, number: Int) async -> (arabic: String, english: String, narrator: String, grade: String)? {
        do {
            let hadith = try await hadithAPI.fetchHadith(collection: collection, number: number)
            return (arabic: hadith.arab, english: "", narrator: "", grade: "")
        } catch {
            return nil
        }
    }

    // MARK: - Bookmarks

    func toggleBookmark(collection: String, number: Int, arabic: String, english: String, narrator: String) {
        if let index = bookmarks.firstIndex(where: { $0.collection == collection && $0.hadithNumber == number }) {
            bookmarks.remove(at: index)
        } else {
            let bookmark = HadithBookmark(
                collection: collection,
                hadithNumber: number,
                arabicText: arabic,
                englishText: english,
                narrator: narrator,
                isFavorite: false,
                dateAdded: Date()
            )
            bookmarks.append(bookmark)
        }
        saveBookmarks()
    }

    func toggleFavorite(collection: String, number: Int) {
        if let index = bookmarks.firstIndex(where: { $0.collection == collection && $0.hadithNumber == number }) {
            let old = bookmarks[index]
            bookmarks[index] = HadithBookmark(
                collection: old.collection,
                hadithNumber: old.hadithNumber,
                arabicText: old.arabicText,
                englishText: old.englishText,
                narrator: old.narrator,
                isFavorite: !old.isFavorite,
                dateAdded: old.dateAdded
            )
            saveBookmarks()
        }
    }

    func isBookmarked(collection: String, number: Int) -> Bool {
        bookmarks.contains { $0.collection == collection && $0.hadithNumber == number }
    }

    private func saveBookmarks() {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        }
    }

    private func loadBookmarks() {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey),
           let saved = try? JSONDecoder().decode([HadithBookmark].self, from: data) {
            bookmarks = saved
        }
    }

    // MARK: - Reflections

    func saveReflection(collection: String, number: Int, whatTeaches: String, howApply: String) {
        let id = "\(collection)_\(number)"
        if let index = reflections.firstIndex(where: { $0.id == id }) {
            reflections[index] = HadithReflection(id: id, collection: collection, hadithNumber: number, whatTeaches: whatTeaches, howApply: howApply, dateCreated: Date())
        } else {
            reflections.append(HadithReflection(id: id, collection: collection, hadithNumber: number, whatTeaches: whatTeaches, howApply: howApply, dateCreated: Date()))
        }
        saveReflections()
    }

    func getReflection(collection: String, number: Int) -> HadithReflection? {
        reflections.first { $0.collection == collection && $0.hadithNumber == number }
    }

    private func saveReflections() {
        if let data = try? JSONEncoder().encode(reflections) {
            UserDefaults.standard.set(data, forKey: reflectionsKey)
        }
    }

    private func loadReflections() {
        if let data = UserDefaults.standard.data(forKey: reflectionsKey),
           let saved = try? JSONDecoder().decode([HadithReflection].self, from: data) {
            reflections = saved
        }
    }

    // MARK: - Daily Hadith

    func loadDailyHadith() {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let collections = ["bukhari", "muslim", "nawawi40"]
        let collection = collections[dayOfYear % collections.count]
        let number = (dayOfYear % 40) + 1

        Task {
            if let result = await fetchSingleHadith(collection: collection, number: number) {
                dailyHadith = (arabic: result.arabic, english: result.english, collection: collection, number: number)
            } else {
                dailyHadith = (
                    arabic: "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ",
                    english: "Actions are judged by intentions.",
                    collection: "bukhari",
                    number: 1
                )
            }
        }
    }

    // MARK: - Search

    func search(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        isLoading = true
        defer { isLoading = false }

        // Search through cached bookmarks first, then try API
        let localResults = bookmarks
            .filter { $0.arabicText.localizedCaseInsensitiveContains(query) || $0.englishText.localizedCaseInsensitiveContains(query) }
            .map { (collection: $0.collection, number: $0.hadithNumber, arabic: $0.arabicText, english: $0.englishText) }

        searchResults = localResults
    }

    // MARK: - Topics

    var topics: [HadithTopic] {
        [
            HadithTopic(name: "Worship & Prayer", icon: "🕌", keywords: ["prayer", "salah", "worship", "fasting"], description: "Hadiths about acts of worship"),
            HadithTopic(name: "Character & Manners", icon: "🌟", keywords: ["manners", "character", "kindness", "patience"], description: "Hadiths about good character"),
            HadithTopic(name: "Family & Parenting", icon: "👨‍👩‍👧‍👦", keywords: ["family", "parents", "children", "marriage"], description: "Hadiths about family life"),
            HadithTopic(name: "Knowledge & Learning", icon: "📖", keywords: ["knowledge", "learning", "scholar", "seeking"], description: "Hadiths about seeking knowledge"),
            HadithTopic(name: "Daily Life", icon: "☀️", keywords: ["eating", "sleeping", "greeting", "morning"], description: "Hadiths about daily routines")
        ]
    }
}

// MARK: - Main Adult Hadith View

struct HadithAdultView: View {
    @StateObject private var viewModel = HadithAdultViewModel()
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        TabButton(title: "Home", icon: "house.fill", isSelected: selectedTab == 0) { selectedTab = 0 }
                        TabButton(title: "Collections", icon: "books.vertical.fill", isSelected: selectedTab == 1) { selectedTab = 1 }
                        TabButton(title: "Topics", icon: "tag.fill", isSelected: selectedTab == 2) { selectedTab = 2 }
                        TabButton(title: "Bookmarks", icon: "bookmark.fill", isSelected: selectedTab == 3) { selectedTab = 3 }
                        TabButton(title: "Search", icon: "magnifyingglass", isSelected: selectedTab == 4) { selectedTab = 4 }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Content
                switch selectedTab {
                case 0: HadithHomeSection(viewModel: viewModel)
                case 1: HadithCollectionsSection(viewModel: viewModel)
                case 2: HadithTopicsSection(viewModel: viewModel)
                case 3: HadithBookmarksSection(viewModel: viewModel)
                case 4: HadithSearchSection(viewModel: viewModel)
                default: HadithHomeSection(viewModel: viewModel)
                }
            }
            .navigationTitle("Hadith")
        }
    }
}

// MARK: - Tab Button

private struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.caption2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.green.opacity(0.2) : Color.clear)
            .foregroundColor(isSelected ? .green : .secondary)
            .cornerRadius(10)
        }
    }
}

// MARK: - Home Section

private struct HadithHomeSection: View {
    @ObservedObject var viewModel: HadithAdultViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Daily Hadith Card
                if let daily = viewModel.dailyHadith {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.orange)
                            Text("Daily Hadith")
                                .font(.headline)
                            Spacer()
                            Text(daily.collection.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }

                        Text(daily.arabic)
                            .font(.system(size: 22))
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding()
                            .background(Color.green.opacity(0.05))
                            .cornerRadius(12)

                        Text(daily.english)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        NavigationLink(destination: HadithDetailView(
                            viewModel: viewModel,
                            collection: daily.collection,
                            number: daily.number,
                            arabic: daily.arabic,
                            english: daily.english,
                            narrator: "",
                            grade: ""
                        )) {
                            Text("Read & Reflect →")
                                .font(.subheadline.bold())
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                }

                // Quick Access Collections
                VStack(alignment: .leading, spacing: 12) {
                    Text("Collections")
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.collections.prefix(4)) { collection in
                            NavigationLink(destination: CollectionBrowserView(viewModel: viewModel, collection: collection)) {
                                VStack(spacing: 8) {
                                    Text(collection.icon)
                                        .font(.system(size: 32))
                                    Text(collection.name)
                                        .font(.caption.bold())
                                        .multilineTextAlignment(.center)
                                    Text("\(collection.totalHadith) hadiths")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(12)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Recent Bookmarks
                if !viewModel.bookmarks.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Bookmarks")
                            .font(.headline)

                        ForEach(viewModel.bookmarks.prefix(3)) { bookmark in
                            NavigationLink(destination: HadithDetailView(
                                viewModel: viewModel,
                                collection: bookmark.collection,
                                number: bookmark.hadithNumber,
                                arabic: bookmark.arabicText,
                                english: bookmark.englishText,
                                narrator: bookmark.narrator,
                                grade: ""
                            )) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(bookmark.collection.capitalized)
                                            .font(.caption.bold())
                                            .foregroundColor(.green)
                                        Text(bookmark.arabicText)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                    Image(systemName: bookmark.isFavorite ? "heart.fill" : "bookmark.fill")
                                        .foregroundColor(bookmark.isFavorite ? .red : .green)
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Collections Section

private struct HadithCollectionsSection: View {
    @ObservedObject var viewModel: HadithAdultViewModel

    var body: some View {
        List(viewModel.collections) { collection in
            NavigationLink(destination: CollectionBrowserView(viewModel: viewModel, collection: collection)) {
                HStack(spacing: 16) {
                    Text(collection.icon)
                        .font(.system(size: 36))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(collection.name)
                            .font(.headline)
                        Text(collection.arabicName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(collection.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(collection.totalHadith) hadiths")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Collection Browser

private struct CollectionBrowserView: View {
    @ObservedObject var viewModel: HadithAdultViewModel
    let collection: HadithCollection
    @State private var hadiths: [(number: Int, arabic: String, english: String)] = []
    @State private var isLoading = true
    @State private var currentPage = 1
    private let pageSize = 20

    var body: some View {
        Group {
            if isLoading && hadiths.isEmpty {
                VStack(spacing: 16) {
                    SwiftUI.ProgressView()
                    Text("Loading \(collection.name)...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else if hadiths.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "text.book.closed")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No hadiths loaded")
                        .font(.headline)
                    Text("Check your internet connection")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(hadiths, id: \.number) { hadith in
                        NavigationLink(destination: HadithDetailView(
                            viewModel: viewModel,
                            collection: collection.apiName,
                            number: hadith.number,
                            arabic: hadith.arabic,
                            english: hadith.english,
                            narrator: "",
                            grade: ""
                        )) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("#\(hadith.number)")
                                        .font(.caption.bold())
                                        .foregroundColor(.green)
                                    Spacer()
                                    if viewModel.isBookmarked(collection: collection.apiName, number: hadith.number) {
                                        Image(systemName: "bookmark.fill")
                                            .foregroundColor(.green)
                                            .font(.caption)
                                    }
                                }
                                Text(hadith.arabic)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    if hadiths.count < collection.totalHadith {
                        Button("Load More...") {
                            loadMore()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.green)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(collection.name)
        .task { await loadHadiths() }
    }

    private func loadHadiths() async {
        isLoading = true
        let start = (currentPage - 1) * pageSize + 1
        let end = min(start + pageSize - 1, collection.totalHadith)
        let range = "\(start)-\(end)"

        do {
            let results = try await HadithAPIService.shared.fetchHadithRange(collection: collection.apiName, range: range)
            hadiths = results.map { (number: $0.number, arabic: $0.arab, english: "") }
        } catch {
            // Empty fallback
        }
        isLoading = false
    }

    private func loadMore() {
        currentPage += 1
        Task {
            let start = (currentPage - 1) * pageSize + 1
            let end = min(start + pageSize - 1, collection.totalHadith)
            let range = "\(start)-\(end)"

            do {
                let results = try await HadithAPIService.shared.fetchHadithRange(collection: collection.apiName, range: range)
                let newHadiths = results.map { (number: $0.number, arabic: $0.arab, english: "") }
                hadiths.append(contentsOf: newHadiths)
            } catch {
                // Ignore
            }
        }
    }
}

// MARK: - Hadith Detail View

private struct HadithDetailView: View {
    @ObservedObject var viewModel: HadithAdultViewModel
    let collection: String
    let number: Int
    let arabic: String
    let english: String
    let narrator: String
    let grade: String

    @State private var showReflection = false
    @State private var whatTeaches = ""
    @State private var howApply = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(collection.capitalized)
                            .font(.caption.bold())
                            .foregroundColor(.green)
                        Text("Hadith #\(number)")
                            .font(.headline)
                    }
                    Spacer()

                    Button(action: {
                        viewModel.toggleBookmark(collection: collection, number: number, arabic: arabic, english: english, narrator: narrator)
                    }) {
                        Image(systemName: viewModel.isBookmarked(collection: collection, number: number) ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.green)
                            .font(.title2)
                    }

                    if viewModel.isBookmarked(collection: collection, number: number) {
                        Button(action: {
                            viewModel.toggleFavorite(collection: collection, number: number)
                        }) {
                            let isFav = viewModel.bookmarks.first { $0.collection == collection && $0.hadithNumber == number }?.isFavorite ?? false
                            Image(systemName: isFav ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.title2)
                        }
                    }
                }

                // Arabic Text
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Arabic Text")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(arabic)
                        .font(.system(size: 24))
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(12)

                    Button(action: {
                        TextToSpeechService.shared.speak(arabic, language: "ar-SA")
                    }) {
                        Label("Listen", systemImage: "speaker.wave.2.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }

                // Grade
                if !grade.isEmpty {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.green)
                        Text(grade)
                            .font(.subheadline.bold())
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }

                // Narrator
                if !narrator.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Narrator")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(narrator)
                            .font(.subheadline)
                    }
                }

                Divider()

                // Reflection Section
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: { showReflection.toggle() }) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                                .foregroundColor(.purple)
                            Text("Reflect on this Hadith")
                                .font(.headline)
                            Spacer()
                            Image(systemName: showReflection ? "chevron.up" : "chevron.down")
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)

                    if showReflection {
                        VStack(alignment: .leading, spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("What does this hadith teach?")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.purple)
                                TextEditor(text: $whatTeaches)
                                    .frame(minHeight: 80)
                                    .padding(8)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("How can I apply this today?")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.purple)
                                TextEditor(text: $howApply)
                                    .frame(minHeight: 80)
                                    .padding(8)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }

                            Button(action: {
                                viewModel.saveReflection(collection: collection, number: number, whatTeaches: whatTeaches, howApply: howApply)
                            }) {
                                Text("Save Reflection")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.purple)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Hadith #\(number)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let reflection = viewModel.getReflection(collection: collection, number: number) {
                whatTeaches = reflection.whatTeaches
                howApply = reflection.howApply
                showReflection = true
            }
        }
    }
}

// MARK: - Topics Section

private struct HadithTopicsSection: View {
    @ObservedObject var viewModel: HadithAdultViewModel

    var body: some View {
        List(viewModel.topics) { topic in
            NavigationLink(destination: TopicDetailView(viewModel: viewModel, topic: topic)) {
                HStack(spacing: 16) {
                    Text(topic.icon)
                        .font(.system(size: 32))
                    VStack(alignment: .leading, spacing: 4) {
                        Text(topic.name)
                            .font(.headline)
                        Text(topic.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        HStack {
                            ForEach(topic.keywords.prefix(3), id: \.self) { keyword in
                                Text(keyword)
                                    .font(.caption2)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Topic Detail

private struct TopicDetailView: View {
    @ObservedObject var viewModel: HadithAdultViewModel
    let topic: HadithTopic
    @State private var hadiths: [(number: Int, arabic: String, collection: String)] = []
    @State private var isLoading = true

    // Curated hadith numbers by topic
    private var curatedHadiths: [(collection: String, number: Int)] {
        switch topic.name {
        case "Worship & Prayer":
            return [("bukhari", 1), ("bukhari", 528), ("muslim", 233), ("nawawi40", 2), ("nawawi40", 3)]
        case "Character & Manners":
            return [("bukhari", 13), ("bukhari", 6018), ("nawawi40", 18), ("nawawi40", 15), ("tirmidhi", 1987)]
        case "Family & Parenting":
            return [("bukhari", 5971), ("muslim", 2588), ("bukhari", 1418), ("nawawi40", 13)]
        case "Knowledge & Learning":
            return [("bukhari", 71), ("bukhari", 100), ("tirmidhi", 2682), ("nawawi40", 34)]
        case "Daily Life":
            return [("bukhari", 6475), ("nawawi40", 12), ("nawawi40", 9), ("nawawi40", 27)]
        default:
            return [("nawawi40", 1), ("nawawi40", 2), ("nawawi40", 3)]
        }
    }

    var body: some View {
        Group {
            if isLoading {
                VStack {
                    SwiftUI.ProgressView()
                    Text("Loading \(topic.name)...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else {
                List(hadiths, id: \.number) { hadith in
                    NavigationLink(destination: HadithDetailView(
                        viewModel: viewModel,
                        collection: hadith.collection,
                        number: hadith.number,
                        arabic: hadith.arabic,
                        english: "",
                        narrator: "",
                        grade: ""
                    )) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(hadith.collection.capitalized)
                                    .font(.caption.bold())
                                    .foregroundColor(.green)
                                Text("#\(hadith.number)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text(hadith.arabic)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(topic.name)
        .task { await loadTopicHadiths() }
    }

    private func loadTopicHadiths() async {
        var results: [(number: Int, arabic: String, collection: String)] = []
        for curated in curatedHadiths {
            do {
                let hadith = try await HadithAPIService.shared.fetchHadith(collection: curated.collection, number: curated.number)
                results.append((number: hadith.number, arabic: hadith.arab, collection: curated.collection))
            } catch {
                // Skip failed fetches
            }
        }
        hadiths = results
        isLoading = false
    }
}

// MARK: - Bookmarks Section

private struct HadithBookmarksSection: View {
    @ObservedObject var viewModel: HadithAdultViewModel
    @State private var showFavoritesOnly = false

    var filteredBookmarks: [HadithBookmark] {
        if showFavoritesOnly {
            return viewModel.bookmarks.filter { $0.isFavorite }
        }
        return viewModel.bookmarks
    }

    var body: some View {
        VStack {
            if viewModel.bookmarks.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Bookmarks Yet")
                        .font(.headline)
                    Text("Browse collections and bookmark hadiths to save them here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            } else {
                HStack {
                    Button(action: { showFavoritesOnly = false }) {
                        Text("All (\(viewModel.bookmarks.count))")
                            .font(.subheadline.bold())
                            .foregroundColor(showFavoritesOnly ? .secondary : .green)
                    }
                    Button(action: { showFavoritesOnly = true }) {
                        let favCount = viewModel.bookmarks.filter { $0.isFavorite }.count
                        Text("Favorites (\(favCount))")
                            .font(.subheadline.bold())
                            .foregroundColor(showFavoritesOnly ? .red : .secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                List(filteredBookmarks) { bookmark in
                    NavigationLink(destination: HadithDetailView(
                        viewModel: viewModel,
                        collection: bookmark.collection,
                        number: bookmark.hadithNumber,
                        arabic: bookmark.arabicText,
                        english: bookmark.englishText,
                        narrator: bookmark.narrator,
                        grade: ""
                    )) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(bookmark.collection.capitalized)
                                        .font(.caption.bold())
                                        .foregroundColor(.green)
                                    Text("#\(bookmark.hadithNumber)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Text(bookmark.arabicText)
                                    .font(.system(size: 14))
                                    .lineLimit(1)
                            }
                            Spacer()
                            if bookmark.isFavorite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

// MARK: - Search Section

private struct HadithSearchSection: View {
    @ObservedObject var viewModel: HadithAdultViewModel
    @State private var searchText = ""
    @State private var searchResults: [(number: Int, arabic: String, collection: String)] = []
    @State private var isSearching = false
    @State private var selectedCollection = "nawawi40"

    let searchCollections = [
        ("nawawi40", "40 Nawawi"),
        ("bukhari", "Bukhari"),
        ("muslim", "Muslim")
    ]

    var body: some View {
        VStack(spacing: 12) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search hadiths by number...", text: $searchText)
                    .textFieldStyle(.plain)
                    .onSubmit { performSearch() }
                if !searchText.isEmpty {
                    Button(action: { searchText = ""; searchResults = [] }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            // Collection picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(searchCollections, id: \.0) { (apiName, displayName) in
                        Button(action: { selectedCollection = apiName }) {
                            Text(displayName)
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedCollection == apiName ? Color.green : Color(.secondarySystemBackground))
                                .foregroundColor(selectedCollection == apiName ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
            }

            if isSearching {
                SwiftUI.ProgressView("Searching...")
                    .padding()
            } else if !searchResults.isEmpty {
                List(searchResults, id: \.number) { result in
                    NavigationLink(destination: HadithDetailView(
                        viewModel: viewModel,
                        collection: result.collection,
                        number: result.number,
                        arabic: result.arabic,
                        english: "",
                        narrator: "",
                        grade: ""
                    )) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("#\(result.number)")
                                    .font(.caption.bold())
                                    .foregroundColor(.green)
                                Text(result.collection.capitalized)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text(result.arabic)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .lineLimit(2)
                        }
                    }
                }
                .listStyle(.plain)
            } else if !searchText.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 36))
                        .foregroundColor(.secondary)
                    Text("Enter a hadith number to search")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("Search Hadiths")
                        .font(.headline)
                    Text("Enter a hadith number to look it up")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
            }

            Spacer()
        }
    }

    private func performSearch() {
        guard let number = Int(searchText) else { return }
        isSearching = true
        Task {
            do {
                let hadith = try await HadithAPIService.shared.fetchHadith(collection: selectedCollection, number: number)
                searchResults = [(number: hadith.number, arabic: hadith.arab, collection: selectedCollection)]
            } catch {
                searchResults = []
            }
            isSearching = false
        }
    }
}
