//
//  ViewController.m
//  CoreMediaIO
//
//  Created by An Le Phu Nguyen on 9/9/16.
//  Copyright © 2016 An Le Phu Nguyen. All rights reserved.
//

#import "ViewController.h"

void EnableDALDevices()
{
  CMIOObjectPropertyAddress prop = {
    kCMIOHardwarePropertyAllowScreenCaptureDevices,
    kCMIOObjectPropertyScopeGlobal,
    kCMIOObjectPropertyElementMaster
  };
  UInt32 allow = 1;
  CMIOObjectSetPropertyData(kCMIOObjectSystemObject,
                            &prop, 0, NULL,
                            sizeof(allow), &allow );
}

void start() {
  EnableDALDevices();
}

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  start();
  [self showDevices];
  
  self.queueiPad = dispatch_queue_create("queueiPad", NULL);
  self.queueiPhone = dispatch_queue_create("queueiPhone", NULL);
}

- (void)showDevices {
  NSArray* devs = [AVCaptureDevice devices];
  NSString *list = [[NSString alloc] init];
  
  int i = 0;
  for (AVCaptureDevice* device in devs) {
    list = [list stringByAppendingFormat:@"%d. %@\n", ++i, [device localizedName]];
  }
  
  [self.txtDevices setStringValue:list];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
  
  // Update the view, if already loaded.
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
  NSLog(@"captureOutput: %x, connection: %x", captureOutput, connection);
  //    if (captureOutput == self.outputDeviceiPad) {
  //      // handle frames from first device
  //      int i = 0;
  //    }
  //    else if (captureOutput == self.outputDeviceiPhone) {
  //      // handle frames from second device
  //      int j = 0;
  //    }
}

- (void) startStream:(NSString *)deviceName
                view:(NSView *)view
             session:(AVCaptureSession *)session
              player:(AVCaptureVideoPreviewLayer *)player
               input:(AVCaptureDeviceInput *)inputVideo
               ouput:(AVCaptureVideoDataOutput *)ouputVideo
               queue: (dispatch_queue_t)queue {
  // all devices were turned media type on
  NSArray* devs = [AVCaptureDevice devices];
  
  for (AVCaptureDevice* device in devs) {
    if ([[device localizedName] isEqualToString:deviceName]) {
      NSError *deviceError;
      
      session = [[AVCaptureSession alloc] init];
      session.sessionPreset = AVCaptureSessionPresetMedium;
      
      ouputVideo = [[AVCaptureVideoDataOutput alloc] init];
      [ouputVideo setSampleBufferDelegate:self queue:queue];
      //      NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
      //      NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32RGBA];
      //      NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
      //      [ouputVideo setVideoSettings:videoSettings];
      
      inputVideo = [AVCaptureDeviceInput deviceInputWithDevice:device error:&deviceError];
      
      [session addInput:inputVideo];
      //      [session addOutput:outputDevice];
      [session addOutputWithNoConnections:ouputVideo];
      
      // manual add port for each output video
      for (AVCaptureInputPort *port in [inputVideo ports]) {
        if ([[port mediaType] isEqualToString:AVMediaTypeVideo]) {
          AVCaptureConnection* cxn = [AVCaptureConnection
                                      connectionWithInputPorts:[NSArray arrayWithObject:port]
                                      output:ouputVideo
                                      ];
          if ([session canAddConnection:cxn]) {
            [session addConnection:cxn];
          }
          break;
        }
      }
      
      // make preview layer and add so that camera's view is displayed on screen
      //      player = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
      player = [AVCaptureVideoPreviewLayer layerWithSession:session];
      [player setBackgroundColor:[[NSColor blackColor] CGColor]];
      player.frame = view.bounds;
      //      player.videoGravity = AVLayerVideoGravityResizeAspect;
      
      [view setWantsLayer:YES];
      [view.layer addSublayer:player];
      [session startRunning];
      
      break;
    }
  }
}

- (void)stopStream:(NSString *)deviceName
              view:(NSView *)view
           session:(AVCaptureSession *)session
            player:(AVCaptureVideoPreviewLayer *)player
             input:(AVCaptureDeviceInput *)inputVideo
             ouput:(AVCaptureVideoDataOutput *)ouputVideo {
  [player removeFromSuperlayer];
  [session stopRunning];
  
  session = NULL;
  player = NULL;
  inputVideo = NULL;
  ouputVideo = NULL;
}

- (IBAction)stopiPad:(id)sender {
  [self stopStream:[self.txtDeviceName stringValue]
              view:self.cameraViewiPad
           session:self.captureSessioniPad
            player:self.capturePlayeriPad
             input:self.inputDeviceiPad
             ouput:self.outputDeviceiPad];
}

- (IBAction)stopiPhone:(id)sender {
  [self stopStream:[self.txtDeviceName stringValue]
              view:self.cameraViewiPhone
           session:self.captureSessioniPhone
            player:self.capturePlayeriPhone
             input:self.inputDeviceiPhone
             ouput:self.outputDeviceiPhone];
}

- (IBAction)playiPad:(id)sender {
  [self startStream:[self.txtDeviceName stringValue]
               view:self.cameraViewiPad
            session:self.captureSessioniPad
             player:self.capturePlayeriPad
              input:self.inputDeviceiPad
              ouput:self.outputDeviceiPad
              queue:self.queueiPad];
}

- (IBAction)playiPhone:(id)sender {
  [self startStream:[self.txtDeviceName stringValue]
               view:self.cameraViewiPhone
            session:self.captureSessioniPhone
             player:self.capturePlayeriPhone
              input:self.inputDeviceiPhone
              ouput:self.outputDeviceiPhone
              queue:self.queueiPhone];
}

- (IBAction)pressedRefreshBtn:(id)sender {
  [self showDevices];
}
@end
