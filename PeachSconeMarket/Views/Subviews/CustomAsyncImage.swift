//
//  CustomAsyncImage.swift
//  PeachSconeMarket
//
//  Created by Matt Groholski on 10/25/23.
//
//  Reference: https://github.com/lorenzofiamingo/swiftui-cached-async-image/blob/main/Sources/CachedAsyncImage/CachedAsyncImage.swift
//  Reference: https://gist.github.com/giulio92/69e4f74217422154bb25d2a35d6710f8

import Foundation
import SwiftUI

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CustomAsyncImage<Content>: View where Content: View {
    //Phase of load
    @State private var phase: AsyncImagePhase
    //Url Request
    private let urlRequest: URLRequest?
    //Url Session to Request On
    private let urlSession: URLSession
    //Scale of image when displayed
    private let scale: CGFloat
    //Transaction to use when the phase changes
    private let transaction: Transaction
    //Function to display the content
    private let content: (AsyncImagePhase) -> Content
    
    //Width to Height Ratio
    private let RATIO = 0.6233682831
    private let avgCount = 6
    
    public var body: some View {
        content(phase)
            .task(id: urlRequest, load)
    }

    public init(url: URL?,  scale: CGFloat = 1) where Content == Image {
        let urlRequest = url == nil ? nil : URLRequest(url: url!)
        self.init(urlRequest: urlRequest, scale: scale)
    }
    
    public init(urlRequest: URLRequest?, scale: CGFloat = 1) where Content == Image {
        self.init(urlRequest: urlRequest, scale: scale) { phase in
            #if os(macOS)
                    phase.image ?? Image(nsImage: .init())
            #else
                    phase.image ?? Image(uiImage: .init())
            #endif
        }
    }
    
    public init<I, P>(url: URL?, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P>, I : View, P : View {
        let urlRequest = url == nil ? nil : URLRequest(url: url!)
        self.init(urlRequest: urlRequest, scale: scale, content: content, placeholder: placeholder)
    }
    
    public init<I, P>(urlRequest: URLRequest?, scale: CGFloat = 1, @ViewBuilder content: @escaping (Image) -> I, @ViewBuilder placeholder: @escaping () -> P) where Content == _ConditionalContent<I, P>, I : View, P : View {
        self.init(urlRequest: urlRequest, scale: scale) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }
    
    public init(url: URL?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        let urlRequest = url == nil ? nil : URLRequest(url: url!)
        self.init(urlRequest: urlRequest, scale: scale, transaction: transaction, content: content)
    }

    public init(urlRequest: URLRequest?, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        let configuration = URLSessionConfiguration.default
        self.urlRequest = urlRequest
        self.urlSession =  URLSession(configuration: configuration)
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self._phase = State(wrappedValue: .empty)
    }
    
    @Sendable
    private func load() async {
        do {
            if let urlRequest = urlRequest {
                //Second Value is metrics
                let (image, _) = try await remoteImage(from: urlRequest, session: urlSession)
                withAnimation(transaction.animation) {
                    phase = .success(image)
                }
            } else {
                withAnimation(transaction.animation) {
                    phase = .empty
                }
            }
        } catch {
            withAnimation(transaction.animation) {
                phase = .failure(error)
            }
        }
    }
}

// MARK: - LoadingError

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension AsyncImage {
    struct LoadingError: Error {}
}

// MARK: - Helpers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension CustomAsyncImage {
    private func remoteImage(from request: URLRequest, session: URLSession) async throws -> (Image, URLSessionTaskMetrics) {
        let (data, _, metrics) = try await session.data(for: request)
        return (try image(from: data), metrics)
    }
    
    private func image(from data: Data) throws -> Image {
        #if os(macOS)
                if let nsImage = NSImage(data: data) {
                    return Image(nsImage: nsImage)
                } else {
                    throw AsyncImage<Content>.LoadingError()
                }
        #else
                if let uiImage = UIImage(data: data, scale: scale) {
                    return Image(uiImage: processImage(from: uiImage))
                } else {
                    throw AsyncImage<Content>.LoadingError()
                }
        #endif
    }
    
    //Checks vertical border for same color
    private func checkImageVerticalBorder(_ data: UnsafeMutableRawPointer?, topLeftColor: UIColor, xValue: Int, width: Int, height: Int, bytesPerPixel: Int)->Bool {
        for i in 0..<height {
            if topLeftColor != getPixelColor(data, x: xValue, y: i, width: width, bytesPerPixel: bytesPerPixel) {
                return false
            }
        }
        
        return true
    }
    
    //Checks horizontal border for same color
    private func checkImageHorizontalBorder(_ data: UnsafeMutableRawPointer?, topLeftColor: UIColor, yValue: Int, width: Int, bytesPerPixel: Int)->Bool {
        for i in 0..<width {
            if topLeftColor != getPixelColor(data, x: i, y: yValue, width: width, bytesPerPixel: bytesPerPixel) {
                return false
            }
        }
        
        return true
    }
    
    //Gets pixel color from (x,y) coorindate in array.
    //NOTE: Does not deallocate data memory
    private func getPixelColor(_ data: UnsafeMutableRawPointer?, x: Int, y: Int, width: Int, bytesPerPixel: Int) -> UIColor {
        if let data = data {
            let byteIndex = (x + y * width) * bytesPerPixel
            
            let red = CGFloat((data + byteIndex + 1).load(as: UInt8.self)) / 255.0
            let green = CGFloat((data + byteIndex + 2).load(as: UInt8.self)) / 255.0
            let blue = CGFloat((data + byteIndex + 3).load(as: UInt8.self)) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        
        return UIColor()
    }
    
    private func addBorders(_ image: CGImage, borderColor: UIColor) -> CGImage {
        let idealHeight = Int(ceil(Double(image.width) * (1.0 / self.RATIO)))
        let borderHeight = Int((Int(idealHeight) - image.height) / 2)
        
        guard let colorSpace = image.colorSpace else {
            return image
        }
        
        let context = CGContext(
            data: nil, 
            width: image.width,
            height: idealHeight,
            bitsPerComponent: image.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: image.bitmapInfo.rawValue
        )
        
        guard let context = context else {
            return image
        }
        
        let rectForOriginalImage = CGRect(x: 0, y: borderHeight, width: image.width, height: image.height)
        context.draw(image, in: rectForOriginalImage)
        
        let topBorderRect = CGRect(x: 0, y: 0, width: image.width, height: borderHeight)
        context.setFillColor(borderColor.cgColor)
        context.fill(topBorderRect)
        
        let bottomBorderRect = CGRect(x: 0, y: image.height + borderHeight, width: image.width, height: borderHeight)
        context.setFillColor(borderColor.cgColor)
        context.fill(bottomBorderRect)
        
        return context.makeImage()!
    }
    
    private func getTopLeftAverage(_ data: UnsafeMutableRawPointer?, width: Int, bytesPerPixel: Int) -> UIColor {
        var totalRed: CGFloat = 0
        var totalGreen: CGFloat = 0
        var totalBlue: CGFloat = 0
        
        if self.avgCount <= width {
            for i in 0..<self.avgCount {
                for j in 0..<self.avgCount {
                    var red: CGFloat = 0
                    var green: CGFloat = 0
                    var blue: CGFloat = 0
                    var alpha: CGFloat = 0
                    
                    let pixelColor = getPixelColor(data, x: i, y: j, width: width, bytesPerPixel: bytesPerPixel)
                    pixelColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                    
                    totalRed += red
                    totalGreen += green
                    totalBlue += blue
                }
            }
        } else {
            //Returns top left
            return getPixelColor(data, x: 0, y: 0, width: width, bytesPerPixel: bytesPerPixel)
        }
        
        //Averages total
        let count: CGFloat = pow(CGFloat(self.avgCount), CGFloat(2))
        return UIColor(red: (totalRed / count), green: (totalGreen / count), blue: (totalBlue / count), alpha: 1.0)
    }
    
    private func processImage(from uiImage: UIImage) -> UIImage {
        guard let cgImage = uiImage.cgImage else {
            return uiImage
        }
        
        let imageWidth = cgImage.width
        let imageHeight = cgImage.height
        let imageRect = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        let bitmapBytesForRow = Int(imageWidth * 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapMemory = UnsafeMutablePointer<UInt8>.allocate(capacity: bitmapBytesForRow * imageHeight)
        let bitmapInformation = CGImageAlphaInfo.premultipliedFirst.rawValue
        let bytesPerPixel = 4
        
        let colorContext = CGContext(
            data: bitmapMemory,
            width: imageWidth,
            height: imageHeight,
            bitsPerComponent: 8,
            bytesPerRow: bitmapBytesForRow,
            space: colorSpace,
            bitmapInfo: bitmapInformation
        )
        
        guard let context = colorContext else {
            bitmapMemory.deallocate()
            return UIImage(cgImage: cgImage)
        }
        
        context.clear(imageRect)
        context.draw(cgImage, in: imageRect)
        
        //Averages top left corner
        let topLeft = getPixelColor(context.data, x: 0, y: 0, width: cgImage.width, bytesPerPixel: bytesPerPixel)
        var sameColor: Bool = true
        

        //Top Row
        sameColor = checkImageHorizontalBorder(context.data, topLeftColor: topLeft, yValue: 0, width: imageWidth, bytesPerPixel: bytesPerPixel)
        //Left Column
        sameColor = checkImageVerticalBorder(context.data, topLeftColor: topLeft, xValue: 0, width: imageWidth, height: imageHeight, bytesPerPixel: bytesPerPixel)
        //Right Column
        sameColor = checkImageVerticalBorder(context.data, topLeftColor: topLeft, xValue: imageWidth - 1, width: imageWidth, height: imageHeight, bytesPerPixel: bytesPerPixel)

        var returnImage: CGImage = cgImage
        
        if sameColor {
            let topLeftAverage = getTopLeftAverage(context.data, width: imageWidth, bytesPerPixel: bytesPerPixel)
            returnImage = addBorders(cgImage, borderColor: topLeftAverage)
        }
        
        bitmapMemory.deallocate()
        return UIImage(cgImage: returnImage)
    }
}

// MARK: - AsyncImageURLSession

private class URLSessionTaskController: NSObject, URLSessionTaskDelegate {
    var metrics: URLSessionTaskMetrics?
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        self.metrics = metrics
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension URLSession {
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse, URLSessionTaskMetrics) {
        let controller = URLSessionTaskController()
        let (data, response) = try await data(for: request, delegate: controller)
        return (data, response, controller.metrics!)
    }
}
