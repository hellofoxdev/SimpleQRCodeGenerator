//
//  InformationView.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 04.01.25.
//

import SwiftUI

struct InformationView: View {
    
    @Binding var isPresentingInformationView: Bool
    
    var body: some View {
        ZStack() {
            VStack() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack() {
                        
                        HStack() {
                            Text("information")
                                .font(.system(size: 32, weight: .heavy))
                                .padding(.bottom)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.top, 20)
                        .padding(.horizontal)
                        
                        VStack() {
                            HStack() {
                                Text("instructionsTitle")
                                    .font(.system(size: 22, weight: .heavy))
                                    .padding(.bottom)
                                Spacer()
                            }
                            
                            HStack() {
                                VStack() {
                                    Text("1.")
                                        .font(.system(size: 17, weight: .medium))
                                        .frame(width: 15)
                                    Spacer()
                                }
                                Text("instructionsText1")
                                    .font(.system(size: 17, weight: .medium))
                                Spacer()
                            }
                            .padding(.bottom)
                            
                            HStack() {
                                VStack() {
                                    Text("2.")
                                        .font(.system(size: 17, weight: .medium))
                                        .frame(width: 15)
                                    Spacer()
                                }
                                Text("instructionsText2")
                                    .font(.system(size: 17, weight: .medium))
                                Spacer()
                            }
                        }
                        
                        
                        .padding(20)
                        .background(Color("accent"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    /*
                    .padding(20)
                    .padding(.top, 20)
                    .background(Color("backGray"))
                     */
                    
                        VStack() {
                            HStack() {
                                Text("instructionsSavedCodesTitle")
                                    .font(.system(size: 22, weight: .heavy))
                                    .padding(.bottom)
                                Spacer()
                            }
                            
                            HStack() {
                                Text("instructionsText3")
                                    .font(.system(size: 17, weight: .medium))
                                Spacer()
                            }
                        }
                    
                    .padding(20)
                    .background(Color("accent"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    /*
                        .padding(20)
                        .background(Color("backGray"))
                     */
                    
                    VStack() {
                        HStack() {
                            Text("yourDataTitle")
                                .font(.system(size: 22, weight: .heavy))
                                .padding(.bottom)
                            Spacer()
                        }
                        
                        HStack() {
                            Text("yourDataText1")
                                .font(.system(size: 17, weight: .medium))
                                .padding(.bottom)
                            Spacer()
                        }
                        
                        HStack() {
                            Text("yourDataText2")
                                .font(.system(size: 17, weight: .medium))
                            Spacer()
                        }
                    }
                    
                    .padding(20)
                    .background(Color("accent"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .padding(.top, 20)
                    /*
                    .padding(20)
                    .background(Color("backGray"))
                     */
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
                            isPresentingInformationView.toggle()
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
            
        }
    }
}
