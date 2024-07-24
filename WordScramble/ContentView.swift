//
//  ContentView.swift
//  WordScramble
//
//  Created by Apple on 23/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack{
            Text(rootWord)
                .font(.largeTitle)
            List {
                Section{
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                }
            }
            Section {
                ForEach(usedWords, id: \.self){ word in
                    HStack{
                        Image(systemName: "\(word.count).circle" )
                        Text(word)
                    }
                }
            }
        
        }
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError){
            Button("OK") {}
        } message: {
            Text(errorMessage)
        }
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard newWord.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Not Original Word", message: "You must using existing English Word")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Not possible", message: "You can't break the rule")
            return
        }
        
        guard isRealWord(word: answer) else {
            wordError(title: "Not a real word", message: "Try using a real word, you can't just make word up")
            return
        }
        
        withAnimation{
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    
    func startGame(){
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "Silkworm"
                
                return
            }
        }
        
        fatalError("Could not load start.txt file")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isRealWord(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let missSpellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return missSpellRange.location == NSNotFound
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
