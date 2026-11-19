//
//  SavedCodesView.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 04.01.25.
//

import SwiftUI

struct SavedCodesView: View {
    
    @Binding var isPresentingSavedCodes: Bool
    @Binding var currentTextToEncode: String
    @Binding var currentFormat: String
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var savedCodeViewModel: SavedCodeViewModel
    
    var dateFormatterDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy"
        formatter.locale = Locale(identifier: "de_DE")
        return formatter
    }

    var dateFormatterTime: DateFormatter {
        let fmtr = DateFormatter()
        fmtr.dateFormat = "HH:mm:ss"
        return fmtr
    }
    
    var body: some View {
        ZStack() {
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        HStack() {
                            Text("savedCodes")
                                .font(.system(size: 32, weight: .heavy))
                                .padding(.bottom)
                            Spacer()
                        }
                        
                        /*
                            HStack() {
                                Text("savedCodesInstructions")
                                    .font(.system(size: 17, weight: .medium))
                                Spacer()
                            }
                            .padding(.bottom, 20)
                        */
                        if savedCodeViewModel.savedCodes.isEmpty {
                                HStack() {
                                    Spacer()
                                    Text("noSavedCodes")
                                        .font(.system(size: 20, weight: .heavy))
                                        .padding(.bottom)
                                    Spacer()
                                }.padding(.top, 80)
                        }
                        
                        
                        
                        
                        
                        ForEach(savedCodeViewModel.savedCodes, id: \.self ) { savedCode in
                            HStack(alignment: .top) {
                                Button(action: {
                                    withAnimation(.linear(duration: 0.2)) {
                                        currentTextToEncode = savedCode.textToEncode
                                        currentFormat = savedCode.format
                                        isPresentingSavedCodes.toggle()
                                    }
                                }) {
                                    
                                    HStack(alignment: .top) {
                                        
                                        VStack(alignment: .leading) {
                                            HStack() {
                                                Text(savedCode.textToEncode)
                                                    .font(.system(size: 17, weight: .medium))
                                                    .multilineTextAlignment(.leading)
                                                    .foregroundStyle(Color("linkColor"))
                                            }
                                            
                                            HStack() {
                                                HStack() {
                                                    Image(systemName: "calendar")
                                                        .font(.system(size: 14))
                                                        .fontWeight(.medium)
                                                        .frame(width: 10)
                                                        .foregroundStyle(Color("linkColor").opacity(0.5))
                                                    
                                                    Text("\(dateFormatterDate.string(from: savedCode.timestamp))")
                                                        .font(.system(size: 13, weight: .bold))
                                                        .foregroundStyle(Color("linkColor").opacity(0.5))
                                                }
                                                .padding(.horizontal, 2)
                                                
                                                HStack() {
                                                    Image(systemName: "clock")
                                                        .font(.system(size: 14))
                                                        .fontWeight(.medium)
                                                        .frame(width: 10)
                                                        .foregroundStyle(Color("linkColor").opacity(0.5))
                                                    Text("\(dateFormatterTime.string(from: savedCode.timestamp))")
                                                        .foregroundStyle(Color("linkColor").opacity(0.5))
                                                        .font(.system(size: 13, weight: .bold))
                                                }
                                                  //  .padding(5)
                                                
                                                Spacer()
                                            }
                                            .offset(y: 5)
                                         //   .padding(.vertical, 2)

                                        }
                                        
                                        .padding(12)
                                        .padding(.bottom, 3)
                                        .padding(.horizontal, 5)
                                        .background(Color("accent"))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                    }
                                }
                                .padding(.trailing, 5)
                                
                                
                                Button(action: {
                                    withAnimation(.linear(duration: 0.2)) {
                                        savedCodeViewModel.deleteSavedCode(savedCode)
                                    }
                                    
                                }) {
                                    HStack() {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .fontWeight(.bold)
                                            .frame(width: 20, height: 20)
                                    }
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(Color.primary))
                                    .padding(5)
                                }
                            }
                            .padding(.vertical, 10)
                                
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.top, 20)
                    .background(Color("backGray"))
                    .padding(.bottom, 80)
                }
                Spacer()
            }
            
            VStack() {
                Spacer()
                HStack() {
                    Spacer()
                    Button(action: {
                        withAnimation(.linear(duration: 0.2)) {
                            isPresentingSavedCodes.toggle()
                        }
                    }) {
                        HStack() {
                            Text("close")
                                .lineLimit(1)
                                .font(.system(size: 16, weight: .bold))
                        }
                        .font(.system(size: 16))
                        .foregroundColor(Color("inverted"))
                        .padding(16)
                        .background(Color.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }.padding(20)
            }
            
        }.padding(.horizontal)
    }
}

