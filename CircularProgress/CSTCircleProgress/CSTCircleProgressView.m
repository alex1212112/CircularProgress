//
//  CSTCircleView.m
//  CoasterNevermore
//
//  Created by Ren Guohua on 15/6/29.
//  Copyright (c) 2015年 Ren guohua. All rights reserved.
//

#import "CSTCircleProgressView.h"



@interface CSTCircleProgressLayer : CALayer

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property(nonatomic, strong) UIColor *innerTintColor;
@property(nonatomic) NSInteger roundedCorners;
@property(nonatomic) CGFloat thicknessRatio;
@property(nonatomic) CGFloat progress;
@property(nonatomic) NSInteger clockwiseProgress;

@end

@implementation CSTCircleProgressLayer

@dynamic trackTintColor;
@dynamic progressTintColor;
@dynamic innerTintColor;
@dynamic roundedCorners;
@dynamic thicknessRatio;
@dynamic progress;
@dynamic clockwiseProgress;

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progress"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (id< CAAction >)actionForKey:(NSString *)key
{
    if ([self presentationLayer] != nil)
    {
        if ([key isEqualToString:@"progress"]) {
            
            CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
            
            anim.fromValue = [[self presentationLayer] valueForKey:key];
            anim.duration = 0.5;
            anim.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            return anim;
        }
    }
    return [super animationForKey:key];
}

- (void)drawInContext:(CGContextRef)context
{
    [super drawInContext:context];
    CGRect rect = self.bounds;
    CGPoint centerPoint = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2.0f;
    
    BOOL clockwise = (self.clockwiseProgress != 0);
    
    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat radians = 0;
    
    if (clockwise) {
        radians = (float)((progress * (2.0f - 1.0 / 3.0) * M_PI) + (2.0 / 3.0) * M_PI) ;
    } else {
        radians = (float)((1.0 / 3.0) * M_PI - (progress * (2.0f - 1.0 / 3.0) * M_PI)) ;
    }
    
    CGContextSetFillColorWithColor(context, self.trackTintColor.CGColor);
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(2.0 / 3.0 * M_PI), (float)(1.0 / 3.0 * M_PI), NO);

   // CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    if (self.roundedCorners) {
        
        CGFloat xOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf((2.0 / 3.0 * M_PI))));
        CGFloat yOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(2.0 / 3.0 * M_PI)));
        CGPoint startPoint = CGPointMake(xOffset, yOffset);
        CGFloat pathWidth = radius * self.thicknessRatio;
        
        CGRect startEllipseRect = (CGRect) {
            .origin.x = startPoint.x - pathWidth / 2.0f,
            .origin.y = startPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, startEllipseRect);
        CGContextFillPath(context);
        
        xOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf((1.0 / 3.0 * M_PI))));
        yOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(1.0 / 3.0 * M_PI)));
        CGPoint endPoint = CGPointMake(xOffset, yOffset);
        
        CGRect endEllipseRect = (CGRect) {
            .origin.x = endPoint.x - pathWidth / 2.0f,
            .origin.y = endPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, endEllipseRect);
        CGContextFillPath(context);
    }
    
    if (progress > 0.0f) {
        CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
        
        if (clockwise) {
            
            CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(2.0 / 3.0 * M_PI), radians, !clockwise);
        }else{
        
            CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, (float)(1.0 / 3.0 * M_PI_2), radians, clockwise);
        }
        
        if (self.roundedCorners) {
            
            CGContextSetLineCap(context, kCGLineCapRound);
        }
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
    }
    
    
    if (progress > 0.0f && self.roundedCorners) {
        CGFloat pathWidth = radius * self.thicknessRatio;

        CGFloat xOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf((2.0 / 3.0 * M_PI))));
        CGFloat yOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(2.0 / 3.0 * M_PI)));
        CGPoint startPoint = CGPointMake(xOffset, yOffset);
        
        CGRect startEllipseRect = (CGRect) {
            .origin.x = startPoint.x - pathWidth / 2.0f,
            .origin.y = startPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, startEllipseRect);
        CGContextFillPath(context);
        
        
        xOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * cosf((radians))));
        yOffset = radius * (1.0f + ((1.0f - (self.thicknessRatio / 2.0f)) * sinf(radians)));
        CGPoint endPoint = CGPointMake(xOffset, yOffset);
        
        CGRect endEllipseRect = (CGRect) {
            .origin.x = endPoint.x - pathWidth / 2.0f,
            .origin.y = endPoint.y - pathWidth / 2.0f,
            .size.width = pathWidth,
            .size.height = pathWidth
        };
        CGContextAddEllipseInRect(context, endEllipseRect);
        CGContextFillPath(context);
    }
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGFloat innerRadius = radius * (1.0f - self.thicknessRatio);
    CGRect clearRect = (CGRect) {
        .origin.x = centerPoint.x - innerRadius,
        .origin.y = centerPoint.y - innerRadius,
        .size.width = innerRadius * 2.0f,
        .size.height = innerRadius * 2.0f
    };
    CGContextAddEllipseInRect(context, clearRect);
    CGContextFillPath(context);
    
    if (self.innerTintColor) {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextSetFillColorWithColor(context, [self.innerTintColor CGColor]);
        CGContextAddEllipseInRect(context, clearRect);
        CGContextFillPath(context);
    }
     
}

