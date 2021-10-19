import UIKit
import ImageIO
import PlaygroundSupport
import Foundation

class ViewController: UIViewController, URLSessionDelegate {
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var textLabel: UILabel!
    var buffer:NSMutableData = NSMutableData()
    var session:URLSession?
    var dataTask:URLSessionDataTask?
    let url = NSURL(string:"https://forum.awd.ru/viewtopic.php?f=1011&t=165935" )!
    var expectedContentLength = 0
    
    override func viewDidLoad() {
            super.viewDidLoad()
            progress.progress = 0.0
        let configuration = URLSessionConfiguration.default
        let manqueue = OperationQueue.main
        session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: manqueue)
        dataTask = session?.dataTask(with: NSURLRequest(url: url as URL) as URLRequest)
        dataTask?.resume()

            // Do any additional setup after loading the view, typically from a nib.
        }
        func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveResponse response: URLResponse, completionHandler: (URLSession) -> Void) {

            //here you can get full lenth of your content
            expectedContentLength = Int(response.expectedContentLength)
            print(expectedContentLength)
        }
        func URLSession(session: URLSession, dataTask: URLSessionDataTask, didReceiveData data: NSData) {


            buffer.append(data as Data)

            let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
            progress.progress =  percentageDownloaded
        }
        func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
            //use buffer here.Download is done
            progress.progress = 1.0   // download 100% complete
        }
    }

// Прогресс скачивания данных jpg

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true

let url = URL(string: "https://forum.awd.ru/viewtopic.php?f=1011&t=165935")!
let task = URLSession.shared.dataTask(with: url) { _, _, _ in
  page.finishExecution()
}

let observation = task.progress.observe(\.fractionCompleted) { progress, _ in
  print(progress.fractionCompleted)
}

task.resume()

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}

//Определяем формат изображения
struct ImageHeaderData{
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}

enum ImageFormat{
    case Unknown, PNG, JPEG, GIF, TIFF
}


extension NSData{
    var imageFormat: ImageFormat{
        var buffer = [UInt8](repeating: 0, count: 1)
        self.getBytes(&buffer, range: NSRange(location: 0,length: 1))
        if buffer == ImageHeaderData.PNG
        {
            return .PNG
        } else if buffer == ImageHeaderData.JPEG
        {
            return .JPEG
        } else if buffer == ImageHeaderData.GIF
        {
            return .GIF
        } else if buffer == ImageHeaderData.TIFF_01 || buffer == ImageHeaderData.TIFF_02{
            return .TIFF
        } else{
            return .Unknown
        }
    }
}

//Вводим ссылку и получаем формат изображения

//func viewDidLoad() {
//
//
//        let myURLString = "https://forum.awd.ru/viewtopic.php?f=1011&t=165935"
//        guard let myURL = URL(string: myURLString) else { return }
//
//        do {
//            let myHTMLString = try String(contentsOf: myURL, encoding: .utf8)
//            let htmlContent = myHTMLString
//            do {
//                let doc = try SwiftSoup.parse(htmlContent)
//                do {
//                    let element = try doc.select("title=Закаты на островах Таиланда").first()
//                    do {
//                        let text = try element?.text()
//                        textLabel.text = text
//                    }
//                } catch {
//
//                } catch {
//
//                }
//            }
//
//        } catch let error {
//            print("Error: \(error)")
//        }
//    }
