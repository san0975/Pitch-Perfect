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

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        
        /* hide the stop, pause and resume buttons */
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        
        /* Enable the record button */
        recordButton.enabled = true
        
        /* Set the recordingInProgress lable text  to "Tap to Record"*/
        recordingInProgress.text = "Tap to Record"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {

        /* Disable the record button */
        recordButton.enabled = false
        
        /* Show the stop, pause and resume buttons*/
        stopButton.hidden = false
        resumeButton.hidden = false
        pauseButton.hidden = false
        
        /* Set the recordingInProgress lable text  to "recording in progress..."*/
        recordingInProgress.text = "recording in progress..."

        
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
        
        // Fix added for low volume on device. ( Setting to playback fixes the issue ).
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        if(flag){
 
            /* Save the recoded audio */
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            /* Move to next screen ( perform segue ) */
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            recordButton.enabled = true
            stopButton.hidden = true
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
    
    
    @IBAction func pauseRecording(sender: UIButton) {
      
        /* Set the recordingInProgress lable text  to "recording paused..."*/
        recordingInProgress.text = "recording paused..."
        
        audioRecorder.pause()
    }
    
    
    @IBAction func resumeRecording(sender: UIButton) {
        
        /* Set the recordingInProgress lable text  to "recording in progress..."*/
        recordingInProgress.text = "recording in progress..."
        
        audioRecorder.record()
    }
    
    
    @IBAction func recordingStop(sender: UIButton) {

        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

