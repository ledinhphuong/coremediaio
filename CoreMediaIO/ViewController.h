//
//  ViewController.h
//  CoreMediaIO
//
//  Created by An Le Phu Nguyen on 9/9/16.
//  Copyright © 2016 An Le Phu Nguyen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreMediaIO/CMIOHardware.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : NSViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {
    
}
@property (weak) IBOutlet NSTextField *txtDeviceName;
@property (weak) IBOutlet NSTextField *txtDevices;
- (IBAction)pressedRefreshBtn:(id)sender;

@property (nonatomic, strong) dispatch_queue_t queueiPad, queueiPhone;

@property (weak) IBOutlet NSView *cameraViewiPad;
@property (nonatomic, strong) AVCaptureSession* captureSessioniPad;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* capturePlayeriPad;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDeviceiPad;
@property (nonatomic, strong) AVCaptureVideoDataOutput *outputDeviceiPad;

@property (weak) IBOutlet NSView *cameraViewiPhone;
@property (nonatomic, strong) AVCaptureSession* captureSessioniPhone;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* capturePlayeriPhone;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDeviceiPhone;
@property (nonatomic, strong) AVCaptureVideoDataOutput *outputDeviceiPhone;
@end

