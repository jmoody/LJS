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


#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

/**
 Documentation
 */
@interface LjsLabelAttributes : NSObject

@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) NSUInteger numberOfLines;
@property (nonatomic, copy) NSString *string;
@property (nonatomic, assign) CGFloat labelWidth;
@property (nonatomic, assign) UILineBreakMode linebreakMode;
@property (nonatomic, strong) UIFont *font;

- (id) initWithString:(NSString *) aString
                 font:(UIFont *) aFont
           labelWidth:(CGFloat) aLabelWidth;

- (id) initWithString:(NSString *) aString
                 font:(UIFont *) aFont
           labelWidth:(CGFloat) aLabelWidth
        linebreakMode:(UILineBreakMode) aLinebreakMode
          minFontSize:(CGFloat) aMinFontSize;

- (void) applyAttributesToLabel:(UILabel *) aLabel
      shouldApplyWidthAndHeight:(BOOL) aShouldApplyWidthAndHeight;

- (UILabel *) labelWithFrame:(CGRect) aFrame
                   alignment:(UITextAlignment) aAlignemnt
                   textColor:(UIColor *) aTextColor
              highlightColor:(UIColor *) aHighlightColor
             backgroundColor:(UIColor *) aBackgroundColor;


+ (CGSize) sizeOfDetailsCellTitleLabel;
+ (CGSize) sizeOfDetailsCellDetailsLabel;
+ (CGFloat) heightOfDetailsCellTitleLabel;
+ (CGFloat) widthOfDetailsCellTitleLabel;
+ (CGFloat) heightOfDetailsCellDetailsLabel;
+ (CGFloat) widthOfDetailsCellDetailsLabel;
+ (CGRect) frameForDetailsCellTitleLabelWithX:(CGFloat) aX;
+ (CGRect) frameForDetailsCellDetailsLabelWithX:(CGFloat) aX;


@end

