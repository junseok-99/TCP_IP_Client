//
//  ViewController.swift
//  TCP_IP_Client
//
//  Created by 장준석 on 2023/04/06.
//

import UIKit
import MetalKit
import Metal

class ViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate {
    
    
    var client : TCPClient!
    var queue : [String] = []
    
    struct Files: Codable{
        var cnt : Int
        var data : [PointCloud]
    }
    struct PointCloud: Codable{
        var x : CGFloat
        var y : CGFloat
        var z : CGFloat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        client = .init(host: "192.168.106.46", port: 8002)
        client.start()
    }
        
        
    
        @IBAction func Go(_ sender: UIButton) {
            
            
                    // 딜레이 후 실행할 코드
                    
                    var points : Files = .init(cnt: 0,data: [])
                    var cnt = 0
                    for i in stride(from: 0.00, to: 40.36, by: 0.04){
                        let pt : PointCloud = .init(x: i+0.01, y: i+0.02, z: i+0.03)
                        points.data.append(pt)
                        cnt+=1
                    }
                    points.cnt = cnt
                    do{
                        let start = Date()
                        
                        let jsonEncoder = JSONEncoder()
                        jsonEncoder.outputFormatting = .prettyPrinted
                        
                        let encoded = try jsonEncoder.encode(points)
                        self.queue.append(String(data: encoded, encoding: .utf8)!)
                        print(self.queue[0])
                        self.client.send(message: queue.removeFirst())
                        print("Elapsed time: \(-start.timeIntervalSinceNow) seconds")
                        //self.client.send(message: "End")
                        
                    }
                    catch{
                        print("Error!")
                    }
                    
                
            
            
            
    }
    
    @IBAction func initail_bt(_ sender: UIButton) {
        
        var points : Files = .init(cnt: 0, data: [])
        var cnt = 0
        let fileName = "myJsonFile.json"
        let path = "/Users/jangjunseog/Desktop/LAB/IOS/TCP_IP_Client/\(fileName)"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        
        for i in stride(from: 0.00, to: 9.99, by: 0.04){
            let pt : PointCloud = .init(x: i+0.01, y: i+0.02, z: i+0.03)
            points.data.append(pt)
            cnt+=1
        }
        points.cnt = cnt
        do{
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            
            let encoded = try jsonEncoder.encode(points)
            let encodeStr = String(data: encoded, encoding: .utf8)!
            
            do {
                try encodeStr.write(toFile: path, atomically: true, encoding: .utf8)
            } catch {
                print("Error saving file: \(error)")
            }
        }
        catch{
            print("Error!")
        }
            
        

        
        print(fileURL)
    }
    @IBAction func connect(_ sender: UIButton) {
        client = .init(host: "192.168.106.46", port: 8001)
        client.start()
    }
    
    
}

