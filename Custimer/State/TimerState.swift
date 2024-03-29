//
//  ProgramTimer.swift
//  Custimer
//
//  Created by Jonathan Diehl on 29.12.20.
//

import Foundation

class TimerState: ObservableObject {
  
  @Published var program: Program { didSet { reset() } }
  @Published private(set) var index = ProgramIndex.atStart()
  @Published private(set) var running = false

  var step: Program.Step? { return self.program.step(at: self.index) }
  var appearance: Appearance { return self.program.appearance }

  private var timer: SecondsTimer? = nil
  
  init(program: Program, index: ProgramIndex? = nil) {
    self.program = program
    reset()
    if let index = index { set(index: index) }
  }
  
  // start the timer
  func start() {
    guard !running else { return }
    
    // auto-reset if necessary
    if index.state == .finished { self.reset() }
    
    // disable idle timer
    IdleTimerService.shared.disable()
    
    // schedule notifications
    NotificationService.shared.schedule(program: program, after: index)
    
    // setup timer
    timer = SecondsTimer(startSeconds: index.time) { seconds in self.onTick(seconds: seconds) }

    // we are now running
    running = true
  }
  
  // stop the timer and clean up
  func stop() {
    guard running else { return }

    // disable the timer
    timer!.invalidate()
    timer = nil

    // enable idle timer
    IdleTimerService.shared.enable()
    
    // cancel notifications
    NotificationService.shared.cancel()
    
    // disable sounds
    SoundService.shared.set(active: false)

    // we are now stopped
    running = false
  }

  // stop the timer and set the index back to the start
  func reset() {
    stop()
    index = ProgramIndex.atStart()
    
    // set sound service
    SoundService.shared.soundEnabled = program.sound
    SoundService.shared.speechEnabled = program.speech
  }
  
  // update the timer
  func set(index: ProgramIndex) {
    if let timer = self.timer {
      timer.addSeconds = self.index.timeDifference(to: index)
    } else {
      self.index = index
    }
  }
  
  // MARK: - Private Methods
  
  private func onTick(seconds: Int) {
    index = ProgramIndex.at(program: program, time: seconds)
    if self.index.state == .finished {
      onFinish()
      return
    }
    
    // manage sound session
    SoundService.shared.set(active: self.program.shouldPrepareForSounds(at: self.index))
    
    // play sounds
    let announce = self.program.announce(at: self.index)
    if let sound = self.program.sound(at: self.index) {
      SoundService.shared.play(sound: sound, followedByText: announce)
    } else {
      if announce != nil { SoundService.shared.announce(text: announce!) }
    }
  }
  
  private func onFinish() {
    SoundService.shared.play(sound: .finish, followedByText: "All done")
    stop()
    RatingService.shared.request()
  }
  
}
