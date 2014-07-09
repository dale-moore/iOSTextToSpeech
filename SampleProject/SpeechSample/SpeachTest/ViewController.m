//
//  ViewController.m
//  SpeachTest
//
//  Created by Dale Moore on 7/8/14.
//  Copyright (c) 2014 Ducky Software LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize myTextToSpeak;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Default the text shown on the UI
    myTextToSpeak.text = @"Hello World | How are you doing";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (IBAction)onSpeakText:(id)sender {
    
    NSLog(@"onSpeakText enter");
    
    if (mySpeechSynthesizer == nil)
    {
        mySpeechSynthesizer = [[AVSpeechSynthesizerFacade alloc] init];
    }
    
    [mySpeechSynthesizer speakText:myTextToSpeak.text];
    
}

@end
