//
//  Quiz List.swift
//  QuizProto
//
//  Created by MacBook Pro on 7/4/25.
//

import Foundation

struct Quiz {
    let question: String
    let answers: [String]
    let correctIndex: Int
}

let quizList: [Quiz] = [
    Quiz(question: "대한민국의 수도는?", answers: ["서울", "부산", "대전", "광주"], correctIndex: 0),
    Quiz(question: "1 + 1 = ?", answers: ["1", "2", "3", "4"], correctIndex: 1),
    Quiz(question: "Swift의 구조체 선언 키워드는?", answers: ["class", "struct", "enum", "let"], correctIndex: 1)
]
