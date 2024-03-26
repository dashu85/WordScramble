//
//  ContentView.swift
//  WordScramble
//
//  Created by Marcus Benoit on 23.03.24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var currentScore = 0
    @State private var oldNumberScore = [Int]()
    @State private var oldRootWords = [String]()
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var showingResults = false

    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word.", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                    }
                }
                
                Section("Current score: ") {
                    Text("\(currentScore)")
                        .font(.headline)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                if showingResults {
                    Section("Results:") {
                        HStack {
                            VStack {
                                ForEach(0 ..< oldRootWords.count, id: \.self) { value in
                                    Text("\(oldRootWords[value])")
                                }
                            }
                            
                            Spacer()
                            
                            VStack {
                                ForEach(0 ..< oldRootWords.count, id: \.self) { value in
                                    Text("\(oldNumberScore[value]) Points")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("New Game") {
                    showingResults = true
                    oldNumberScore.insert(currentScore, at: 0)
                    oldRootWords.insert(rootWord, at: 0)
                    startGame()
                    usedWords = [String]()
                    currentScore = 0
                }
            }
            .onSubmit { addNewWord() }
            .onAppear(perform: startGame)
            // if you don't include the Button, an OK-Button will be added automatically!
            .alert(errorTitle, isPresented: $showingError) { } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        // making the word all lowercased and removing possible spaces and line breaks
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // checking if the word has at least one letter
        guard answer.count > 3 else {
            wordError(title: "Too short", message: "Your answer must contain at least 4 letters.")
            return
        }
        
        // validation to check if the word is orignal
        guard isOriginal(word: answer) else {
            wordError(title: "Word is used already", message: "Please try again")
            return
        }
    
        // validation to check if the word is possible
        guard isPossible(word: answer) else {
            wordError(title: "word not possible", message: "You can't spell that from '\(rootWord)'!")
            return
        }
        
        // validation to check if the word is real
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know?")
            return
        }
        
        // validation to check if the word is rootWord
        guard isStartNotWord(word: answer) else {
            wordError(title: "No no", message: "You can't use the same word!")
            return
        }
        
        // insert into usedWords array at first place
        withAnimation {
            usedWords.insert(answer, at: 0)
            currentScore += 1 + answer.count
        }
            
        // resetting "newWord" variable
        newWord = ""
    }
    
    func startGame() {
        // 1. Find the url for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load startWordsURL into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word
                rootWord = allWords.randomElement() ?? "Silkwork"
                // if we reached this point everything worked and we can exit
                return
            }
        }
        // if we are *here* something went wrong, trigger a crash and report the error
        fatalError("Couldn't load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isStartNotWord(word: String) -> Bool {
        if word != rootWord {
        return true
        } else {
            return false
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

#Preview {
    ContentView()
}
