//
//  Logo.swift
//  Launch CS
//
//  Created by Julian Schiavo.
//  Copyright © 2021. All rights reserved.
//

import SwiftUI

struct LaunchCS: Program {
    @State var status: Status
    func go() {
        switch status {
        case .joinUs:
            "j@schiavo.me"
        case .getReady:
            print("🚀 T minus 3 months to launch")
            apple.createPartnership()
            selectASchool(whichIsAwesome: true)
            recruitAllStudents(whoLikeCoding: true)
            volunteers.forEach { $0.train() }
        case .start:
            volunteers.forEach { $0.getReady() }
            startTeaching(today, at: school)
            print("🎉 Go for launch, go for launch")
        }
    }
}

let program = LaunchCS()
program.launch()








enum Status { case getReady, start, joinUs }
struct Volunteer {
    func train() { }
    func createPartnership() { }
    func getReady() { }
    func prepareForCourse() { }
}
extension LaunchCS {
    let volunteers: [Volunteer]
    func selectASchool(whichIsAwesome: Bool) { }
    func recruitAllStudents(whoLikeCoding: Bool) { }
    func startTeaching(_ on: Date, at: Volunteer)
    let today = Date()
    let school = Volunteer()
    let apple = Volunteer()
}












