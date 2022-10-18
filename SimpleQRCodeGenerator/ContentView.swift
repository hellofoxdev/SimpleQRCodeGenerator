//
//  ContentView.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 05.10.22.
//

import SwiftUI
import UIKit
import MessageUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    let version: String = "1.0.1"
    
    let titleText: String = "QR Code Generator"
    let instructionsTitle: String = "Was musst du machen, um deinen QR Code zu erhalten?"
    let instructionsText: String = "1. Schreibe den Text, den du im QR Code codiert haben möchtest, in das Textfeld oben. Der QR Code ändert sich direkt während der Eingabe.\n\n2. Mit dem Button 'In Fotos speichern' passiert gebau das was drauf steht, der QR Code wird so wie er ist, als Bild, in der 'Fotos' App abgelegt, von dort aus kannst du ihn per Mail, iMessage, WhatsApp oder was auch immer verschicken."
    let yourDataTitle: String = "Deine Daten sind mir egal ..."
    let yourDataText: String = "... und deswegen speichert die App absolut keine persönlichen Daten, weder in der App, noch auf irgendeinem Server. Lediglich ein Foto von dem QR Code wird in der 'Fotos' App abgelegt, wenn es gewollt ist (ein Screenshot geht natürlich auch)."
    let contactText: String = "Bei Fragen und Anregungen, schickt mir ne E-Mail"
    let saveToPhotosText: String = "In Fotos speichern"
    let savedText: String = "Der QR Code wurde in Fotos gespeichert"
    
    @State private var placeholderText = "Was soll codiert werden?"
    @State private var textToEncode = ""
    @State private var showingAlert = false
    @FocusState private var focusedField: Field?
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    private enum Field: Int, Hashable
    {
        case textToEncode
    }
    
    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
    
    var qrview: some View {
        VStack() {
            Spacer()
            Image(uiImage: UIImage(data: getQRCodeDate(text: textToEncode)!)!)
                .resizable()
                .padding()
                .frame(width: 200, height: 200)
            Spacer()
        }
        .frame(width: 230, height: 230)
    }
    
    func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showingAlert = true
    }
    
    var body: some View {
        
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                Spacer()
                
                ZStack {
                    if self.textToEncode.isEmpty {
                        TextEditor(text:$placeholderText)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .disabled(true)
                            .padding(10)
                            .frame(height: 155)
                            .scrollContentBackground(.hidden)
                            .background(.clear)
                            .cornerRadius(15)
                            .animation(.easeInOut, value: textToEncode)
                    }
                    TextEditor(text: $textToEncode)
                        .font(.system(size: 16))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .opacity(self.textToEncode.isEmpty ? 0.25 : 1)
                        .padding(10)
                        .frame(height: 155)
                        .scrollContentBackground(.hidden)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(15)
                        .animation(.easeInOut, value: textToEncode)
                        .focused ($focusedField, equals: .textToEncode)
                }
                .navigationTitle(titleText)
                .padding(.horizontal)
                
                qrview
                
                Button(action: {
                    let image = qrview.snapshot()
                    self.save(image: image)
                    
                }) {
                    HStack() {
                        Image(systemName: "camera.aperture")
                            .font(.system(size: 19, weight: .medium))
                            .frame(width: 13, height: 19)
                        Text(saveToPhotosText)
                            .lineLimit(1)
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("babyblue"))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
                Divider()
                    .padding(.top)
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    Text(instructionsTitle)
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .underline()
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Text(instructionsText)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text(yourDataTitle)
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .underline()
                        .foregroundColor(.gray)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text(yourDataText)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Divider()
                        .padding(.bottom)
                        .padding(.horizontal)
                    
                    Button(action: {
                        self.isShowingMailView.toggle()
                    }) {
                        HStack() {
                            Spacer()
                            
                            Text(contactText)
                                .font(.system(size: 13))
                                .fontWeight(.bold)
                                .underline()
                                .foreground(dynamicColorGradientTLBT(colors: [.blue, .purple]))
                            Spacer()
                        }
                    }
                    .disabled(!MFMailComposeViewController.canSendMail())
                    .sheet(isPresented: $isShowingMailView) {
                        MailView(result: self.$result)
                    }
                
                    HStack() {
                        Spacer()
                        Text("Sebastian Fox")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.top)
                        Spacer()
                    }
                    
                    HStack() {
                        Spacer()
                        Text("Version \(version) - 2022")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.bottom)
                        Spacer()
                    }
                    
                    
                }
                
            }.alert(savedText, isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear(){
                textToEncode = ""
            }
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    let contactEmail: String = "apps@roxox.de"
    let contactSubject: String = "QR Code Generator Support"
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject(contactSubject)
        vc.setToRecipients([contactEmail])
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}

func dynamicColorGradient(colors: [Color]) -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(
            colors: colors),
        startPoint: .top,
        endPoint: .bottom)
}

func dynamicColorGradientTLBT(colors: [Color]) -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(
            colors: colors),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
}

// MARK: - API
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    public func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
        self.overlay(overlay).mask(self)
    }
}
