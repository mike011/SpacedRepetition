//
//  ExampleApp.swift
//  Example
//
//  Created by Michael Charland on 2025-01-04.
//

import SpacedRepetition
import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            // We'll just use the app name for the category name for the sample app.
            ContentView(model: createQuestions())
        }
    }
}

func createQuestions() -> QuestionViewModel {
    let questions = Questions()
    let data = ["1","2","3","4","5"].map { s in
        Question(title: s, answer: "", category: "") }
    questions.add(questions: data)
    return QuestionViewModel(questions: questions)
}
