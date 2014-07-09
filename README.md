iOSTextToSpeech
===============

Wrapper class for Apple's Text-to-Speech engine that handles playing text-to-speech over music.

The AVSpeechSynthesizerFacade class is a wrapper class around Apple's AVSpeechSynthesizer class.

The AVSpeechSynthesizerFacade class is built so it can be used in an ARC or non-ARC project by 
using preprocessor macros to detect ARC usage.

The AVSpeechSynthesizerFacade class contains a single method that developers can call to 
request utterances to be spoken.

The benefit of using this class is that the class handles the coordinator with the AVAudioSession
so that if the user is playing music via iPod player or Pandora, the music volume will be reduced
and the text to be spoken will be played over top of the music.  After the text has been spoken
the music will be returned to its original volume.  This is all fairly simple, but there is a 
curious coordinator between starting a session and ending a session when the AVSpeechSynthesizer is
busy and this class handles that coordination.

The AVSpeechSynthesizerFacade class usage is documented in the AVSpeechSynthesizerFacade.h file.

The following features are missing, but can be easily added:

- usage of the volume property

- usage of the rate property

- usage of the utterance delay property.

 
