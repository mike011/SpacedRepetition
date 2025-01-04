//
//  ContentView.swift
//  Example
//
//  Created by Michael Charland on 2025-01-04.
//

import SpacedRepetition
import SwiftUI

struct ContentView: View {

    @State var model: QuestionViewModel

    @State private var rightAnswerButton = true
    @State private var wrongAnswerButton = true
    @State private var nextQuestionButton = false

    var body: some View {
        VStack {
            HStack {
                Text("Question:")
                Text(model.questionTitle)
            }
            HStack {
                Text("Stats:")
                Text(model.correctlyAnswered)
                Text("/")
                Text(model.questionCount)
            }
            HStack {
                Text("Last Time Asked:")
                Text(model.lastTimeAsked)
            }
            HStack {
                Text("Next Time to Ask:")
                Text(model.nextTimeToAsk)
            }
            HStack {
                Button("Right") {
                    handleAnswer(correct: true)
                }.disabled(!rightAnswerButton)
                Button("Wrong") {
                    handleAnswer(correct: false)
                }.disabled(!wrongAnswerButton)
            }.padding()
            Button("Next Question") {
                rightAnswerButton = true
                wrongAnswerButton = true
                model.nextQuestion()
            }.disabled(!nextQuestionButton)
        }
        .padding()
    }

    func handleAnswer(correct: Bool) {
        rightAnswerButton = false
        wrongAnswerButton = false
        nextQuestionButton = true
        if correct {
            model.correctAnswer()
        } else {
            model.incorrectAnswer()
        }
    }
}

#Preview {
    ContentView(model: createQuestions())
}
