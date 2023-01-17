//
//  ViewController.swift
//  RecorderApp
//
//  Created by PAVIT KALRA on 2023-01-16.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioRecorderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords = 0
    var audioPlayer: AVAudioPlayer!
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBOutlet weak var myTableView: UITableView!
    @IBAction func record(_ sender: UIButton) {
      
        
        //CHECK IF WE HAVE AN ACTIVE AUDIO RECORDER
        if(audioRecorder == nil){
            numberOfRecords += 1
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            
            
            //START AUDIO RECORDING
            do
            {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                buttonLabel.setTitle("Stop Recording", for: .normal)
            }
            catch
            {
                
            }
        }
        else{
            audioRecorder.stop()
            audioRecorder = nil
            
            //SAVE NUMBER OF RECORDS
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            
            myTableView.reloadData()
            buttonLabel.setTitle("Start Recording", for: .normal)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        
        
        //SETTING UP SESSION
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission{(hasPermission) in
            if(hasPermission){
                print("Accepted")
            }
        }
        
    }
    
    
    //FUNCTION THAT GETS PATH OF DIRECTORY TO SAVE RECORDINGS
    func getDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return numberOfRecords
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = String(indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = getDirectory().appendingPathComponent("\(indexPath.row + 1).m4a")
        
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.play()
        }
        catch
        {
            
        }
    }

}

