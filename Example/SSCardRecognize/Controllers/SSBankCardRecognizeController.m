//
//  SSBankCardRecognizeController.m
//  SSCardRecognize
//
//  Created by 张家铭 on 2017/8/31.
//  Copyright © 2017年 753331342@qq.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "SSBankCardRecognizeController.h"
#import "SSScanResultController.h"

#import "SSBankCardScanningView.h"

@interface SSBankCardRecognizeController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) UIButton *rightNaviItem;
@property (nonatomic, strong) SSBankCardScanningView *scanView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) UIView *bottomWhiteView;
@property (nonatomic, strong) UILabel *addBankCardLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UIButton *handInputLabel;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) NSNumber *outPutSetting;
@property (nonatomic, strong) AVCaptureConnection *connection;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation SSBankCardRecognizeController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"扫描银行卡";
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightNaviItem];
	
	[self.view.layer addSublayer:self.previewLayer];
	
	[self.previewLayer addSublayer:self.scanView.layer];
	
	[self.view addSubview:self.bottomWhiteView];
	[self.bottomWhiteView addSubview:self.addBankCardLabel];
	[self.bottomWhiteView addSubview:self.introduceLabel];
	[self.bottomWhiteView addSubview:self.handInputLabel];
	
	self.metadataOutput.rectOfInterest = [self.previewLayer metadataOutputRectOfInterestForRect:self.scanView.frame];
	
	[self configConnection];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	dispatch_async(self.queue, ^{
		[self.session startRunning];
	});
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[self.scanView stopScanning];
	
	[self.timer invalidate];
	self.timer = nil;
	
	dispatch_async(self.queue, ^{
		[self.session stopRunning];
	});
}

- (void)dealloc {
	NSLog(@"死翘翘了");
}

#pragma mark - <AVCaptureVideoDataOutputSampleBufferDelegate>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection  {
	if ([self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]]) {
		if (captureOutput == self.videoDataOutput) {
			
			UIImage *image = [SSImageTool imageWithSampleBuffer:sampleBuffer];
			
			CGFloat ratio = 480.0 / viewWidth();
			image = [SSImageTool imageWithImage:image inRect:CGRectMake(self.scanView.left * ratio, self.scanView.top * ratio, self.scanView.width * ratio, self.scanView.height * ratio)];
			
			image = [SSImageTool cropImageFromImage:image];
		
	        // 停止拍照
			if (self.videoDataOutput.sampleBufferDelegate) {
				[self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
			}
			
			dispatch_async(self.queue, ^{
				[self.session stopRunning];
			});
			
			SSScanResultController *imageVC = [[SSScanResultController alloc] initWithQuery:@{@"image" : image}];
			
			dispatch_async(dispatch_get_main_queue(), ^{
				[self presentViewController:imageVC animated:YES completion:nil];
			});
		}
	}
}

#pragma mark - Private Method
- (void)configConnection {
	if (self.connection.supportsVideoStabilization) {
		self.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
		self.connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
	}
}

#pragma mark - Event Respond
- (void)onHandInputClicked {
	[self.videoDataOutput setSampleBufferDelegate:self queue:self.queue];
}

- (void)onRightNaviBarClicked {
	[self.videoDataOutput setSampleBufferDelegate:self queue:self.queue];
}

