import SwiftUI

struct FlagImageView: View {
    var flagName: String
    
    init(_ flagName: String) {
        self.flagName = flagName
    }
    
    var body: some View {
        Image(flagName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct WelcomeTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
    }
}

extension View {
    func welcome() -> some View {
        modifier(WelcomeTitleModifier())
    }
}

struct ContentView: View {
    private let gameLength = 8
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingGameFinished = false
    
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var totalScore = 0
    @State private var currentGameState = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: .indigo, location: 0.3),
                .init(color: .cyan.opacity(0.5), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .welcome()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold ))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImageView(countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .font(.title.bold())
                
                Spacer()
            }.padding()
        }
        .alert("You finished with a score of: \(totalScore)", isPresented: $showingGameFinished) {
            Button("Play Again", action: {
                resetGame()
                askQuestion()
            })
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Corret"
            totalScore += 1
            scoreMessage = ""
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "That's the flag of \(countries[number])"
        }
        
        if currentGameState == gameLength {
            showingGameFinished = true
            return
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentGameState += 1
    }
    
    func resetGame() {
        scoreTitle = ""
        scoreMessage = ""
        totalScore = 0
        currentGameState = 0
    }
}

#Preview {
    ContentView()
}
