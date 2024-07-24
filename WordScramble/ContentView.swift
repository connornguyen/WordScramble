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
    
    
    var body: some View {
        NavigationStack{
            Text(rootWord)
                .font(.largeTitle)
            List {
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
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
        
    }
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard newWord.count > 0 else { return }
        
        //More code to come
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
}

#Preview {
    ContentView()
}
