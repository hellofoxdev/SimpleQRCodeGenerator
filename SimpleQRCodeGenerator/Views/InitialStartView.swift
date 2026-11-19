//
//  InitialStartView.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 04.01.25.
//


import SwiftUI

struct InitialStartView: View {
    
    @Binding var isPresentingInitialStartView: Bool
    @AppStorage("version_2_0_0") var version_2_0_0: Bool = false
    
    let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
    
    var body: some View {
        NavigationView() {
            ZStack() {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack() {
                        
                            HStack() {
                                HStack() {
                                    
                                    Text("at")
                                        .font(.system(size: 20, weight: .regular)) +
                                    Text("titleLong")
                                        .font(.system(size: 20, weight: .heavy)) +
                                    Text("introduction")
                                        .font(.system(size: 20, weight: .regular))
                                }
                                .padding(.vertical)
                                Spacer()
                            }
                        
                        VStack() {
                            
                            HStack() {
                                HStack() {
                                    Text("version")
                                    Text("\(nsObject as! String)")
                                }
                                .font(.system(size: 18, weight: .heavy))
                                .padding(8)
                                .padding(.horizontal, 2)
                                .background(Color("accent"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                Spacer()
                            }
                        }
                        
                        HStack() {
                            HStack() {
                                Text("whatsNew")
                                Text("\(nsObject as! String)")
                            }
                            .font(.system(size: 24, weight: .heavy))
                            .padding(.vertical)
                            
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        VStack() {
                            HStack() {
                                HStack() {
                                    Text("update1Title")
                                }
                                    .font(.system(size: 20, weight: .heavy))
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                Text("update1Text")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.bottom)
                                Spacer()
                            }
                        }
                        .padding(12)
                        .padding(.bottom, 3)
                        .padding(.horizontal, 5)
                        .background(Color("accent"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 10)
                        
                        VStack() {
                            HStack() {
                                Text("update2Title")
                                    .font(.system(size: 20, weight: .heavy))
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                Text("update2Text")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.bottom)
                                Spacer()
                            }
                        }
                        
                        .padding(12)
                        .padding(.bottom, 3)
                        .padding(.horizontal, 5)
                        .background(Color("accent"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 10)
                        
                        VStack() {
                            HStack() {
                                Text("update3Title")
                                    .font(.system(size: 20, weight: .heavy))
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                Text("update3Text")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.bottom)
                                Spacer()
                            }
                        }
                        .padding(12)
                        .padding(.bottom, 3)
                        .padding(.horizontal, 5)
                        .background(Color("accent"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 10)
                        
                        
                        HStack() {
                            HStack() {
                                Text("whatsOld")
                            }
                            .font(.system(size: 24, weight: .heavy))
                            .padding(.vertical)
                            
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        
                        VStack() {
                            HStack() {
                                Text("stillNoData")
                                    .font(.system(size: 20, weight: .heavy))
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                Text("noDataText")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.bottom, 5)
                                Spacer()
                            }
                            
                            HStack() {
                                Text("noDataText2")
                                    .font(.system(size: 18, weight: .heavy))
                                    .padding(.bottom)
                                Spacer()
                            }
                        }
                        .padding(12)
                        .padding(.bottom, 3)
                        .padding(.horizontal, 5)
                        .background(Color("accent"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 10)
                        
                        VStack() {
                            HStack() {
                                Text("stillFree")
                                    .font(.system(size: 20, weight: .heavy))
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                            
                            HStack() {
                                Text("freeText")
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.bottom)
                                Spacer()
                            }
                        }
                        .padding(12)
                        .padding(.bottom, 3)
                        .padding(.horizontal, 5)
                        .background(Color("accent"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 80)
                    .padding(.top, 30)
                }
                VStack() {
                    Spacer()
                    HStack() {
                        Spacer()
                        Button(action: {
                            withAnimation(.linear(duration: 0.2)) {
                                version_2_0_0 = true
                                isPresentingInitialStartView.toggle()
                            }
                        }) {
                            HStack() {
                                Text("letsGo")
                                    .lineLimit(1)
                                    .font(.system(size: 18, weight: .heavy))
                            }
                            .font(.system(size: 18))
                            .foregroundColor(Color("inverted"))
                            .padding(18)
                            .background(Color.primary)
                            //.clipShape(Capsule())
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }.padding(20)
                }
            }
            .navigationBarTitle("welcome", displayMode: .large)
            
            
        }
    }
}


