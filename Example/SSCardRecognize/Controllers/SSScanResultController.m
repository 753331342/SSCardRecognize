//
//  SSScanResultController.m
//  SSCardRecognize
//
//  Created by 张家铭 on 2017/8/31.
//  Copyright © 2017年 753331342@qq.com. All rights reserved.
//

#import "SSScanResultController.h"

@interface SSScanResultController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *recoBtn;
@property (nonatomic, strong) UIButton *returnBtn;
@property (nonatomic, strong) UIButton *cropBtn;
@property (nonatomic, strong) UIButton *grayProcessBtn;
@property (nonatomic, strong) UIButton *thresholdBtn;
@property (nonatomic, strong) UIButton *erodeBtn;
@property (nonatomic, strong) UIButton *guassianBtn;
@property (nonatomic, strong) UIButton *dilateBtn;
@property (nonatomic, strong) UIButton *cannyBtn;

@end

@implementation SSScanResultController

#pragma mark - Life Cycle
- (instancetype)initWithQuery:(NSDictionary *)query {
	if (self = [super init]) {
		self.imageView.image = query[@"image"];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"展示图片";
	
	[self.view addSubview:self.imageView];
	[self.view addSubview:self.recoBtn];
	[self.view addSubview:self.returnBtn];
	[self.view addSubview:self.cropBtn];
	[self.view addSubview:self.grayProcessBtn];
	[self.view addSubview:self.thresholdBtn];
	[self.view addSubview:self.erodeBtn];
	[self.view addSubview:self.guassianBtn];
	[self.view addSubview:self.dilateBtn];
	[self.view addSubview:self.cannyBtn];
	
	
	[self relyout];
}

#pragma mark - Private Method

- (void)relyout {
	self.imageView.size = CGSizeMake(self.imageView.image.size.width / [UIScreen mainScreen].scale, self.imageView.image.size.height / [UIScreen mainScreen].scale);
}

/** 返回 */
- (void)backLast {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)guassianBtn {
	if (!_guassianBtn) {
		_guassianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_guassianBtn.frame = CGRectMake(10, _erodeBtn.bottom + 10, 100, 40);
		[_guassianBtn setTitle:@"高斯处理" forState:UIControlStateNormal];
		[_guassianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
		[_guassianBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_guassianBtn.backgroundColor = [UIColor redColor];
		[_guassianBtn addTarget:self action:@selector(guassianProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _guassianBtn;
}

- (UIButton *)dilateBtn {
	if (!_dilateBtn) {
		_dilateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_dilateBtn.frame = CGRectMake(10, _guassianBtn.bottom + 10, 100, 40);
		[_dilateBtn setTitle:@"膨胀处理" forState:UIControlStateNormal];
		[_dilateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
		[_dilateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_dilateBtn.backgroundColor = [UIColor redColor];
		[_dilateBtn addTarget:self action:@selector(dilateProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _dilateBtn;
}

- (UIButton *)erodeBtn {
	if (!_erodeBtn) {
		_erodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_erodeBtn.frame = CGRectMake(10, _thresholdBtn.bottom + 10, 100, 40);
		[_erodeBtn setTitle:@"腐蚀处理" forState:UIControlStateNormal];
		[_erodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
		[_erodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_erodeBtn.backgroundColor = [UIColor redColor];
		[_erodeBtn addTarget:self action:@selector(erodeProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _erodeBtn;
}

- (UIButton *)thresholdBtn {
	if (!_thresholdBtn) {
		_thresholdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_thresholdBtn.frame = CGRectMake(10, _grayProcessBtn.bottom + 10, 100, 40);
		[_thresholdBtn setTitle:@"阈值处理" forState:UIControlStateNormal];
		[_thresholdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_thresholdBtn.backgroundColor = [UIColor redColor];
		[_thresholdBtn addTarget:self action:@selector(thresholdProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _thresholdBtn;
}

- (UIButton *)grayProcessBtn {
	if (!_grayProcessBtn) {
		_grayProcessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_grayProcessBtn.frame = CGRectMake(10, _cropBtn.bottom + 10, 100, 40);
		[_grayProcessBtn setTitle:@"灰度处理" forState:UIControlStateNormal];
		[_grayProcessBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_grayProcessBtn.backgroundColor = [UIColor redColor];
		[_grayProcessBtn addTarget:self action:@selector(grayProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _grayProcessBtn;
}

- (UIButton *)cannyBtn {
	if (!_cannyBtn) {
		_cannyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_cannyBtn.frame = CGRectMake(_cropBtn.right + 30, _cropBtn.top, 100, 40);
		[_cannyBtn setTitle:@"边缘检测" forState:UIControlStateNormal];
		[_cannyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_cannyBtn.backgroundColor = [UIColor redColor];
		[_cannyBtn addTarget:self action:@selector(cannyProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cannyBtn;
}

- (UIButton *)cropBtn {
	if (!_cropBtn) {
		_cropBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_cropBtn.frame = CGRectMake(10, _imageView.bottom + 10, 100, 40);
		[_cropBtn setTitle:@"裁剪处理" forState:UIControlStateNormal];
		[_cropBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_cropBtn.backgroundColor = [UIColor redColor];
		[_cropBtn addTarget:self action:@selector(cropProcess) forControlEvents:UIControlEventTouchUpInside];
	}
	return _cropBtn;
}

- (UIButton *)returnBtn {
	if (!_returnBtn) {
		_returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_returnBtn.frame = CGRectMake(10, 10, 100, 40);
		[_returnBtn setTitle:@"返回" forState:UIControlStateNormal];
		[_returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_returnBtn.backgroundColor = [UIColor redColor];
		[_returnBtn addTarget:self action:@selector(backLast) forControlEvents:UIControlEventTouchUpInside];
	}
	return _returnBtn;
}

- (UIButton *)recoBtn {
	if (!_recoBtn) {
		_recoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		_recoBtn.frame = CGRectMake(200, 10, 100, 40);
		[_recoBtn setTitle:@"识别" forState:UIControlStateNormal];
		[_recoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_recoBtn.backgroundColor = [UIColor redColor];
		[_recoBtn addTarget:self action:@selector(clickReco) forControlEvents:UIControlEventTouchUpInside];
	}
	return _recoBtn;
}

- (UIImageView *)imageView {
	if (!_imageView) {
		CGFloat binkCardRatio = 54 / 84.5; // 银行卡的宽高比
		CGFloat binkCardWidth = 290.0 * viewRatio320();
		CGFloat binkCardHeight = binkCardWidth * binkCardRatio;
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth() - binkCardWidth) * 0.5, 64, binkCardWidth, binkCardHeight)];
		_imageView.backgroundColor = [UIColor redColor];
	}
	return _imageView;
}

@end
