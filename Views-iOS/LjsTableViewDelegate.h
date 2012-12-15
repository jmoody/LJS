// Copyright 2012 Recovery Warriors LLC. All rights reserved.
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

#import <Foundation/Foundation.h>

@class LjsLabelAttributes;

/**
 Documentation
 */
@protocol LjsTableViewDelegate <NSObject>

/** @name Required Methods */
@required
- (NSString *) tableView:(UITableView *) aTableView keyForIndexPath:(NSIndexPath *) aIndexPath;
- (NSString *) tableView:(UITableView *) aTableView reuseIdentifierAtIndexPath:(NSIndexPath *) aIndexPath;

- (NSString *) tableView:(UITableView *) aTableView accessibilityIdForRowAtIndexPath:(NSIndexPath *) aIndexPath;
- (NSUInteger) tableView:(UITableView *) aTableView tagForTitleLabelForRowAtIndexPath:(NSIndexPath *) aIndexPath;
- (NSString *) tableView:(UITableView *) aTableView titleForRowAtIndexPath:(NSIndexPath *) aIndexPath;
- (CGFloat) tableView:(UITableView *) aTableView widthOfTitleLabelAtIndexPath:(NSIndexPath *) aIndexPath;
- (LjsLabelAttributes *) tableView:(UITableView *) aTableView attributesForTitleAtIndexPath:(NSIndexPath *) aIndexPath;
- (UILabel *) tableView:(UITableView *) aTableView labelForTitleForRowAtIndexPath:(NSIndexPath *) aIndexPath;

- (NSString *) tableView:(UITableView *) aTableView accessibilityIdForHeaderAtSection:(NSUInteger) aSection;
- (NSUInteger) tableView:(UITableView *) aTableView tagForSectionHeaderAtSection:(NSUInteger) aSection;
- (LjsLabelAttributes *) tableView:(UITableView *) aTableView attributesForHeaderLabelAtSection:(NSUInteger) aSection;

- (NSString *) tableView:(UITableView *) aTableView accessibilityIdForFooterAtSection:(NSUInteger) aSection;
- (NSUInteger) tableView:(UITableView *) aTableView tagForSectionFooterAtSection:(NSUInteger) aSection;
- (LjsLabelAttributes *)tableView:(UITableView *) aTableView  attributesForFooterLabelAtSection:(NSUInteger) aSection;


/** @name Optional Methods */
@optional

@end
