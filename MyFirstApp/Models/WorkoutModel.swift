//
//  WorkoutModel.swift
//  MyFirstApp
//
//  Created by Pavel Andreev on 1/22/22.
//

import Foundation
import RealmSwift

class WorkoutModel: Object {
    @Persisted var workoutDate : Date
    @Persisted var workoutNumberOfDay: Int = 0
    @Persisted var workoutName : String = "Unknown"
    @Persisted var wouroutRepeat: Bool = true
}
