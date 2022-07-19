//
//  ContentView.swift
//  work time
//
//  Created by Chris McElroy on 7/13/22.
//

import SwiftUI
import AVKit

enum CurrentTimer {
	case none, workTime, breakTime, workOver, breakOver
}

let purple = Color(red: 0.518, green: 0.141, blue: 0.667)
let green = Color(red: 0.027, green: 0.698, blue: 0.667)

struct ContentView: View {
	@State var currentTimer: CurrentTimer = .none
	@State var timer: Timer? = nil
	@State var time: Int = 0
	@State var startTime: Double = 0
	@State var audioPlayer: AVAudioPlayer!
	
    var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Button("Start Work") {
					withAnimation(.easeIn) {
						currentTimer = .workTime
					}
					startTime = Date.now
					time = .random(in: 1500..<2700)
					timer?.invalidate()
					timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { _ in
						self.currentTimer = .workOver
						self.audioPlayer.play()
					})
				}
				.buttonStyle(MainStyle(color: purple))
				Spacer().frame(height: 100)
				Button("Start Break") {
					withAnimation(.easeIn) {
						currentTimer = .breakTime
					}
					startTime = Date.now
					time = .random(in: 360..<1260)
					timer?.invalidate()
					timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
						time -= 1
						if time < 0 {
							self.currentTimer = .breakOver
							self.timer?.invalidate()
							self.audioPlayer.play()
						}
					})
				}
				.buttonStyle(MainStyle(color: green))
			}
			Text("WORK\nTIME!")
				.font(.system(size: 80, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
				.frame(width: 1000, height: 1000)
				.background(Rectangle().foregroundColor(purple))
				.foregroundColor(.white)
				.offset(y: currentTimer == .workTime ? 0 : -1000)
//				.onTapGesture { self.currentTimer = .workOver }
			ZStack {
				Text("BREAK\nTIME!")
					.font(.system(size: 80, weight: .bold, design: .rounded))
					.multilineTextAlignment(.center)
					.frame(width: 1000, height: 1000)
					.background(Rectangle().foregroundColor(green))
				Text("\(max(time,0)/60):\((max(time,0) % 60)/10)\(max(time,0) % 10)")
					.font(.system(size: 40, weight: .bold, design: .rounded))
					.offset(y: -200)
			}
			.foregroundColor(.white)
			.onTapGesture { self.currentTimer = .breakOver }
			.offset(y: currentTimer == .breakTime ? 0 : -1000)
			ZStack {
				Text("WORK\nOVER!")
					.font(.system(size: 80, weight: .bold, design: .rounded))
					.multilineTextAlignment(.center)
					.frame(width: 1000, height: 1000)
					.background(Rectangle().foregroundColor(.red))
					.foregroundColor(.white)
					.onTapGesture { self.currentTimer = .none }
				Button("Keep Working") {
					currentTimer = .workTime
					timer?.invalidate()
					timer = Timer.scheduledTimer(withTimeInterval: 900, repeats: false, block: { _ in
						self.currentTimer = .workOver
						self.audioPlayer.play()
					})
				}
				.buttonStyle(MainStyle(color: purple))
				.offset(y: 160)
			}
			.offset(y: currentTimer == .workOver ? 0 : -1000)
			Text("BREAK\nOVER!")
				.font(.system(size: 80, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
				.frame(width: 1000, height: 1000)
				.background(Rectangle().foregroundColor(.red))
				.foregroundColor(.white)
				.onTapGesture { self.currentTimer = .none }
				.offset(y: currentTimer == .breakOver ? 0 : -1000)
		}
		.onAppear {
			let sound = Bundle.main.path(forResource: "Duck-quack", ofType: "mp3")
			self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
		}
    }
}

struct MainStyle: ButtonStyle {
	let color: Color
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.system(size: 25, weight: .medium, design: .rounded))
			.foregroundColor(.white)
			.frame(width: 200, height: 60)
			.background(Rectangle().foregroundColor(color).cornerRadius(100))
			.opacity(configuration.isPressed ? 0.5 : 1.0)
			.shadow(radius: 4, x: 0, y: 3)
	}
}


extension Date {
	static var now: TimeInterval {
		timeIntervalSinceReferenceDate
	}
	
	static var ms: Int {
		Int(timeIntervalSinceReferenceDate*1000)
	}
}



// Ok so basically what I want is a timer button called “work” that will be a random interval between 25 and 45 minutes
// And a timer button called “break” with random time between 6 and 21 minutes
// Im undecided if I want the break to tell me how much time I have left
// But I dont want the work one to tell me
