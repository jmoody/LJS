// Copyright 2012 Little Joy Software. All rights reserved.
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

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation UIImageView (UIImageView_LjsAdditions)

+ (UIImageView *) imageViewWithFrame:(CGRect) aFrame
                               image:(UIImage *) aImage {
  UIImageView *result = [[UIImageView alloc] initWithFrame:aFrame];
  result.image = aImage;
  return result;
}

+ (UIImageView *) imageViewWithImage:(UIImage *)aImage 
              centeredInRectWithSize:(CGSize)aSize {
  return [UIImageView imageViewWithImage:aImage
                 centeredInRectWithWidth:aSize.width
                                  height:aSize.height];
}

+ (UIImageView *) imageViewWithImage:(UIImage *) aImage
             centeredInRectWithWidth:(CGFloat)aWidth 
                              height:(CGFloat)aHeight {               
  CGSize imageSize = aImage.size;
  CGFloat w = imageSize.width;
  CGFloat h = imageSize.height;
  CGFloat x = (aWidth/2) - (w/2);
  CGFloat y = (aHeight/2) - (h/2);
  CGRect frame = CGRectMake(x, y, w, h);
  return [UIImageView imageViewWithFrame:frame image:aImage];
}

+ (UIImageView *) imageViewWithImage:(UIImage *) aImage
                         withOriginX:(CGFloat) aOriginX
            centeredInRectWithHeight:(CGFloat) aHeight {
  CGSize imageSize = aImage.size;
  CGFloat w = imageSize.width;
  CGFloat h = imageSize.height;
  CGFloat y = (aHeight/2) - (h/2);
  CGRect frame = CGRectMake(aOriginX, y, w, h);
  return [UIImageView imageViewWithFrame:frame image:aImage];
}

+ (UIImageView *) imageViewWithImage:(UIImage *) aImage
                         withOriginY:(CGFloat) aOriginY
             centeredInRectWithWidth:(CGFloat) aWidth {
  CGSize imageSize = aImage.size;
  CGFloat w = imageSize.width;
  CGFloat h = imageSize.height;
  CGFloat x = (aWidth/2) - (w/2);
  CGRect frame = CGRectMake(x, aOriginY, w, h);
  return [UIImageView imageViewWithFrame:frame image:aImage];
}

@end
