//
//  ViewController.h
//  SpeachTest
//
//  Created by Dale Moore on 7/8/14.
//  Copyright (c) 2014 Ducky Software LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AVSpeechSynthesizerFacade.h"

@interface ViewController : UIViewController  {
    
    AVSpeechSynthesizerFacade* mySpeechSynthesizer;
    
}


@property (nonatomic, retain) IBOutlet UITextField* myTextToSpeak;


- (IBAction)onSpeakText:(id)sender;


@end
