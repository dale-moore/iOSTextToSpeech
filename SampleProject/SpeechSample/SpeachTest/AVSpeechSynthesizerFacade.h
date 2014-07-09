//
//  AVSpeechSynthesizerFacade.h
//
//  Created by Dale Moore on 7/8/14.
//  Copyright (c) 2014 Ducky Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

// ----------------------------------------------------------------------------------
// Class Desription and Sample Usage
// ----------------------------------------------------------------------------------
//
// This class encapsulates the classes provided by Apple for using the text to
// speech engine.  This encapsulation helps to simplify the interface for those
// that want to use spoken text while another sound source is playing (such as
// Pandora or the iPod music player).  When the text is spoken, this class will
// lower the volume of the music, speak the text and then return the volume of
// the music to where it was prior to the spoken text.
//
// The class is built with preprocessor statements so it can be used in an ARC or
// NON-ARC project without modifications.
//
// The following snippet illustrates how this class can be used to convert
// text to speech.
//
// // Create the class
// AVSpeechSynthesizerFacade* mySpeech = [[AVSpeechSynthesizerFacade alloc] init];
//
// // Ask the class to speak.
// [mySpeech speakText:@"Hello World"];
//
// // Ask the class to speak two utterances
// [mySpeech speakText:@"Hello World.|How are you doing?";
//

@interface AVSpeechSynthesizerFacade : NSObject <AVSpeechSynthesizerDelegate> {
    
    AVSpeechSynthesizer *mySynthesizer;
    
}

// ----------------------------------------------------------------------------------
// Methods/Behaviors
// ----------------------------------------------------------------------------------

/*!
 * \brief Call this method to request text to be spoken to the user.
 * \param speakText - the text to speak
 *
 *
 * This is the main method to use to speak to the user.  In this 
 * implementation, if music is being played the music volume will be
 * decreased and the speach volume will be increased so the user 
 * can hear the spoken text.
 *
 * If you want to have multiple sentences, called utterances in
 * TTS lingo, then pass a single string with each utterance separated
 * by a | symbol.
 *
 * By default, the spoken text is voiced at full volume at a rate of
 * 0.27f out of scale from 0 to 1.  The default delay between utterances
 * is 0.2 seconds.  All of these defaults can be changed by using the 
 * properties.
 */
- (void)speakText:(NSString*)aTextToSpeak;

// ----------------------------------------------------------------------------------
// User Controlled Properties
// ----------------------------------------------------------------------------------
@property float myUtteranceDelay;   /*!< A float value from 0 to 1 representing the number of seconds between utterances.*/
@property float mySpeechRate;       /*!< A float value from 0 to 1 representing the rate of speech.     */
@property float mySpeechVolume;     /*!< A float value from 0 to 1 representing the volume of speech.   */

// ----------------------------------------------------------------------------------
// Class Controlled Properties
// ----------------------------------------------------------------------------------
@property NSInteger myExpectedUtterances;   /*!< Internally used by the class */
@property NSInteger myDeactivationAttempts; /*!< Internally used by the class */

@end
