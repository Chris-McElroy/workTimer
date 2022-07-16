//
//  ContentView.swift
//  work time
//
//  Created by Chris McElroy on 7/13/22.
//

import SwiftUI

enum CurrentTimer {
	case none, workTime, breakTime, timerOver
}

struct ContentView: View {
	@State var currentTimer: CurrentTimer = .none
	@State var timer: Timer? = nil
	
    var body: some View {
		ZStack {
			VStack(spacing: 0) {
				Button("Start Work") {
					withAnimation(.easeIn) {
						currentTimer = .workTime
					}
					timer?.invalidate()
					timer = Timer.scheduledTimer(withTimeInterval: .random(in: 1500..<2700), repeats: false, block: { _ in
						self.currentTimer = .timerOver
					})
				}
				.buttonStyle(MainStyle(color: .blue))
				Spacer().frame(height: 100)
				Button("Start Break") {
					withAnimation(.easeIn) {
						currentTimer = .breakTime
					}
					timer?.invalidate()
					timer = Timer.scheduledTimer(withTimeInterval: .random(in: 360..<1260), repeats: false, block: { _ in
						self.currentTimer = .timerOver
					})
				}
				.buttonStyle(MainStyle(color: .orange))
			}
			Text("WORK\nTIME!")
				.font(.system(size: 80, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
				.frame(width: 400, height: 1000)
				.background(Rectangle().foregroundColor(.blue))
				.foregroundColor(.white)
				.offset(y: currentTimer == .workTime ? 0 : -1000)
//				.onTapGesture { self.currentTimer = .timerOver }
			Text("BREAK\nTIME!")
				.font(.system(size: 80, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
				.frame(width: 400, height: 1000)
				.background(Rectangle().foregroundColor(.orange))
				.foregroundColor(.white)
				.offset(y: currentTimer == .breakTime ? 0 : -1000)
//				.onTapGesture { self.currentTimer = .timerOver }
			Text("TIMER\nDONE!")
				.font(.system(size: 80, weight: .bold, design: .rounded))
				.multilineTextAlignment(.center)
				.frame(width: 400, height: 1000)
				.background(Rectangle().foregroundColor(.red))
				.foregroundColor(.white)
				.onTapGesture { self.currentTimer = .none }
				.offset(y: currentTimer == .timerOver ? 0 : -1000)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Ok so basically what I want is a timer button called “work” that will be a random interval between 25 and 45 minutes
// And a timer button called “break” with random time between 6 and 21 minutes
// Im undecided if I want the break to tell me how much time I have left
// But I dont want the work one to tell me
