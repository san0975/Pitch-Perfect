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

    Chipmunk image -> High­pitched sound
    Darth Vader image -> Low­pitched sound
    Snail image -> Slow sound
    Rabbit image -> Fast sound
    Echo image -> Echo sound
    Reverb image -> Play sound with acoustic characteristics
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

    func stopAudioPlayerAndEngine()
    {
        /* Stop the Audio Player */
        audioPlayer.stop() //Stop the audio player
        
        /* Stop the Audio Engine */
        audioEngine.stop()
        
        /* Reset all the audio nodes in the Audio Engine */
        audioEngine.reset()
    }

    func playWithRate(rateX:Float)
    {
        /* Stop the Audio Player */
        stopAudioPlayerAndEngine()
        
        /* Set the audio player rate */
        audioPlayer.rate = rateX
        
        /* Start the audio from start */
        audioPlayer.currentTime = 0.0
        
        /* Play the audio */
        audioPlayer.play() //
        
    }
    
    @IBAction func playSlowSound(sender: UIButton) {
        
        /* Set the (slow) rate to 0.5 ( Default rate is 1.0 ) */
        playWithRate(0.5)
    }
    
    @IBAction func playFastSound(sender: UIButton) {
 
        /* Set the (fast) rate to 1.5 ( Default rate is 1.0 ) */
        playWithRate(1.5)
      }
    
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        //Play audio at higher pitch.
        var highPitchEffect = AVAudioUnitTimePitch()
        highPitchEffect.pitch = 1000
        playAudioWithEffect(highPitchEffect)
    }

    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        //Play audio at lower pitch.
        var lowPitchEffect = AVAudioUnitTimePitch()
        lowPitchEffect.pitch = -1000
        playAudioWithEffect(lowPitchEffect)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        //Play audio with delay effect.
        var delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = 0.7
        playAudioWithEffect(delayEffect)
    }
    
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.LargeRoom2)
        reverbEffect.wetDryMix = 70
        playAudioWithEffect(reverbEffect)
    }

    //Combined function for Pitch, Reverb and Delay audio effects
    func playAudioWithEffect(effect: NSObject){
        
         /* Stop the audio player and engine */
        stopAudioPlayerAndEngine()
        
        //Play audio with effect applied.
        //Initialize AVPlayerNode and get other nodes as 'effect' from @IBActions.
        //Connect player node through 'effect' to audio engine output node, start audio engine and play file.
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect as AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as AVAudioNode, format: nil)
        audioEngine.connect(effect as AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        
        /* Stop the audio player and engine */
        stopAudioPlayerAndEngine()
    }

}
