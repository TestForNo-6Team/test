//
//  ContentView.swift
//  QuizProto
//
//  Created by MacBook Pro on 7/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentIndex = 0
    @State private var showResult = false
    @State private var resultMessage = ""
    @State private var score = 0
    @State private var startTime = Date()
    @State private var elapsedTime: TimeInterval = 0
    @State private var timerActive = true
    @State private var timeLimit: TimeInterval = 20

    // 셔플된 보기와 정답 인덱스
    @State private var shuffledAnswers: [String] = []
    @State private var shuffledCorrectIndex: Int = 0

    let quizzes = quizList
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 30) {
            Text("과목 선택: Swift")
                .font(.headline)
                .padding(.top, 20)

            Text("문제 \(currentIndex + 1) / \(quizzes.count)")
                .font(.subheadline)
                
            
            Text("남은 시간: \(Int(timeLimit - elapsedTime))초")
                .font(.headline)
                .foregroundColor((timeLimit - elapsedTime) <= 5 ? .red : .primary)
                .onReceive(timer) { _ in
                    guard timerActive && !showResult else { return }
                    elapsedTime = Date().timeIntervalSince(startTime)
                    if elapsedTime >= timeLimit {
                        timerActive = false
                        resultMessage = "시간 초과! 정답은 '\(shuffledAnswers[shuffledCorrectIndex])'"
                        showResult = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            nextQuiz()
                        }
                    }
                }

            Text(quizzes[currentIndex].question)
                .font(.title2)
                .padding()

            ForEach(0..<shuffledAnswers.count, id: \.self) { idx in
                Button(action: {
                    checkAnswer(idx)
                }) {
                    Text(shuffledAnswers[idx])
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(showResult || !timerActive)
            }

            if showResult {
                Text(resultMessage)
                    .font(.title3)
                    .foregroundColor(resultMessage.contains("정답") ? .green : .red)
                    .padding()
            }

            Spacer()
            Text("점수: \(score)")
                .font(.headline)
        }
        .padding()
        .onAppear {
            setupQuiz()
        }
    }

    func setupQuiz() {
        let quiz = quizzes[currentIndex]
        // 보기 셔플
        let zipped = quiz.answers.enumerated().map { $0 }
        let shuffled = zipped.shuffled()
        shuffledAnswers = shuffled.map { $0.element }
        // 셔플된 배열에서 정답 인덱스 찾기
        shuffledCorrectIndex = shuffled.firstIndex(where: { $0.offset == quiz.correctIndex }) ?? 0

        startTime = Date()
        elapsedTime = 0
        timerActive = true
        showResult = false
    }

    func checkAnswer(_ idx: Int) {
        guard timerActive else { return }
        if idx == shuffledCorrectIndex {
            resultMessage = "정답입니다! 👏 (풀이 시간: \(Int(elapsedTime))초)"
            score += 1
        } else {
            resultMessage = "틀렸어요. 정답은 '\(shuffledAnswers[shuffledCorrectIndex])' (풀이 시간: \(Int(elapsedTime))초)"
        }
        showResult = true
        timerActive = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            nextQuiz()
        }
    }

    func nextQuiz() {
        if currentIndex < quizzes.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
            score = 0
        }
        setupQuiz()
    }
}




#Preview {
    ContentView()
}
