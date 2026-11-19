//
//  ContentView.swift
//  SimpleQRCodeGenerator
//
//  Created by Sebastian Fox on 05.10.22.
//

import SwiftData
import SwiftUI
import UIKit
import Combine
import MessageUI
import CoreImage.CIFilterBuiltins

struct ContentView: View, KeyboardReadable {
    
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var savedCodeViewModel: SavedCodeViewModel
    
    //var barcodeGenerator = BarcodeGenerator()
    
    @Query private var savedCodes: [SavedCode]
    
    let year: String = "2025"
    let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
    let placeholder: String = "placeholder"
    
    @State private var placeholderText = "placeholder"
    @State private var textToEncode = "hallo"
    @State private var savable = true
    @State private var passphrase = ""
    @State private var endpoint = ""
    @State private var showingAlert = false
    @FocusState private var focusedField: Field?
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isPresentingMailView = false
    @State var isPresentingInstructionsView = false
    @State var isPresentingInformationView = false
    @State var isPresentingSavedCodes = false
    @State private var isKeyboardVisible = false
    @AppStorage("format") var format: String = "qr"
    @AppStorage("version_2_0_0") var version_2_0_0: Bool = false
    @State var isPresentingInitialStartView = false
    
    let formats = ["qr", "aztec", "code128barcode"]
    
    private enum Field: Int, Hashable
    {
        case textToEncode
    }
    
    /* TODO: Check if alternative approach can capsuled into extra QR Generator class/struct
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
     */
    
    func getQRCodeDate(text: String) -> Data? {
        var text2 = text.replacingOccurrences(of: "ß", with: "ss", options: .literal, range: nil)
        text2 = text2.replacingOccurrences(of: "ä", with: "ae", options: .literal, range: nil)
        text2 = text2.replacingOccurrences(of: "Ä", with: "Ae", options: .literal, range: nil)
        text2 = text2.replacingOccurrences(of: "ö", with: "oe", options: .literal, range: nil)
        text2 = text2.replacingOccurrences(of: "Ö", with: "Oe", options: .literal, range: nil)
        text2 = text2.replacingOccurrences(of: "ü", with: "ue", options: .literal, range: nil)
        text2 = text2.replacingOccurrences(of: "Ü", with: "Ue", options: .literal, range: nil)
        
        switch format {
        case "qr":
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(text2.utf8)
            guard let ciimage = filter.outputImage else { return nil }
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledCIImage = ciimage.transformed(by: transform)
            let uiimage = UIImage(ciImage: scaledCIImage)
            return uiimage.pngData()!
        case "aztec":
            let filter = CIFilter.aztecCodeGenerator()
            filter.message = Data(text2.utf8)
            guard let ciimage = filter.outputImage else { return nil }
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledCIImage = ciimage.transformed(by: transform)
            let uiimage = UIImage(ciImage: scaledCIImage)
            return uiimage.pngData()!
        case "code128barcode":
            let filter = CIFilter.code128BarcodeGenerator()
            filter.message = Data(text2.utf8)
            guard let ciimage = filter.outputImage else { return nil }
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledCIImage = ciimage.transformed(by: transform)
            let uiimage = UIImage(ciImage: scaledCIImage)
            return uiimage.pngData()!
        default:
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(text2.utf8)
            guard let ciimage = filter.outputImage else { return nil }
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let scaledCIImage = ciimage.transformed(by: transform)
            let uiimage = UIImage(ciImage: scaledCIImage)
            return uiimage.pngData()!
        }
    }
    
    func getValue(_ string: String) -> String {
        return ""
    }
    
