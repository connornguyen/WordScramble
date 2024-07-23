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
            List {
                TextField("Enter your word", text: $newWord)
                    .textInputAutocapitalization(.never)
            }
            Form {
                ForEach(usedWords, id: \.self){ word in
                    HStack{
                        Image(systemName: "\(word.count).circle" )
                        Text(word)
                    }
                }
            }
            .formStyle(.grouped)
        }
        .navigationTitle(rootWord)
        .onSubmit {
            addNewWord()
        }
        
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
}




#Preview {
    ContentView()
}
