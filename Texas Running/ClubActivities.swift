//
//  ClubActivities.swift
//  Texas Running
//
//  Created by Leon Cai on 8/22/18.
//  Copyright © 2018 Texas Running Club. All rights reserved.
//

import Foundation

// decoding json file from strava of recent runs from members of the Texas Running Club

typealias ClubActivity = [ClubActivityElement]

struct ClubActivityElement: Codable {
    let resourceState: Int
    let athlete: Athlete
    let name: String
    let distance: Double
    let movingTime, elapsedTime: Int
    let totalElevationGain: Double
    let type: TypeEnum
    let workoutType: Int?
    
    enum CodingKeys: String, CodingKey {
        case resourceState = "resource_state"
        case athlete, name, distance
        case movingTime = "moving_time"
        case elapsedTime = "elapsed_time"
        case totalElevationGain = "total_elevation_gain"
        case type
        case workoutType = "workout_type"
    }
}

struct Athlete: Codable {
    let resourceState: Int
    let firstname, lastname: String
    
    enum CodingKeys: String, CodingKey {
        case resourceState = "resource_state"
        case firstname, lastname
    }
}

enum TypeEnum: String, Codable {
    case run = "Run"
}

