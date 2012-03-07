#import "UILabel+LjsAdditions.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation UILabel (UILabel_LjsAdditions)

+ (UILabel *) labelWithFrame:(CGRect) frame
                        text:(NSString *) aText
                        font:(UIFont *) aFont
                   alignment:(UITextAlignment) aAlignment
                   textColor:(UIColor *) aTextColor
            highlightedColor:(UIColor *) aHighlightedColor
             backgroundColor:(UIColor *) aBackgroundColor
               lineBreakMode:(UILineBreakMode) aLineBreakMode
               numberOfLines:(NSUInteger) aNumberOfLines {
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.text = aText;
  label.font = aFont;
  label.textAlignment = aAlignment;
  label.textColor = aTextColor;
  label.highlightedTextColor = aHighlightedColor;
  label.backgroundColor = aBackgroundColor;
  label.lineBreakMode = aLineBreakMode;
  label.numberOfLines = aNumberOfLines;
  return label;
}


@end
