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
	@State var endTime: Double = 0
	@State var endableWork: Bool = false
	@State var audioPlayer: AVAudioPlayer!
	@State var audioSession: AVAudioSession! = AVAudioSession.sharedInstance()
	@State var taskID: UIBackgroundTaskIdentifier? = nil
	
    var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Button("Long Work") {
					startWorkTimer(in: 1500..<2700)
				}
				.buttonStyle(MainStyle(color: purple))
				Spacer().frame(height: 50)
				Button("Short Work") {
					startWorkTimer(in: 600..<1500)
				}
				.buttonStyle(MainStyle(color: purple.opacity(0.5)))
				Spacer().frame(height: 100)
				Button("Long Break") {
					startBreakTimer(in: 360..<1260)
				}
				.buttonStyle(MainStyle(color: green))
				Spacer().frame(height: 50)
				Button("Short Break") {
					startBreakTimer(in: 60..<240)
				}
				.buttonStyle(MainStyle(color: green.opacity(0.5)))
			}
			Text("WORK\nTIME!")
				.font(.system(size: 80, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
				.frame(width: 1000, height: 1000)
				.background(Rectangle().foregroundColor(purple))
				.foregroundColor(.white)
				.offset(y: currentTimer == .workTime ? 0 : -1000)
				.onTapGesture {
					if endableWork {
						self.currentTimer = .workOver
						clearNotifications()
						playSound()
						timer?.invalidate()
					}
				}
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
			.onTapGesture {
				self.currentTimer = .breakOver
				clearNotifications()
				playSound()
				timer?.invalidate()
			}
			.offset(y: currentTimer == .breakTime ? 0 : -1000)
			ZStack {
				Text("WORK\nOVER!")
					.font(.system(size: 80, weight: .bold, design: .rounded))
					.multilineTextAlignment(.center)
					.frame(width: 1000, height: 1000)
					.background(Rectangle().foregroundColor(.red))
					.foregroundColor(.white)
					.onTapGesture {
						self.currentTimer = .none
						endSound()
					}
					.onAppear {
						endableWork = false
					}
				Button("Keep Working") {
					endSound()
					endableWork = true
					startWorkTimer(in: 800..<1000)
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
				.onTapGesture {
					self.currentTimer = .none
					endSound()
				}
				.offset(y: currentTimer == .breakOver ? 0 : -1000)
		}
		.onAppear {
			_ = try? audioSession.setCategory(.ambient, options: [.duckOthers])
			let sound = Bundle.main.path(forResource: "Duck-quack", ofType: "mp3")
			self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
			turnOnNotifications()
		}
    }
	
	func playSound() {
		_ = try? audioSession.setActive(true)
		self.audioPlayer.play()
	}
	
	func endSound() {
		self.audioPlayer.stop()
		_ = try? audioSession.setActive(false)
	}
	
	func startWorkTimer(in timeRange: Range<Int>) {
		withAnimation(.easeIn) {
			currentTimer = .workTime
		}
		time = .random(in: timeRange)
		setNotification(for: TimeInterval(time))
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { _ in
			self.currentTimer = .workOver
			playSound()
		})
	}
	
	func startBreakTimer(in timeRange: Range<Int>) {
		withAnimation(.easeIn) {
			currentTimer = .breakTime
		}
		time = .random(in: timeRange)
		setNotification(for: TimeInterval(time))
		endTime = Date.now + Double(time)
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
			time = Int(endTime - Date.now)
			if time < 0 {
				self.currentTimer = .breakOver
				self.timer?.invalidate()
				playSound()
			}
		})
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

func turnOnNotifications(callBack: @escaping (Bool) -> Void = {_ in }) {
	UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { success, error in
		if let error = error { print(error.localizedDescription) }
		callBack(success)
	}
	clearNotifications()
}

func clearNotifications() {
	UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
	UNUserNotificationCenter.current().removeAllDeliveredNotifications()
}

func setNotification(for timeInterval: TimeInterval) {
	clearNotifications()
	let content = UNMutableNotificationContent()
	content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Duck-quack.mp3"))
	content.title = "quack"
	content.body = ""
	let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
	let request = UNNotificationRequest(identifier: "workTime", content: content, trigger: trigger)
	UNUserNotificationCenter.current().add(request)
}

// Ok so basically what I want is a timer button called “work” that will be a random interval between 25 and 45 minutes
// And a timer button called “break” with random time between 6 and 21 minutes
// Im undecided if I want the break to tell me how much time I have left
// But I dont want the work one to tell me
