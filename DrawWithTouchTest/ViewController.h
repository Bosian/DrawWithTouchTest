//
//  ViewController.h
//  DrawWithTouchTest
//
//  Created by Bobson on 2015/12/10.
//  Copyright © 2015年 Bobson. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface ViewController : UIViewController
{
    UIPanGestureRecognizer *_pan;
    UIPinchGestureRecognizer *_pinch;
    
    BOOL _isMove;

    CGPoint _lastPoint;
    
    CGFloat _red;
    CGFloat _green;
    CGFloat _blue;
    CGFloat _alpha;

    UIImageView *_tempImageView;
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)moveHandler:(id)sender;

- (IBAction)drawHandler:(id)sender;

- (IBAction)cleanHandler:(UIButton *)sender;

@end



