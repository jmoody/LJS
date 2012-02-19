//
//  LoremIpsum.h
//
//  Created by dav on 12/24/10.
//  Public domain where appropriate; free for everyone, for all usages, elsewhere.
//
// modified by joshua @ littlejoysoftware

#import <Foundation/Foundation.h>

@interface LoremIpsum : NSObject

@property (nonatomic, strong) NSArray *loremIpsumWords;

- (NSString*) words:(NSUInteger)count;
- (NSString *) characters:(NSUInteger) count;
- (NSString*) sentences:(NSUInteger)count;

@end
