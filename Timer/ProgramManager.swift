//
//  ProgramManager.swift
//  Timer
//
//  Created by Jonathan Diehl on 12.07.20.
//  Copyright © 2020 Jonathan Diehl. All rights reserved.
//

protocol ProgramManagerDelegate: AnyObject {
  func managerChangedProgram(programManager: ProgramManager)
}

class ProgramManager {
  static let shared = ProgramManager()
  
  weak var delegate: ProgramManagerDelegate?
  
  var activeProgram = Program(json: """
  {
    "title": "Aquafitness",
    "tint": "Crimson:Automatic",
    "steps": [
      { "title": "Warmup", "length": 60 },
      { "title": "high knee jogging - nudel beidhaendig nach unten druecken", "length": 30 },
      { "title": "high knee jogging - nudelenden zu den knoecheln bringen", "length": 30 }
    ]
  }
""")!
//    Program.Step(title: "regular jogging - nudel im rainbow im wechsel", length: 30),
//    Program.Step(title: "rock 'n' roll - nudel im rainbow diagonal im wechsel", length: 30),
//    Program.Step(title: "wide jogging - nudel im rainbow diagonal beidhaendig", length: 30),
//    Program.Step(title: "wide jogging - nudel im rainbow seitlich im wechsel oeffnen", length: 30),
//    Program.Step(title: "huepfen und twisten - nudel flach von seite zu seite ", length: 30),
//    Program.Step(title: "wide jogging - nudel seitlich einhaendig nach unten (rechts)", length: 30),
//    Program.Step(title: "wide jogging - nudel seitlich einhaendig nach unten (links)", length: 30),
//    Program.Step(title: "wide jogging - nudel seitlich einhaendig zur seite (rechts)", length: 30),
//    Program.Step(title: "wide jogging - nudel seitlich einhaendig zur seite (links)", length: 30),
//    Program.Step(title: "rechts stehen links hochstrecken - nudel einhaendig zum knoechel (rechts)", length: 30),
//    Program.Step(title: "links stehen rechts hochstrecken - nudel einhaendig zum knoechel (links)", length: 30),
//    Program.Step(title: "ass kick jogging - nudel im rainbow im wechsel", length: 30),
//    Program.Step(title: "ass kick jogging - nudel im rainbow oeffnen und schliessen", length: 30),
//    Program.Step(title: "ass kick jogging - nudel im rainbow beidhaendig vor und zurueck schieben", length: 30),
//    Program.Step(title: "nudel hinten - beine anziehen und nach unten strecken - haende zu knoecheln", length: 30),
//    Program.Step(title: "nudel hinten - beine abwechselnd anziehen und grade rausstrecken ", length: 30),
//    Program.Step(title: "nudel hinten - beine anziehen und im wechsel zur seite strecken", length: 30),
//    Program.Step(title: "rock 'n' roll - nudel hinter sich nach unten gedrueckt halten", length: 30),
//    Program.Step(title: "fahrrad fahren - linkes bein - rechter arm (vor- und rueckwaerts)", length: 30),
//    Program.Step(title: "fahrrad fahren - rechtes bein - linker arm (vor- und rueckwaerts)", length: 30),
//    Program.Step(title: "nudel mittig mit rechtem fuss rauf und runter", length: 30),
//    Program.Step(title: "nudel mittig mit linkem fuss rauf und runter", length: 30),
//    Program.Step(title: "rock 'n' roll - nudel im rainbow hinterm ruecken oeffnen und schliessen", length: 30),
//    Program.Step(title: "regular jogging - nudel als paddel im wechsel", length: 30)
  {
    didSet {
      delegate?.managerChangedProgram(programManager: self)
      
    }
  }
  
  lazy var localPrograms = [
    activeProgram,
    Program(json: """
      {
        "title": "Test",
        "tint": "Sky:Colored",
        "steps": [
          { "title": "One", "length": 60 },
          { "title": "Two", "length": 30 },
          { "title": "Three", "length": 60 }
        ]
      }
    """)!
  ]
  
}
