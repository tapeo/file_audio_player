import Flutter
import UIKit
import AVFoundation

public class SwiftFileaudioplayerPlugin: NSObject, FlutterPlugin, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer?
    private var flutterResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "fileaudioplayer", binaryMessenger: registrar.messenger())
        let instance = SwiftFileaudioplayerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterResult = result
        
        let action = call.method
        
        if (action == "start") {
            let url : String = call.arguments as! String
            start(filePath : url)
        } else if (action == "stop") {
            stop()
        } else if (action == "pause") {
            pause()
        } else {
            resume()
        }
    }
    
    private func start(filePath: String){
        let url = URL(string: filePath)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            try audioPlayer = AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.wav.rawValue)
            
            audioPlayer!.delegate = self
            
            audioPlayer!.play()
        } catch {
            print("start error: \(error)")
            self.flutterResult!(false)
        }
        
    }
    
    private func stop(){
        audioPlayer?.stop()
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            self.flutterResult!(true)
        } catch {
            print("AVAudioSession stop error: \(error)")
            self.flutterResult!(false)
        }
        
    }
    
    private func pause(){
        audioPlayer?.pause()
        
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            self.flutterResult!(true)
        } catch {
            print("AVAudioSession pause error: \(error)")
            self.flutterResult!(false)
        }
        
    }
    
    private func resume(){
        audioPlayer?.play()
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            self.flutterResult!(true)
        } catch {
            print("AVAudioSession resume error: \(error)")
            self.flutterResult!(false)
        }
        
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            self.flutterResult!(true)
        } catch {
            print("AVAudioSession audioPlayerDidFinishPlaying error: \(error)")
            self.flutterResult!(false)
        }
    }
}
