//
//  ViewController.m
//  DrawWithTouchTest
//
//  Created by Bobson on 2015/12/10.
//  Copyright © 2015年 Bobson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
}

- (void)initView
{
    self.imageView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.imageView.layer.borderWidth = 1.0f;
    
    self.imageView.userInteractionEnabled = YES;
    
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    _pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
    
    [self moveHandler:nil];
    
    _tempImageView = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
    
    _red = 0.0f;
    _green = 255.0f;
    _blue = 0.0f;
}

- (void)pinchHandler:(UIPinchGestureRecognizer *) sender
{
    NSLog(@"pinchHandler");

    CGFloat scale = sender.scale;
    sender.view.transform = CGAffineTransformScale(sender.view.transform, scale, scale);
    
    sender.scale = 1;
}

- (void)panHandler:(UIPanGestureRecognizer *) sender
{
    
    NSLog(@"panHandler");
    
    CGPoint position = [sender translationInView:sender.view.superview];
    
    self.leftConstraint.constant += position.x;
    self.topConstraint.constant += position.y;
    
    [sender setTranslation:CGPointZero inView:sender.view.superview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _lastPoint = [touch locationInView:touch.view];
}
//
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isMove)
    {
        return;
    }
    
    
    // 鉛筆畫圖
    [self drawPen:touches withImage:_tempImageView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_isMove)
    {
        return;
    }
    
    self.imageView.image = _tempImageView.image;
    
}


/**
 * 鉛筆畫圖
 */
- (void)drawPen:(NSSet<UITouch *> *)touches withImage:(UIImageView *)imageView
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:imageView.bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(context, point.x, point.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // Force Touch
    BOOL isAvailableForceTouch = [[self traitCollection] forceTouchCapability] == UIForceTouchCapabilityAvailable;
    CGFloat force = isAvailableForceTouch == YES ? touch.force : 0.16;
    CGContextSetLineWidth(context, force);
    
    CGContextSetRGBStrokeColor(context, _red, _green, _blue, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextStrokePath(context);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    _tempImageView.image = newImage;
    self.imageView.image = newImage;
    
    UIGraphicsEndImageContext();
    
    _lastPoint = point;
    
    NSLog(@"drawPen: %f, %f", point.x, point.y);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moveHandler:(id)sender
{
    _isMove = YES;
    
    [self.imageView addGestureRecognizer:_pan];
    [self.imageView addGestureRecognizer:_pinch];
}

- (IBAction)drawHandler:(id)sender
{
    _isMove = NO;
    
    [self.imageView removeGestureRecognizer:_pan];
    [self.imageView removeGestureRecognizer:_pinch];
    
}

- (IBAction)cleanHandler:(UIButton *)sender
{
    _tempImageView.image = nil;
    self.imageView.image = nil;
}
@end
