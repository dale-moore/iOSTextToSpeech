//
//  AVSpeechSynthesizerFacade.m
//
//  Created by Dale Moore on 7/8/14.
//  Copyright (c) 2014 Ducky Software LLC. All rights reserved.
//

#import "AVSpeechSynthesizerFacade.h"


@implementation AVSpeechSynthesizerFacade


@synthesize myExpectedUtterances;
@synthesize myDeactivationAttempts;


- (void)speakText:(NSString*)aTextToSpeak {
    
    NSLog(@"AVSpeechSynthesizerFacade::speakText enter");
    
    if (mySynthesizer == nil) {
        
        mySynthesizer = [[AVSpeechSynthesizer alloc] init];
        
        [mySynthesizer setDelegate:self];
    }
    
    
    // Setup the audio session.
    // An AVAudioSession class is a singleton object.
    AVAudioSession* session = [AVAudioSession sharedInstance];
    
    NSError* error = nil;
    
    BOOL success = [session setCategory:AVAudioSessionCategoryPlayback
                            withOptions:AVAudioSessionCategoryOptionDuckOthers
                                  error:&error];
    if (success == YES)
    {
        NSLog(@"AVSpeechSynthesizerFacade::speakText - AVAudioSession category has been successfully set");
    }
    else
    {
        NSLog(@"AVSpeechSynthesizerFacade::speakText  - AVAudioSession error while setting category due to - %@",error);
    }
    
    // Set the session mode
    success = [session setMode:AVAudioSessionModeDefault error:&error];
    if (success == YES)
    {
        NSLog(@"AVSpeechSynthesizerFacade::speakText - AVAudioSession mode has been successfully set");
    }
    else
    {
        NSLog(@"AVSpeechSynthesizerFacade::speakText - AVAudioSession error while setting mode due to - %@",error);
    }
    
    
    // Activate the session
    success = [session setActive:YES error:&error];
    
    if (success == YES)
    {
        NSLog(@"AVSpeechSynthesizerFacade::speakText - AVAudioSession has been activated");
    }
    else
    {
        NSLog(@"AVSpeechSynthesizerFacade::speakText - Error activating the AVAudioSession session due to - %@",error);
    }
    
    
    
    // Split the utterances into separate array entries.
    NSArray* speechArray = [aTextToSpeak componentsSeparatedByString:@"|"];
    
    [self setMyExpectedUtterances:[speechArray count]];
    
    NSLog(@"There are %ld utterances to speak", myExpectedUtterances);
    
    for (int i=0; i<[speechArray count]; i++)
    {
        NSString* speech = [speechArray objectAtIndex:i];
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:speech];
        
        [utterance setRate:0.27f];
        
        [utterance setVolume:1.0];
        
        // 1 second
        [utterance setPostUtteranceDelay:1];
        
        [self setMyDeactivationAttempts:0];
        
        [mySynthesizer speakUtterance:utterance];
    }
    
}


- (void) cancelAudioSession {
    
    NSLog(@"AVSpeechSynthesizerFacade::cancelAudioSession enter");
    
    if ([mySynthesizer isSpeaking] == YES)
    {
        // Before shutting down a session we need to clear all queues, converters, players and recorders
        // or the AVAudioSession will not terminate properly.
        
        NSLog(@"AVSpeechSynthesizerFacade::cancelAudioSession the speech engine is still busy.  Wait 1 second before trying to deactivate the session.");
        [self performSelector:@selector(cancelAudioSession) withObject:nil afterDelay:1.0];
        return;
    }
    
    
    if ([self myDeactivationAttempts] < 3)
    {
        NSLog(@"AVSpeechSynthesizerFacade::cancelAudioSession attempt number %ld", [self myDeactivationAttempts]);
        
        [self setMyDeactivationAttempts:[self myDeactivationAttempts]+1];
        
        AVAudioSession* session = [AVAudioSession sharedInstance];
        
        NSError* error = nil;
        BOOL success = [session setActive:NO error:&error];
        
        if (success == YES)
        {
            NSLog(@"AVSpeechSynthesizerFacade::cancelAudioSession AVAudioSession has been deactivated");
        }
        else
        {
            NSLog(@"AVSpeechSynthesizerFacade::cancelAudioSession error deactivating the AVAudioSession session due to - %@.",error);
            
            // Try deactivation again after 2 seconds in case something was busy shutting down
            NSLog(@"Deactivating the AVAudioSession session request %ld in 2 seconds",[self myDeactivationAttempts]);
            
            [self performSelector:@selector(cancelAudioSession) withObject:nil afterDelay:2.0];
        }
    }
    else
    {
        NSLog(@"AVSpeechSynthesizerFacade::cancelAudioSession no more attempts");
    }
}

#pragma mark -
#pragma mark AVSpeechSynthesizerDelegate Handlers
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"AVSpeechSynthesizerFacade::didStartSpeechUtterance enter");
    
    // Nothing to do
}



- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"AVSpeechSynthesizerFacade::didFinishSpeechUtterance enter");
    
    // Check if the audio session has another utterance pending.  If so,
    // we should not cancel the session yet.
    [self setMyExpectedUtterances:(myExpectedUtterances - 1)];
    
    if ([self myExpectedUtterances] < 1)
    {
        NSLog(@"AVSpeechSynthesizerFacade::didFinishSpeechUtterance - cancelling the audio session");
        
        [self setMyDeactivationAttempts:0];
        
        [self cancelAudioSession];
    }
    else
    {
        NSLog(@"AVSpeechSynthesizerFacade::didFinishSpeechUtterance - not canceling audio session yet because there are %ld utterances pending", [self myExpectedUtterances]);
    }
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"AVSpeechSynthesizerFacade::didCancelSpeechUtterance enter");
    
    [self setMyDeactivationAttempts:0];
    
    [self cancelAudioSession];
}

#pragma mark -
#pragma mark Memory Management
- (void) dealloc {
    
#if ! __has_feature(objc_arc)
    if (mySynthesizer != nil) {
        // If we are NOT using Automatic Reference Counting then free the memory manually
        NSLog(@"AVSpeechSyntheseizerFacade is running in a NON-ARC environment.");
        [mySynthesizer release];
    }
    [super dealloc];
#endif
    
    
}

@end
