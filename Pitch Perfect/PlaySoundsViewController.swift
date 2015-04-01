//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Santosh Rawat on 3/22/15.
//  Copyright (c) 2015 Santosh Rawat. All rights reserved.
//

import UIKit
import AVFoundation

/*
    PlaySoundsViewController class allows the user to play the recorded sound back with effect.

    The play sounds view has four buttons to play the recorded
    sound file and a button to stop the playback.

    The buttons for playing the recorded sounds will have images corresponding to their sound effect:

    Chipmunk image → High­pitched sound
    Darth Vader image → Low­pitched sound
    Snail image → Slow sound
    Rabbit image → Fast sound
*/

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopAudioPlayer()
    {
        /* Stop the Audio Player */
        audioPlayer.stop() //Stop the audio player
        
        /* Stop the Audio Engine */
        audioEngine.stop()

        /* Reset all the audio nodes in the Audio Engine */
        audioEngine.reset()
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        
        /* Stop Audio Player and Audio Engine */
        stopAudioPlayer()
        
        /* Set the (slow) rate to 0.5 ( Default rate is 1.0 ) */
        audioPlayer.rate = 0.5

        /* Start the audio from start */
        audioPlayer.currentTime = 0.0
        
        /* Play the audio */
        audioPlayer.play() //
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        
        /* Stop Audio Player and Audio Engine */
        stopAudioPlayer()
        
        /* Set the (fast) rate to 1.5 ( Default rate is 1.0 ) */
        audioPlayer.rate = 1.5
        
        /* Start the audio from start */
        audioPlayer.currentTime = 0.0
        
        /* Play the audio */
        audioPlayer.play() //
    }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    
    func playAudioWithVariablePitch(pitch: Float){
        
        /* Stop Audio Player and Audio Engine */
        stopAudioPlayer()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {

        /* Stop Audio Player and Audio Engine */
        stopAudioPlayer()

    }
    
    
    @IBAction func playReverbAudio(sender: UIButton) {

        /* Stop Audio Player and Audio Engine */
        stopAudioPlayer()

    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        
        /* Stop the audio player */
        audioPlayer.stop()
    }

}
