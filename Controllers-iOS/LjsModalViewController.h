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

#import <UIKit/UIKit.h>
#import "UIViewController+ParentOrPresenting.h"

@class LjsModalViewController;

/**
 Provides a callback method that allows the presenter/owner of LjsModalViewController
 to ask its owner to be dismissed
 */
@protocol LjsModalWindowDismissDelegate <NSObject>

@required

/**
 a callback that allows the presenter/owner to call dismiss
 @param controller the controller that did finish
 */
- (void) controllerDidFinish:(LjsModalViewController *) controller;
@end


/**
 Intended an abstract class, LjsModalViewController provides a dismiss delegate.
 
 For capatibility across iOS 4 and 5, see the UIViewController+ParentOrPresenting
 category.
 */
@interface LjsModalViewController : UIViewController

/** @name Properties */

@property (nonatomic, unsafe_unretained) id<LjsModalWindowDismissDelegate> dismissDelegate;

/** @name Memory Management */

/**
 @return an initialized receiver
 @param nibNameOrNil the nib or nil
 @param nibBundleOrNil the nib bundle or nil
 @param aDismissDelegate the dismiss delegate
 */
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
       dismissDelegate:(id<LjsModalWindowDismissDelegate>) aDismissDelegate;

@end