    var qrview: some View {
        VStack() {
            Spacer()
            if getQRCodeDate(text: textToEncode) != nil {
                Image(uiImage: UIImage(data: getQRCodeDate(text: textToEncode)!)!)
                    .resizable()
                    .frame(width: 150, height: 150)
            } else {
                Image(systemName: "qrcode")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .opacity(0.1)
            }
                
            Spacer()
        }
        .frame(width: 170, height: 170)
    }
    
    
    var qrviewForSave: some View {
        VStack() {
            Spacer()
        
            if getQRCodeDate(text: textToEncode) != nil {
                Image(uiImage: UIImage(data: getQRCodeDate(text: textToEncode)!)!)
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "qrcode")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .opacity(0.1)
            }
                
            Spacer()
        }
        .frame(width: 300, height: 300)
    }
    
    func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showingAlert = true
    }
    
    var body: some View {
            NavigationView {
                    ScrollView(showsIndicators: false) {
                        Spacer()
                        ZStack(alignment: .topLeading) {
                            if self.textToEncode.isEmpty {
                                VStack(alignment: .leading) {
                                    HStack() {
                                        Text("placeholder")
                                            .font(.system(size: 16, weight: .bold))
                                            .padding(.vertical, 3)
                                            .opacity(0.4)
                                            .disabled(true)
                                            .padding(10)
                                            .scrollContentBackground(.hidden)
                                            .background(.clear)
                                            .cornerRadius(20)
                                            .animation(.easeInOut, value: textToEncode)
                                            .padding(.top, 8)
                                            .padding(.horizontal, 5)
                                    }
                                }
                            }
                            TextEditor(text: $textToEncode)
                                .font(.system(size: 16, weight: .bold))
                                .padding(.vertical, 3)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .opacity(self.textToEncode.isEmpty ? 0.25 : 1)
                                .padding(10)
                                .frame(height: 155)
                                .scrollContentBackground(.hidden)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(20)
                                .focused ($focusedField, equals: .textToEncode)
                                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                    isKeyboardVisible = newIsKeyboardVisible
                                }
                            
                        }
                        .padding(.top, 30)
                        .navigationBarItems(leading: Text("title")
                            .font(.system(size: 32, weight: .heavy)))
                        .padding(.horizontal)
                        
                        HStack() {
                            
                                /*Text("Format:")
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundColor(Color("linkColor"))*/
                                HStack() {
                                    Text("QR")
                                        .lineLimit(1)
                                        .font(.system(size: 14, weight: .heavy))
                                }
                                .font(.system(size: 16))
                                .foregroundColor(textToEncode == "" ? Color("inverted") : Color(Color("inverted")))
                                .padding(10)
                                .background(textToEncode == "" ? Color(Color.primary) : Color(Color.primary))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            HStack() {
                                Text("Aztec")
                                    .lineLimit(1)
                                    .font(.system(size: 14, weight: .heavy))
                            }
                            .font(.system(size: 16))
                            .foregroundColor(textToEncode == "" ? Color("inactiveLinkColor") : Color(Color("inactiveLinkColor")))
                            .padding(10)
                            .background(textToEncode == "" ? Color("buttonInactive") : Color("buttonInactive"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            HStack() {
                                Text("Code 128")
                                    .lineLimit(1)
                                    .font(.system(size: 14, weight: .heavy))
                            }
                            .font(.system(size: 16))
                            .foregroundColor(textToEncode == "" ? Color("inactiveLinkColor") : Color(Color("inactiveLinkColor")))
                            .padding(10)
                            .background(textToEncode == "" ? Color("buttonInactive") : Color("buttonInactive"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                                Spacer()
                        }
                        .padding(.horizontal)
                        
                        
                        HStack(alignment: .top) {
                            VStack() {
                                HStack() {
                                    Spacer()
                                    Text("yourCode")
                                        .font(.system(size: 26, weight: .heavy))
                                        .foreground(Color("linkColor"))
                                        .padding(.top, 20)
                                        .padding(.leading)
                                    Spacer()
                                }
                                Image(systemName: "arrow.turn.down.right")
                                    .resizable()
                                    .fontWeight(.bold)
                                    .frame(width: 30, height: 30)
                                    .offset(x: 60)
                                
                                Spacer()
                            }
                            HStack() {
                                Spacer()
                                
                                qrview
                                    .opacity(textToEncode == "" ? 0.1 : 1)
                                
                                Spacer()
                            }
                        }
                        .padding(.vertical)
                        
                        HStack() {
                            /* TODO: This can be used for the future feature "FORAMT"
                            VStack() {
                                HStack() {
                                    Text("Format:")
                                        .font(.system(size: 16, weight: .heavy))
                                        .foregroundColor(Color("linkColor"))
                                    Picker("Scanner Auswahl", selection: $format) {
                                        ForEach(formats, id: \.self) {
                                            switch $0 {
                                            case "qr":
                                                Text("QR-Code")
                                            case "aztec":
                                                Text("Aztec-Code")
                                            case "code128barcode":
                                                Text("Code128 Barcode")
                                            default:
                                                Text("QR")
                                            }
                                        }
                                    }.pickerStyle(.menu)
                                    //.padding(16)
                                        .background(Color("buttonInactive"))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .tint(Color("linkColor"))            // <-- Set the base color to .white
                                    // .colorMultiply(.black)
                                    Spacer()
                                }
                            } */
                             
                            Spacer()
                            
                            
                            
                            Button(action: {
                                savedCodeViewModel.addNewSavedCode(NSDate() as Date, textToEncode, format)
                                let image = qrviewForSave.snapshot()
                                self.save(image: image)
                                
                            }) {
                                HStack() {
                                    Text("photo")
                                        .lineLimit(1)
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .font(.system(size: 16))
                                .foregroundColor(textToEncode == "" ? Color("inactiveLinkColor") : Color(Color("inverted")))
                                .padding(16)
                                .background(textToEncode == "" ? Color("buttonInactive") : Color(Color.primary))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .disabled(textToEncode == "")
                            
                            Button(action: {
                                textToEncode = ""
                                
                            }) {
                                HStack() {
                                    Image(systemName: "trash")
                                        .resizable()
                                        .fontWeight(.bold)
                                        .frame(width: 20, height: 20)
                                }
                                .font(.system(size: 16))
                                .foregroundColor(textToEncode == "" ? Color("inactiveLinkColor") : Color(Color("inverted")))
                                .padding(16)
                                .background(textToEncode == "" ? Color("buttonInactive") : Color(Color.primary))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .disabled(textToEncode == "")
                        }
                        .padding(.horizontal)
                    
                    Spacer()
                    VStack(alignment: .leading) {
                        
                        /* Saved QR Codes */
                        HStack() {
                            Button(action: {
                                withAnimation(.linear(duration: 0.2)) {
                                    self.endEditing()
                                    self.isPresentingSavedCodes.toggle()
                                }
                            }) {
                                Text("savedCodes")
                                    .font(.system(size: 22, weight: .heavy))
                                    .foreground(Color("linkColor"))
                            }
                            .sheet(isPresented: $isPresentingSavedCodes) {
                                SavedCodesView(isPresentingSavedCodes: $isPresentingSavedCodes,
                                               currentTextToEncode: $textToEncode,
                                               currentFormat: $format)
                                .presentationDetents([.large])
                                .background(Color("backGray"))
                            }
                       //     .ignoresSafeArea(.keyboard, edges: .bottom)
                            .padding(.vertical, 3)
                            Spacer()
                        }
                        
                        /* Data Information */
                        Button(action: {
                            withAnimation(.linear(duration: 0.2)) {
                                self.endEditing()
                                self.isPresentingInformationView.toggle()
                            }
                        }) {
                            Text("information")
                                .font(.system(size: 22, weight: .heavy))
                                .foreground(Color("linkColor"))
                        }
                        
                        /*
                        .fullScreenCover(isPresented: $isPresentingInformationView) {
                            InformationView(isPresentingInformationView: $isPresentingInformationView)
                                .background(Color("backGray"))
                                .padding(.top, 5)
                        }
                        .padding(.vertical, 3)
                        */
                        
                        .sheet(isPresented: $isPresentingInformationView) {
                            InformationView(isPresentingInformationView: $isPresentingInformationView)
                                .presentationDetents([.large])
                                .background(Color("backGray"))
                        }
                        .padding(.vertical, 3)
                         
                        
                        Button(action: {
                            withAnimation(.linear(duration: 0.2)) {
                                self.endEditing()
                                self.isPresentingMailView.toggle()
                            }
                        }) {
                            Text("contact")
                                .font(.system(size: 22, weight: .heavy))
                                .foreground(Color("linkColor"))
                        }
                        .disabled(!MFMailComposeViewController.canSendMail())
                        .sheet(isPresented: $isPresentingMailView) {
                            MailView(result: self.$result)
                        }
                        .padding(.vertical, 3)
                        
                        /* Publisher Information */
                        HStack() {
                            Spacer()
                            Text("publisher")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(Color("linkColor"))
                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(Color("linkColor"))
                                .frame(width: 10, height: 10)
                            Image(systemName: "heart.fill")
                                .resizable()
                                .foregroundColor(Color("myPeach"))
                                .frame(width: 15, height: 15)
                            Spacer()
                        }
                        .padding(.top, 20)
                        
                        HStack() {
                            Spacer()
                            Text("Version \(nsObject as! String) - \(year)")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(Color("linkColor"))
                                .padding(.bottom)
                            Spacer()
                        }
                         
                    }
                    .padding(.horizontal)
                    .padding(.top, 80)
                    }
                    .alert("savedText", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    .onAppear(){
                        textToEncode = ""
                        self.checkInitialSetup()
                    }
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.5)) {
                            self.endEditing()
                        }
                    }
            
            }
        
            .fullScreenCover(isPresented: $isPresentingInitialStartView) {
                InitialStartView(isPresentingInitialStartView: $isPresentingInitialStartView)
            }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    private func sheetOpened() -> Bool {
        return isPresentingInstructionsView || isPresentingSavedCodes || isPresentingInformationView
    }
    

    func checkInitialSetup() {
        isPresentingInitialStartView = false
        if (version_2_0_0 == false) {
            isPresentingInitialStartView = true
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

/// Publisher to read keyboard changes.
protocol KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> { get }
}

extension KeyboardReadable {
    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },
            
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}

extension StringProtocol {
    var strippingDiacritics: String {
        applyingTransform(.stripDiacritics, reverse: false)!
    }
}


/* TODO: wird noch umgebaut zu etwas, das ich brauchen kann
struct BarcodeGenerator {
    
    func convertCGImageToCIImage(inputImage: CGImage) -> CIImage! {
        var ciImage = CIImage(cgImage: inputImage)
        return ciImage
    }
    
    let context = CIContext()
    let generator = CIFilter.aztecCodeGenerator()

    func generateBarcode(text: String) -> Image {
        let generator = CIFilter.aztecCodeGenerator()
        generator.message = Data(text.utf8)

        if let outputImage = generator.outputImage,
           
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            let ciImage = convertCGImageToCIImage(inputImage: cgImage)
            let scaledCIImage = ciImage!.transformed(by: transform)
                
              //  let uiImage = UIImage(cgImage: cgImage)
                let uiImage = UIImage(ciImage: scaledCIImage)
                return Image(uiImage: uiImage)
            

        }

        return Image(systemName: "barcode")

    }
}
 */
