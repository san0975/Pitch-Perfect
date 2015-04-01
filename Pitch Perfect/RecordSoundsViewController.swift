//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Santosh Rawat on 3/5/15.
//  Copyright (c) 2015 Santosh Rawat. All rights reserved.
//

import UIKit
import AVFoundation

/*
    RecordSoundsViewController class allows the user to recorded a sound.
    Record Sounds View is the initial view for the app
*/

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        stopButton.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        tapToRecord.hidden = true

        /* Record the user's voice */
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        /* Setup Audio Session */
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        /* Inititialize and prepare the recorder */
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            /* Save the recoded audio */
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            /* Move to next screen ( perform segue ) */
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            recordButton.enabled = true
            stopButton.hidden = true
            tapToRecord.hidden = false
        }
    }

  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording")
        {
            let palySoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            palySoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func recordingStop(sender: UIButton) {
        recordingInProgress.hidden = true
        tapToRecord.hidden = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

