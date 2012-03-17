// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "LjsPanAndZoomImageView.h"
#import "Lumberjack.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+LjsAdditions.h"
#import "UIView+LjsAdditions.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface LjsPanAndZoomImageView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL shouldHandleLeftRightSwipes;
@property (nonatomic, assign) SEL leftSwipeHandler;
@property (nonatomic, assign) SEL rightSwipeHandler;
@property (nonatomic, assign) id swipeHandlerTarget;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *oneXZoom;


/** @name Handling Notifications, Requests, and Events */
- (void) handleOneFingerDoubleTap:(UITapGestureRecognizer *)recognizer;
- (void) handleTwoFingerTap:(UITapGestureRecognizer *)recognizer;

/** @name Configure */
- (void) resetViewBounds;

- (NSString *) keyForZoomScale:(CGFloat) aZoomScale;

@end

@implementation LjsPanAndZoomImageView

@synthesize imageView;
@synthesize shouldHandleLeftRightSwipes;
@synthesize leftSwipeHandler;
@synthesize rightSwipeHandler;
@synthesize swipeHandlerTarget;
@synthesize image;
@synthesize oneXZoom;


#pragma mark Memory Management
- (void) dealloc {
  DDLogDebug(@"deallocating %@", [self class]);
  self.swipeHandlerTarget = nil;
}

- (id) initWithFrame:(CGRect) frame 
    leftSwipeHandler:(SEL) aLeftSwipeHandler 
   rightSwipeHandler:(SEL) aRightSwipeHandler 
  swipeHandlerTarget:(id) aSwipHandlerTarget 
               image:(UIImage *) aImage {
  self = [super initWithFrame:frame];
  if (self) {
    self.shouldHandleLeftRightSwipes = YES;
    self.leftSwipeHandler = aLeftSwipeHandler;
    self.rightSwipeHandler = aRightSwipeHandler;
    self.swipeHandlerTarget = aSwipHandlerTarget;
    self.image = aImage;
    self.imageView = nil;
    self.oneXZoom = @"1.0";
    [self awakeFromNib];
  }
  return self;
}

- (void) awakeFromNib {
  DDLogDebug(@"awake from nib");
  self.delegate = self;
  self.showsHorizontalScrollIndicator = YES;
  self.scrollsToTop = NO;
  self.scrollEnabled = YES;
  self.imageView = [[UIImageView alloc] initWithImage:self.image];
  [self addSubview:self.imageView];
  
  
  [self resetViewBounds];
  
  if (self.shouldHandleLeftRightSwipes == YES) {
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] 
                                                      initWithTarget:self.swipeHandlerTarget
                                                      action:self.rightSwipeHandler];
    
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRightRecognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:swipeRightRecognizer];
    
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] 
                                                     initWithTarget:self.swipeHandlerTarget 
                                                     action:self.leftSwipeHandler];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeftRecognizer setNumberOfTouchesRequired:1];
    
    [self addGestureRecognizer:swipeLeftRecognizer];
  }
  
  UITapGestureRecognizer *oneFingerDoubleTapRecognizer = [[UITapGestureRecognizer alloc] 
                                                       initWithTarget:self 
                                                       action:@selector(handleOneFingerDoubleTap:)];
  oneFingerDoubleTapRecognizer.numberOfTapsRequired = 2;
  oneFingerDoubleTapRecognizer.numberOfTouchesRequired = 1;
  [self addGestureRecognizer:oneFingerDoubleTapRecognizer];
  
  UITapGestureRecognizer *twoFingerSingleTapRecognizer = [[UITapGestureRecognizer alloc] 
                                                    initWithTarget:self 
                                                    action:@selector(handleTwoFingerTap:)];
  twoFingerSingleTapRecognizer.numberOfTapsRequired = 1;
  twoFingerSingleTapRecognizer.numberOfTouchesRequired = 2;
  [self addGestureRecognizer:twoFingerSingleTapRecognizer];
  
}

