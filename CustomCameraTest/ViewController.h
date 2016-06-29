//
//  ViewController.h
//  CustomCameraTest
//
//  Created by Eduardo on 6/29/16.
//  Copyright © 2016 Eduardo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UIImageView *captureImageView;

-(IBAction)didTakePhoto:(id)sender;

@end