- (void)display
{
    [super display];
}


@end


@interface CSTCircleProgressView ()

@end


@implementation CSTCircleProgressView

+ (void) initialize
{
    if (self == [CSTCircleProgressView class]) {
        CSTCircleProgressView *circularProgressViewAppearance = [CSTCircleProgressView appearance];
        [circularProgressViewAppearance setTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3f]];
        [circularProgressViewAppearance setProgressTintColor:[UIColor whiteColor]];
        [circularProgressViewAppearance setInnerTintColor:nil];
        [circularProgressViewAppearance setBackgroundColor:[UIColor clearColor]];
        [circularProgressViewAppearance setThicknessRatio:0.3f];
        [circularProgressViewAppearance setRoundedCorners:NO];
        [circularProgressViewAppearance setClockwiseProgress:YES];
        
        [circularProgressViewAppearance setIndeterminateDuration:2.0f];
        [circularProgressViewAppearance setIndeterminate:NO];
    }
}

+ (Class)layerClass
{
    return [CSTCircleProgressLayer class];
}

- (CSTCircleProgressLayer *)circularProgressLayer
{
    return (CSTCircleProgressLayer *)self.layer;
}

- (id)init
{
    return [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
}

- (void)didMoveToWindow
{
    CGFloat windowContentsScale = self.window.screen.scale;
    self.circularProgressLayer.contentsScale = windowContentsScale;
    [self.circularProgressLayer setNeedsDisplay];
}


#pragma mark - Progress

- (CGFloat)progress
{
    return self.circularProgressLayer.progress;
}

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [self setProgress:progress animated:animated initialDelay:0.0];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
{
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    [self setProgress:progress
             animated:animated
         initialDelay:initialDelay
         withDuration:fabs(self.progress - pinnedProgress)];
}

- (void)setProgress:(CGFloat)progress
           animated:(BOOL)animated
       initialDelay:(CFTimeInterval)initialDelay
       withDuration:(CFTimeInterval)duration
{
    [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    [self.circularProgressLayer removeAnimationForKey:@"progress"];
    
    CGFloat pinnedProgress = MIN(MAX(progress, 0.0f), 1.0f);
    if (animated) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"progress"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.fillMode = kCAFillModeForwards;
        animation.fromValue = [NSNumber numberWithFloat:self.progress];
        
        animation.toValue = [NSNumber numberWithFloat:pinnedProgress];
        animation.beginTime = CACurrentMediaTime() + initialDelay;
        animation.delegate = self;
        
        [self.circularProgressLayer addAnimation:animation forKey:@"progress"];
        
    } else {
        [self.circularProgressLayer setNeedsDisplay];
        self.circularProgressLayer.progress = pinnedProgress;
    }
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag
{
    NSNumber *pinnedProgressNumber = [animation valueForKey:@"toValue"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.circularProgressLayer.progress = [pinnedProgressNumber floatValue];
    [CATransaction commit];
}


#pragma mark - UIAppearance methods

- (UIColor *)trackTintColor
{
    return self.circularProgressLayer.trackTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    self.circularProgressLayer.trackTintColor = trackTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (UIColor *)progressTintColor
{
    return self.circularProgressLayer.progressTintColor;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    self.circularProgressLayer.progressTintColor = progressTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (UIColor *)innerTintColor
{
    return self.circularProgressLayer.innerTintColor;
}

- (void)setInnerTintColor:(UIColor *)innerTintColor
{
    self.circularProgressLayer.innerTintColor = innerTintColor;
    [self.circularProgressLayer setNeedsDisplay];
}

- (NSInteger)roundedCorners
{
    return self.roundedCorners;
}

- (void)setRoundedCorners:(NSInteger)roundedCorners
{
    self.circularProgressLayer.roundedCorners = roundedCorners;
    [self.circularProgressLayer setNeedsDisplay];
}

- (CGFloat)thicknessRatio
{
    return self.circularProgressLayer.thicknessRatio;
}

- (void)setThicknessRatio:(CGFloat)thicknessRatio
{
    self.circularProgressLayer.thicknessRatio = MIN(MAX(thicknessRatio, 0.f), 1.f);
    [self.circularProgressLayer setNeedsDisplay];
}

- (NSInteger)indeterminate
{
    CAAnimation *spinAnimation = [self.layer animationForKey:@"indeterminateAnimation"];
    return (spinAnimation == nil ? 0 : 1);
}

- (void)setIndeterminate:(NSInteger)indeterminate
{
    if (indeterminate) {
        if (!self.indeterminate) {
            CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            spinAnimation.byValue = [NSNumber numberWithDouble:indeterminate > 0 ? 2.0f*M_PI : -2.0f*M_PI];
            spinAnimation.duration = self.indeterminateDuration;
            spinAnimation.repeatCount = HUGE_VALF;
            [self.layer addAnimation:spinAnimation forKey:@"indeterminateAnimation"];
        }
    } else {
        [self.layer removeAnimationForKey:@"indeterminateAnimation"];
    }
}

- (NSInteger)clockwiseProgress
{
    return self.circularProgressLayer.clockwiseProgress;
}

- (void)setClockwiseProgress:(NSInteger)clockwiseProgres
{
    self.circularProgressLayer.clockwiseProgress = clockwiseProgres;
    [self.circularProgressLayer setNeedsDisplay];
}

@end
