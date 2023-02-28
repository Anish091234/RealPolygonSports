//
//  ManagePlayersView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/18/23.
//

import SwiftUI

struct ManagePlayersView: View {
    @AppStorage("account_type") var accountType: String = ""
    
    @State var accountCategory = ["Student", "Coach", "Parent"]
    @State var selectedAccountType: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if accountType == "" {
                        Picker("Choose Account Type", selection: $selectedAccountType) {
                            ForEach(accountCategory, id: \.self) { item in
                                Text(item)
                                    .font(.custom("LexendDeca-Regular", size: 18))
                            }
                        }.onChange(of: selectedAccountType) { newValue in
                            accountType = newValue
                        }
                    } else {
                        Text("Account Type: \(accountType)")
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .bold()
                            .font(.title3)
                    }
                    
                    if accountType == "Student" {
                        
                        StudentSelectionView()
                        
                    } else if accountType == "Parent" {
                        
                        ParentSelectionView()
                        
                    } else { //Coach Account Type
                        
                        CoachSelectionView()
                        
                    }
                }
            }
        }
    }
}

struct ManagePlayersView_Previews: PreviewProvider {
    static var previews: some View {
        ManagePlayersView()
    }
}
