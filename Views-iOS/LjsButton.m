// Copyright 2011 Little Joy Software. All rights reserved.
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

#import "LjsButton.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LjsButton

@synthesize _highColor;
@synthesize _lowColor;
@synthesize gradientLayer;


- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self != nil) {
    [self awakeFromNib];
  }
  return self;
}

- (void)awakeFromNib {
  // Initialize the gradient layer
  CAGradientLayer *aGradientLayer = [[CAGradientLayer alloc] init];
  self.gradientLayer = aGradientLayer;
  
  // Set its bounds to be the same of its parent
  [gradientLayer setBounds:[self bounds]];
  // Center the layer inside the parent layer
  [gradientLayer setPosition:CGPointMake([self bounds].size.width/2,
                                         [self bounds].size.height/2)];
  
  // Insert the layer at position zero to make sure the 
  // text of the button is not obscured
  [[self layer] insertSublayer:gradientLayer atIndex:0];
  
  // Set the layer's corner radius
  [[self layer] setCornerRadius:8.0f];
  // Turn on masking
  [[self layer] setMasksToBounds:YES];
  // Display a border around the button 
  [[self layer] setBorderWidth:0.0];

  self.showsTouchWhenHighlighted = YES;
}

- (void)drawRect:(CGRect)rect {
  if (_highColor && _lowColor) {
    // Set the colors for the gradient to the 
    // two colors specified for high and low
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[_highColor CGColor], 
                              (id)[_lowColor CGColor], nil]];
  }
  [super drawRect:rect];
}

- (void) setHighColor:(UIColor *) aColor {
  // Set the high color and repaint
  self._highColor = aColor;
  [[self layer] setNeedsDisplay];
}

- (void) setLowColor:(UIColor * ) aColor {
  // Set the low color and repaint
  self._lowColor = aColor;
  [[self layer] setNeedsDisplay];
}

@end
