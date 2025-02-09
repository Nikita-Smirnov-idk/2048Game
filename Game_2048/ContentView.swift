import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var gameManager = GameManager()

    var body: some View {
        GeometryReader{ proxy in
            VStack{
                Spacer()
                VStack(spacing: 20) {
                    Text("2048")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.gray)
                    
                    
                    Text("Get 2048 to win!")
                        .fontWeight(.bold)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.gray)
                    
                    Text("Moves: \(gameManager.moves)")
                        .fontWeight(.bold)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.gray)
                    
                    GameBoardView(gameManager: gameManager)
                        .gesture(DragGesture()
                            .onEnded { value in
                                gameManager.handleSwipe(value.translation)
                            })
                    
                    Button("Restart") {
                        gameManager.restartGame()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
                .padding()
                .background(Color.black)
                .alert(isPresented: $gameManager.isGameOver) {
                    Alert(
                        title: Text("Game Over"),
                        message: Text("Try Again?"),
                        primaryButton: .default(Text("Restart")) {
                            gameManager.restartGame()
                        },
                        secondaryButton: .cancel()
                    )
                }
                Spacer()
            }.frame(width: proxy.size.width)
                .background(Color.black)
        }
    }
}

struct GameBoardView: View {
    @ObservedObject var gameManager: GameManager

    var body: some View {
        ZStack {
            ForEach(0..<4, id: \.self) { row in
                ForEach(0..<4, id: \.self) { col in
                    if let tile = gameManager.board[row][col] {
                        TileView(
                            value: tile.value,
                            position: positionForTile(row: row, col: col)
                        )
                    }
                }
            }
        }
        .frame(width: 295, height: 295)
        .background(Color.gray)
        .cornerRadius(10)
    }

    func positionForTile(row: Int, col: Int) -> CGPoint {
        let tileSize: CGFloat = 70
        let spacing: CGFloat = 5
        let x = CGFloat(col) * (tileSize + spacing) + tileSize / 2
        let y = CGFloat(row) * (tileSize + spacing) + tileSize / 2
        return CGPoint(x: x, y: y)
    }
}


struct TileView: View {
    let value: Int?
    let position: CGPoint

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(value == nil ? Color.white : colorForValue(value!))
                .frame(width: 70, height: 70)

            if let value = value {
                Text("\(value)")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .font(.largeTitle)
            }
        }
        .position(position) // Position changes with animation
        .animation(.easeInOut(duration: 0.2), value: position)
    }

    func colorForValue(_ value: Int) -> Color {
        switch value {
        case 2: return .yellow
        case 4: return .orange
        case 8: return .red
        case 16: return .pink
        case 32: return .purple
        case 64: return .blue
        case 128: return .green
        case 256: return .teal
        case 512: return .brown
        case 1024: return .cyan
        case 2048: return .white
        default: return .black
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