#pragma mark Actions


/** @name Handling Notifications, Requests, and Events */
- (void) handleOneFingerDoubleTap:(UITapGestureRecognizer *)recognizer {
  DDLogDebug(@"handle one finger double tap");
  CGPoint pointInView = [recognizer locationInView:self.imageView];
  
  CGFloat newZoomScale = self.zoomScale * 1.5f;
  newZoomScale = MIN(newZoomScale, self.maximumZoomScale);
  
  CGSize scrollViewSize = self.bounds.size;
  CGFloat w = scrollViewSize.width / newZoomScale;
  CGFloat h = scrollViewSize.height / newZoomScale;
  CGFloat x = pointInView.x - (w / 2.0f);
  CGFloat y = pointInView.y - (h / 2.0f);
  CGRect rectToZoomTo = CGRectMake(x, y, w, h);
  [self zoomToRect:rectToZoomTo animated:YES];
}

- (void) handleTwoFingerTap:(UITapGestureRecognizer *)recognizer {
  DDLogDebug(@"handle two finger tap");
  CGFloat newZoomScale = self.zoomScale / 1.5f;
  newZoomScale = MAX(newZoomScale, self.minimumZoomScale);
  [self setZoomScale:newZoomScale animated:YES];
}


/** @name Utility */

- (NSString *) keyForZoomScale:(CGFloat) aZoomScale {
  NSString *result = [NSString stringWithFormat:@"%.3f", aZoomScale];
  return result;
}


- (void) zoomTo1x {
  [self resetViewBounds];
  [self configureScrollViewScales];
  [self centerScrollViewContents];
}

- (BOOL) isAt1xZoom {
  NSString *zStr = [self keyForZoomScale:self.zoomScale];
  BOOL result = [self.oneXZoom isEqualToString:zStr];
//  DDLogDebug(@"%.5f ==> %@ ? %@", self.zoomScale, zStr, self.oneXZoom);
  return result;
}

- (void) updateWithImage:(UIImage *)aImage {
  self.image = aImage;
  self.imageView.image = self.image;
  [self resetViewBounds];
  [self configureScrollViewScales];
  [self centerScrollViewContents];
}

- (void) resetViewBounds {
  DDLogDebug(@"reset view bounds");
  CGSize size = self.image.size;
  self.imageView.bounds = CGRectMake(0,0,size.width, size.height);
  self.contentSize = image.size;
}

- (void) centerScrollViewContents {
  CGSize boundsSize = self.bounds.size;
  CGRect contentsFrame = self.imageView.frame;
  
  if (contentsFrame.size.width < boundsSize.width) {
    contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
  } else {
    contentsFrame.origin.x = 0.0f;
  }
  
  if (contentsFrame.size.height < boundsSize.height) {
    contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
  } else {
    contentsFrame.origin.y = 0.0f;
  }
  
  self.imageView.frame = contentsFrame;
}

- (void) configureScrollViewScales {
  CGRect scrollViewFrame = self.frame;
  CGFloat scaleWidth = scrollViewFrame.size.width / self.contentSize.width;
  CGFloat scaleHeight = scrollViewFrame.size.height / self.contentSize.height;
  CGFloat minScale = MIN(scaleWidth, scaleHeight);
  self.minimumZoomScale = minScale * 0.5;
  self.maximumZoomScale = 5.0f;
  self.zoomScale = minScale;  
  self.oneXZoom = [self keyForZoomScale:minScale];
}

/** @name Scroll View Delegate */

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView {
  return self.imageView;
}

- (void) scrollViewDidZoom:(UIScrollView *) scrollView {
  DDLogDebug(@"scroll view did zoom: %.2f", self.zoomScale);
//  if (self.zoomScale != 1.0) {
//    self.scrollEnabled = NO;
//  } else {
//    self.scrollEnabled = YES;
//  }
  [self centerScrollViewContents];
}

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  return NO;
}


@end
