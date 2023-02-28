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
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @State private var playerOneScore: Int = 0
    @State private var playerOneGameScore:[Int] = []
    @State private var playerOneCurrentGameScore: Int = 0
    @State private var playerTwoScore: Int = 0
    @State private var playerTwoCurrentGameScore: Int = 0
    @State private var playerTwoGameScore:[Int] = []
    @State private var gameNum: Int = 1
    @State private var playerOneGameCounterScore: Int = 0
    @State private var playerTwoGameCounterScore: Int = 0
    @State private var errorMessage: String = ""
    @State private var bString: String = ""
    @State private var player1: String = ""
    @State private var player2: String = ""
    @State private var winner: String = ""
    @State private var showError: Bool = false
    @State private var isLoading: Bool = false
    @State private var player2UID: String = ""
    @State private var localMatchDocs: [UserMatchDoc] = []
    @State private var doneWithGame: Bool = false
    var body: some View {
        VStack {
            VStack {
                Spacer()
                
                //MARK: Player One Game Score
                HStack {
                    
                    Text("Game Score: \(player1)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                    
                    Text("|")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(playerOneGameScore, id: \.self) { index in
                                Text(String(index))
                                    .font(.custom("LexendDeca-Regular", size: 18))

                            }
                        }
                    }
                }
                .frame(height: 60)
                .padding(.leading)
                .padding(.trailing)
                
                Divider()
                
                //MARK: Player One Button
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
                    
                }
                .padding()
                
                //MARK: Game Score - Players
                HStack {
                    Text("Game Score: ")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    Text("\(player1) -  \(playerOneCurrentGameScore)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                    Text("|")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    Text("\(player2) - \(playerTwoCurrentGameScore)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                }
                
                //MARK: Done with game + finished with all games
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
                            
                            doneWithGame = true
                            
                        } label: {
                            Text("Done With All Games")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                        .disabled(doneWithGame)
                        
                    }
                }
                
                //MARK: Player Two Button
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
                }
                .padding()
                
                Divider()
                
                //MARK: Player 2 Game Score
                HStack {
                    
                    Text("Game Score: \(player2)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                    
                    Text("|")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .bold()
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(playerTwoGameScore, id: \.self) { index in
                                Text(String(index))
                                    .font(.custom("LexendDeca-Regular", size: 18))

                            }
                        }
                    }
                }
                .frame(height: 60)
                .padding(.leading)
                .padding(.trailing)
                
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
            
            print("Before seachMatchesDoc(): \(localMatchDocs)")
            
            await searchMatchesDoc()
            
            print("After searchMatchesDoc():\(localMatchDocs)")
            
            await getPlayerTwoUID()
            
        }
    }
    
    func searchMatchesDoc() async {
        do {
            
            let documents = try await Firestore.firestore().collection("UserMatchDocs")
                .getDocuments()
            
            let matchDocs = try documents.documents.compactMap { doc -> UserMatchDoc? in
                try doc.data(as: UserMatchDoc.self)
            }
            
            await MainActor.run(body: {
                localMatchDocs = matchDocs
                isLoading = false
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setMatch() {
        Task {
            do {
                var contains: Bool = false
                
                for docs in localMatchDocs {
                    if docs.uid == userUID {
                        contains = true
                        print("i")
                    }
                }
                
                if contains == true { //MARK: MATCH DOCUMENT DOES EXIST (UPDATE)
                    print("MATCH DOCUMENT DOES EXIST")
                    
                    let match = Match(matchID: (await randomString(length: 20)), player1: player1, player2: player2, player1MatchScores: playerOneGameScore, player2MatchScores: playerTwoGameScore, tournamentID: tournamentID, isMatchStarted: true, winner: winner, playerOneGameScore: playerOneGameCounterScore, playerTwoGameScore: playerTwoGameCounterScore, group: group)
                    
                    try await Firestore.firestore().collection("UserMatchDocs").document(userUID).updateData(
                        ["match" : FieldValue.arrayUnion([match.matchID])]
                    )
                    
                    try await Firestore.firestore().collection("UserMatchDocs").document(player2UID).updateData(
                        ["match" : FieldValue.arrayUnion([match.matchID])]
                    )
                    
                    try await createDocumentAtFirebase(match)
                    
                } else { //MARK: MATCH DOCUMENT DOES NOT EXIST (CREATE)
                    print("NO MATCH DOCUMENT EXIST")
                    
                    let match = Match(matchID: (await randomString(length: 20)), player1: player1, player2: player2, player1MatchScores: playerOneGameScore, player2MatchScores: playerTwoGameScore, tournamentID: tournamentID, isMatchStarted: true, winner: winner, playerOneGameScore: playerOneGameCounterScore, playerTwoGameScore: playerTwoGameCounterScore, group: group)
                    
                    let matchDoc = UserMatchDoc(id: userUID, name: userNameStored, uid: userUID, match: [match.matchID], lastPlayedMatch: Date())
                    
                    let playerTwoMatchDoc = UserMatchDoc(id: player2UID, name: player2, uid: player2UID, match: [match.matchID], lastPlayedMatch: Date())
                    
                    try await createDocumentAtFirebase(match)
                    try await createUserMatchDocumentAtFirebase(matchDoc, uid: userUID)
                    try await createUserMatchDocumentAtFirebase(playerTwoMatchDoc, uid: player2UID)
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    func randomString(length: Int) async -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func getSubstring(passedString: String) {
        let text = passedString
        let regex = /Match Between: (?<player1>\w+) and (?<player2>\w+)/
        if let match = text.firstMatch(of: regex) {
            player1 = String(match.player1)
            player2 = String(match.player2)
        }
    }
    
    func createDocumentAtFirebase(_ match: Match) async throws {
        let doc = Firestore.firestore().collection("Match").document()
        let _ = try doc.setData(from: match, completion: { error in
            if error == nil {
                isLoading = false
                var updatedTournament = match
                updatedTournament.id = doc.documentID
            }
        })
    }
    
    func createUserMatchDocumentAtFirebase(_ docs: UserMatchDoc, uid: String) async throws {
        let doc = Firestore.firestore().collection("UserMatchDocs").document(uid)
        
        let _ = try doc.setData(from: docs, completion: { error in
            if error == nil {
                isLoading = false
                var updatedTournament = docs
                updatedTournament.id = doc.documentID
            }
        })
    }
    
    func getPlayerTwoUID() async {
        do {
            let documents = try await Firestore.firestore().collection("Players")
                .getDocuments()
            
            let fetchedPlayers = try documents.documents.compactMap { doc -> Player? in
                try doc.data(as: Player.self)
            }
            
            await MainActor.run(body: {
                for player in fetchedPlayers {
                    if player.name == player2 {
                        player2UID = player.parentAccountUID
                    }
                }
            })
            
        } catch {
            print(error.localizedDescription)
        }
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



