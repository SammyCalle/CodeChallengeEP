//
//  Charger.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/9/24.
//

struct Charger : Codable {
    let id : String
    let siteID : String
    let name : String
    let evses : [Evse]
    let connectors : [Connector]
}