#pragma mark - Getters and Setters
- (NSNumber *)outPutSetting {
	if (_outPutSetting == nil) {
		_outPutSetting = @(kCVPixelFormatType_32BGRA);
	}
	return _outPutSetting;
}
- (UIButton *)rightNaviItem {
	if (!_rightNaviItem) {
		_rightNaviItem = [UIButton buttonWithType:UIButtonTypeCustom];
		[_rightNaviItem setImage:[UIImage imageNamed:@"bind_bank_card_torch"] forState:UIControlStateNormal];
		_rightNaviItem.frame = CGRectMake(0, 0, 30, 30);
		[_rightNaviItem addTarget:self action:@selector(onRightNaviBarClicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rightNaviItem;
}

- (SSBankCardScanningView *)scanView {
	if (!_scanView) {
		CGFloat binkCardRatio = BANKCARDHEIGTHWIDTHRATIO;
		CGFloat binkCardWidth = BANKCARDWIDTH * viewRatio320();
		CGFloat binkCardHeight = binkCardWidth * binkCardRatio;
		_scanView = [[SSBankCardScanningView alloc] initWithFrame:CGRectMake((_previewLayer.frame.size.width - binkCardWidth) * 0.5, (_previewLayer.frame.size.height - binkCardHeight) * 0.5, binkCardWidth, binkCardHeight)];
		
	}
	return _scanView;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
	if (!_previewLayer) {
		_previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
		CGFloat imageWidthRatioToHeight = 480.0 / 640.0;
		CGFloat height = viewWidth() / imageWidthRatioToHeight;
		_previewLayer.frame = CGRectMake(0, 64, viewWidth(), height);
	}
	return _previewLayer;
}

- (UIView *)bottomWhiteView {
	if (!_bottomWhiteView) {
		_bottomWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + _previewLayer.frame.size.height, viewWidth(), viewHeight() - 64 - _previewLayer.frame.size.height)];
		_bottomWhiteView.backgroundColor = [UIColor whiteColor];
	}
	return _bottomWhiteView;
}

- (UILabel *)addBankCardLabel {
	if (!_addBankCardLabel) {
		_addBankCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, viewWidth(), 33)];
		_addBankCardLabel.text = @"添加银行卡";
		_addBankCardLabel.textColor = [UIColor redColor];
		_addBankCardLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _addBankCardLabel;
}

- (UILabel *)introduceLabel {
	if (!_introduceLabel) {
		_introduceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.addBankCardLabel.frame.origin.y + self.addBankCardLabel.frame.size.height + 4, viewWidth(), 20)];
		_introduceLabel.textColor = [UIColor redColor];
		_introduceLabel.text = @"请将银行卡正面置于上方方框内";
		_introduceLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _introduceLabel;
}

- (UIButton *)handInputLabel {
	if (!_handInputLabel) {
		_handInputLabel = [[UIButton alloc] initWithFrame:CGRectMake(0, self.introduceLabel.frame.size.height + self.introduceLabel.frame.origin.y + 65, viewWidth(), 20)];
		
		[_handInputLabel setTitle:@"手动输入" forState:UIControlStateNormal];
		[_handInputLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[_handInputLabel addTarget:self action:@selector(onHandInputClicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _handInputLabel;
}

- (AVCaptureSession *)session {
	if (_session == nil) {
		_session = [[AVCaptureSession alloc] init];
		
		_session.sessionPreset = AVCaptureSessionPreset640x480;
		
		// 2、设置输入：由于模拟器没有摄像头，因此最好做一个判断
		NSError *error = nil;
		AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
		
		if (error) {
			NSLog(@"%@", error);
		} else {
			if ([_session canAddInput:input]) {
				[_session addInput:input];
			}
			
			if ([_session canAddOutput:self.videoDataOutput]) {
				[_session addOutput:self.videoDataOutput];
			}
			
			if ([_session canAddOutput:self.metadataOutput]) {
				[_session addOutput:self.metadataOutput];
			}
		}
	}
	return _session;
}

- (AVCaptureMetadataOutput *)metadataOutput {
	if (!_metadataOutput) {
		_metadataOutput = [[AVCaptureMetadataOutput alloc] init];
	}
	return _metadataOutput;
}

- (dispatch_queue_t)queue {
	if (!_queue) {
		_queue =  dispatch_queue_create("www.captureQue.com", NULL);
	}
	return _queue;
}

- (AVCaptureVideoDataOutput *)videoDataOutput {
	if (_videoDataOutput == nil) {
		_videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
		_videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
		_videoDataOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:self.outPutSetting, (id)kCVPixelBufferPixelFormatTypeKey, nil];
	}
	
	return _videoDataOutput;
}

- (AVCaptureDevice *)device {
	if (_device == nil) {
		_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
		
		NSError *error = nil;
		if ([_device lockForConfiguration:&error]) {
			if ([_device isSmoothAutoFocusSupported]) { // 平滑对焦
				_device.smoothAutoFocusEnabled = YES;
			}
			
			if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) { // 自动持续对焦
				_device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
			}
			
			if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) { // 自动持续曝光
				_device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
			}
			
			if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) { // 自动持续白平衡
				_device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
			}
			[_device unlockForConfiguration];
		}
	}
	
	return _device;
}

- (AVCaptureConnection *)connection {
	if (!_connection) {
		_connection = [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
	}
	return _connection;
}

@end
