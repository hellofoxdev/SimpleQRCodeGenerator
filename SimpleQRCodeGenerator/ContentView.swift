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
    
   // let version: String = "1.3"
    let year: String = "2025"
    let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
    
    @State private var placeholderText = "placeholder"
    @State private var textToEncode = ""
    @State private var showingAlert = false
    @FocusState private var focusedField: Field?
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    private enum Field: Int, Hashable
    {
        case textToEncode
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let QRFilter = CIFilter(name: "CIQRCodeGenerator") {
            QRFilter.setValue(data, forKey: "inputMessage")
            guard let QRImage = QRFilter.outputImage else {return nil}
            
            let transformScale = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let scaledQRImage = QRImage.transformed(by: transformScale)
            
            return UIImage(ciImage: scaledQRImage)
        }
        return nil
    }
    
    func getQRCodeDate(text: String) -> Data? {
        //guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let filter = CIFilter.qrCodeGenerator()
        let data = text.data(using: .utf8, allowLossyConversion: false)
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
                .navigationTitle("title")
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
                        Text("photo")
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
                    Text("instructionsTitle")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .underline()
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    Text("instructionsText")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("yourDataTitle")
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        .underline()
                        .foregroundColor(.gray)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    Text("yourDataText")
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
                            
                            Text("contactText")
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
                        Text("publisher")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.top)
                        Spacer()
                    }
                    
                    HStack() {
                        Spacer()
                        Text("Version \(nsObject as! String) - \(year)")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.bottom)
                        Spacer()
                    }
                    
                    
                }
                
            }.alert("savedText", isPresented: $showingAlert) {
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
    
    let contactEmail: String = "apps@hellofox.dev"
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
