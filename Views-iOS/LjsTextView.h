#import <Foundation/Foundation.h>

/**
 Documentation
 cribbed from
 http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
 */
@interface LjsTextView : UITextView 

/** @name Properties */
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

/** @name Initializing Objects */

/** @name Handling Notifications, Requests, and Events */
-(void) textDidChange:(NSNotification *) notification;

/** @name Utility */

@end
