// Copyright 2011 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
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

/*
 Cribbed from http://www.cimgf.com/2010/01/28/fun-with-uibuttons-and-core-animation-layers/
 
 Many thanks.
 */
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface LjsButton : UIButton

@property (nonatomic, strong) UIColor *_highColor;
@property (nonatomic, strong) UIColor *_lowColor;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) BOOL isOn;


- (void) setHighColor:(UIColor *) aColor;
- (void) setLowColor:(UIColor * ) aColor;

- (void) setHighColor:(UIColor *) highColor
             lowColor:(UIColor *) lowColor;

- (void) setBorderColor:(UIColor *) color 
            borderWidth:(CGFloat) width 
           cornerRadius:(CGFloat) radius;

- (void) setIsOnImage:(UIImage *)isOnImage 
           isOffImage:(UIImage *) isOffImage;

- (void) toggle;
- (void) setState:(BOOL) aIsOn;

- (void) resetBounds;

- (void) setNormalAndHiglightedTitleWithFont:(UIFont *) aFont
                                       color:(UIColor *) aColor
                                       title:(NSString *) aTitle;



@end
