//
//  ViewController.swift
//  SpacedRepetition
//
//  Created by Michael Charland on 2019-03-14.
//  Copyright © 2019 charland. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var testQuestions = ["1","2","3","4","5"]

    var questions = Questions()
    var currentQuestion: Question?

    @IBOutlet weak var lastTimeAsked: UILabel!
    @IBOutlet weak var nextTimeToAsk: UILabel!
    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var nextQuestionButton: UIButton!
    @IBOutlet weak var rightAnswerButton: UIButton!
    @IBOutlet weak var wrongAnswerButton: UIButton!

    @IBAction func nextQuestion(_ sender: Any) {
        rightAnswerButton.isEnabled = true
        wrongAnswerButton.isEnabled = true
        setNextQuestion()
    }

    @IBAction func rightButton(_ sender: Any) {
        rightAnswerButton.isEnabled = false
        wrongAnswerButton.isEnabled = false
        setRightAnswer()
    }

    @IBAction func wrongButton(_ sender: Any) {
        rightAnswerButton.isEnabled = false
        wrongAnswerButton.isEnabled = false
        setWrongAnswer()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        questions.add(questions: testQuestions)
        setNextQuestion()
    }

    func setNextQuestion() {

        guard let next = questions.getNextQuestion() else {
            rightAnswerButton.isEnabled = false
            wrongAnswerButton.isEnabled = false
            nextQuestionButton.isEnabled = false
            return
        }
        currentQuestion = next
        updateQuestion()
    }

    func setRightAnswer() {
        questions.correctAnswer()
        updateQuestion()
    }

    func setWrongAnswer() {
        questions.wrongAnswer()
        updateQuestion()
    }

    func updateQuestion() {
        guard let currentQuestion = currentQuestion else {
            return
        }

        questionNumber.text = currentQuestion.title

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        if let date = currentQuestion.lastTimeAnswered {
            lastTimeAsked.text = formatter.string(from: date)
        } else {
            lastTimeAsked.text = "Never"
        }

        if let date = currentQuestion.nextTimeToAsk {
            nextTimeToAsk.text = formatter.string(from: date)
        } else {
            nextTimeToAsk.text = "Today"
        }

        correctLabel.text = String(currentQuestion.timesCorrect)
        totalLabel.text = String(currentQuestion.timesAsked)
    }
}
