//
//  GameCounter.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/10/23.
//

import SwiftUI
import Firebase
import Foundation

struct GameCounter: View {
    var tournamentID: String
    var baseString: [String]
    var group: Int
    @State var playerOneScore: Int = 0
    @State var playerOneGameScore:[Int] = []
    @State var playerOneCurrentGameScore: Int = 0
    @State var playerTwoScore: Int = 0
    @State var playerTwoCurrentGameScore: Int = 0
    @State var playerTwoGameScore:[Int] = []
    @State var gameNum: Int = 1
    @State var playerOneGameCounterScore: Int = 0
    @State var playerTwoGameCounterScore: Int = 0
    @State var errorMessage: String = ""
    @State var bString: String = ""
    @State var player1: String = ""
    @State var player2: String = ""
    @State var winner: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Button {
                    playerOneScore+=1
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(.blue)
                        Text("\(player1): \(String(playerOneScore))")
                            .font(.custom("LexendDeca-Regular", size: 36))
                            .bold()
                            .foregroundColor(.black)
                    }
                    .cornerRadius(12)
                    .onTapGesture {
                        playerOneScore += 1
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.height < 0 {
                                playerOneScore += 1
                            }
                            
                            if value.translation.height > 0 {
                                playerOneScore -= 1
                            }
                        }))
                    
                } // Player One Button
                .padding()
                
                HStack {
                    Text("Game Score: ")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    Text("Player 1 -  \(playerOneCurrentGameScore)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                    Text("|")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    Text("Player 2 - \(playerTwoCurrentGameScore)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                }
                
                HStack {
                    Button {
                        if playerOneScore > playerTwoScore {
                            playerOneCurrentGameScore += 1
                            playerOneGameCounterScore += 1
                        } else {
                            playerTwoCurrentGameScore += 1
                            playerTwoGameCounterScore += 1
                        }
                        
                        playerOneGameScore.append(playerOneScore)
                        playerTwoGameScore.append(playerTwoScore)
                        playerTwoScore = 0
                        playerOneScore = 0
                        print(playerOneGameScore)
                        print(playerTwoGameScore)
                        gameNum += 1
                    } label: {
                        if gameNum < 5 {
                            Text("Finished Game \(gameNum)")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        } else {
                            Text("")
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.height < 0 {
                                gameNum += 1
                            }
                            
                            if value.translation.height > 0 {
                                gameNum -= 1
                            }
                        }))
                    
                    if gameNum == 5 {
                        Button {
                            playerOneGameScore.append(playerOneScore)
                            playerTwoGameScore.append(playerTwoScore)
                            playerTwoScore = 0
                            playerOneScore = 0
                            print(playerOneGameScore)
                            print(playerTwoGameScore)
                            setMatch()
                            
                            if playerOneGameCounterScore > playerTwoGameCounterScore {
                                winner = player1
                            } else {
                                winner = player2
                            }
                            
                        } label: {
                            Text("Done With All Games")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                        
                    }
                }
                
                
                Button {
                    playerTwoScore+=1
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(.red)
                        Text("\(player2): \(String(playerTwoScore))")
                            .font(.custom("LexendDeca-Regular", size: 36))
                            .bold()
                            .foregroundColor(.black)
                    }
                    .cornerRadius(12)
                    .onTapGesture {
                        playerTwoScore += 1
                    }
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onEnded({ value in
                            if value.translation.height < 0 {
                                playerTwoScore += 1
                            }
                            
                            if value.translation.height > 0 {
                                playerTwoScore -= 1
                            }
                        }))
                } // Player Two
                .padding()
                Spacer()
            }
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .alert(errorMessage, isPresented: $showError, actions: {})
        }
        .task {
            if player1 == "" && player2 == "" {
                getSubstring(passedString: baseString[0])
            }
        }
    }
    
    func setMatch() {
        Task {
            do {
                let match = Match(matchID: UUID().uuidString, player1: player1, player2: player2, player1MatchScores: playerOneGameScore, player2MatchScores: playerTwoGameScore, tournamentID: tournamentID, isMatchStarted: true, winner: winner, playerOneGameScore: playerOneGameCounterScore, playerTwoGameScore: playerTwoGameCounterScore, group: group)
                try await createDocumentAtFirebase(match)
            } catch {
                await setError(error)
            }
        }
    }
    
    func getSubstring(passedString: String) {
        print(passedString)
        let text = passedString
        let regex = /Match Between: (?<player1>\w+) and (?<player2>\w+)/
        if let match = text.firstMatch(of: regex) {
            player1 = String(match.player1)
            player2 = String(match.player2)            
        }
        
    }
    
    func createDocumentAtFirebase(_ match: Match) async throws {
        let doc = Firestore.firestore().collection("Match").document()
        print(doc)
        let _ = try doc.setData(from: match, completion: { error in
            if error == nil {
                isLoading = false
                var updatedTournament = match
                updatedTournament.id = doc.documentID
            }
        })
    }
    
    //MARK: Display Errors VIA Alert
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}
  
struct GameCounter_Previews: PreviewProvider {
    static var previews: some View {
        GameCounter(tournamentID: "ifjwiofw", baseString: ["Match Between: Anish and Ishan"], group: 2)
    }
}



