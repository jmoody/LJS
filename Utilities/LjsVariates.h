// Copyright (c) 2010 Little Joy Software
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

//  Variates.h
//  iJson
//
//  Created by Joshua Moody on 12/27/10.


//NAME
//arc4random, arc4random_buf, arc4random_uniform, arc4random_stir,
//arc4random_addrandom - arc4 random number generator
//
//SYNOPSIS
//#include <stdlib.h>
//
//u_int32_t
//arc4random(void);
//
//void
//arc4random_buf(void *buf, size_t nbytes);
//
//u_int32_t
//arc4random_uniform(u_int32_t upper_bound);
//
//void
//arc4random_stir(void);
//
//void
//arc4random_addrandom(u_char *dat, int datlen);
//
//DESCRIPTION
//The arc4random() function provides a high quality 32-bit pseudo-random
//number very quickly.  arc4random() seeds itself on a regular basis from
//the kernel strong random number subsystem described in random(4).  On
//each call, an ARC4 generator is used to generate a new result.  The
//arc4random() function uses the ARC4 cipher key stream generator, which
//uses 8*8 8-bit S-Boxes.  The S-Boxes can be in about (2**1700) states.
//
//arc4random() fits into a middle ground not covered by other subsystems
//such as the strong, slow, and resource expensive random devices described
//in random(4) versus the fast but poor quality interfaces described in
//rand(3), random(3), and drand48(3).
//
//arc4random_buf() fills the region buf of length nbytes with ARC4-derived
//random data.
//
//arc4random_uniform() will return a uniformly distributed random number
//less than upper_bound.  arc4random_uniform() is recommended over
//constructions like ``arc4random() % upper_bound'' as it avoids "modulo
//bias" when the upper bound is not a power of two.
//
//The arc4random_stir() function reads data using sysctl(3) from
//kern.arandom and uses it to permute the S-Boxes via
//arc4random_addrandom().
//
//There is no need to call arc4random_stir() before using arc4random(),
//since arc4random() automatically initializes itself.
//
//RETURN VALUES
//These functions are always successful, and no return value is reserved to
//indicate an error.
//
//SEE ALSO
//rand(3), rand48(3), random(3)
//
//HISTORY
//An algorithm called RC4 was designed by RSA Data Security, Inc.  It was
//considered a trade secret.  Because it was a trade secret, it obviously
//could not be patented.  A clone of this was posted anonymously to USENET
//and confirmed to be equivalent by several sources who had access to the
//original cipher.  Because of the trade secret situation, RSA Data
//Security, Inc. could do nothing about the release of the `Alleged RC4'
//algorithm.  Since RC4 was trademarked, the cipher is now referred to as
//ARC4.
//
//These functions first appeared in OpenBSD 2.1.
//
//OpenBSD 4.8                    December 23, 2008                   OpenBSD 4.8

#import <Foundation/Foundation.h>


/**
 Uses the arc4random algorithm to produce pseudo random numbers.
 
 No manual seeding is required (or allowed) because arc4random self-seeds.
 
 arc4random_uniform does not seem to work with Cocoa, so we replace with our
 own logic avoiding using % (modulo) and regenerating random integers when we
 need to (about once every million or so calls).
 */
@interface LjsVariates : NSObject {}

/**
 Generates a random double from 0.0 to 1.0 inclusive - (0.0, 1.0) 
 @return a random double on (0.0, 1.0)
 */
+ (double) randomDouble;

+ (NSDecimalNumber *) randomDecimalDouble;

/**
 Generates a random double from min to max inclusive = (min, max)
 @param min the lowest value returned
 @param min the hightest value returned
 @return a random double on (min, max)
 */
+ (double) randomDoubleWithMin:(double) min max:(double) max;

+ (NSDecimalNumber *) randomDecimalDoubleWithMin:(NSDecimalNumber *) min
                                              max:(NSDecimalNumber *) max;


/**
 Generates a random integer between two large numbers.  I thought range was
 ( -(2^32) - 1, (2^32) -1 ), but I find the range to be much larger when I
 unit test.
 
 This is from the docs:  The arc4random() function provides a high quality 
                         32-bit pseudo-random number very quickly. 
 
 Suffice it to say that it produces a randomw integer between a very large
 negative integer and a very large positive integer.
 @return a very large positive or negative integer
 */
+ (NSInteger) randomInteger;

+ (NSDecimalNumber *) randomDecimalInteger;

/**
 Generates a random int from min to max inclusive = (min, max)
 
 This method will occassionally (once every tens of millions of calls) produce
 a number that is +1 larger than max.  When this happens, another random integer
 is produced until the result is less-or-equal to the max.  This is expected.
 
 @param min the lowest value returned
 @param min the hightest value returned
 @return a random int on (min, max)
 */
+ (NSInteger) randomIntegerWithMin:(NSInteger) min max:(NSInteger) max;

+ (NSDecimalNumber *) randomDecimalIntegerWithMin:(NSDecimalNumber *) min
                                              max:(NSDecimalNumber *) max;

/**
 randomly samples a number of elements from array using replacement
 @param array the array to sample
 @param number the number to sample
 @return an array with randomly sampled elements
 */
+ (NSArray *) sampleWithReplacement:(NSArray *) array number:(NSUInteger) number;


/**
 randomly samples a number of elements from array without replacement.
 if number > [array count], then this method returns nil.
 @param array the array to sample
 @param number the number to sample
 @return an array with randomly sampled elements
 */
+ (NSArray *) sampleWithoutReplacement:(NSArray *) array number:(NSUInteger) number;

/**
 a helper function for sampleWithoutReplacement.
 scans an array of NSNumbers to determine if 'number' is present.
 @param array the array to scan
 @param number the number to detect
 @return true iff number appears in the array as an NSNumber
 */
+ (BOOL) _arrayOfNSNumbers:(NSArray *) array containsInt:(NSUInteger) number;
  
/**
 returns a string of random alpha-numeric characters
 @param length the number of characters in the created string
 @return a string of random alpha-numeric characters
 */
+ (NSString *) randomStringWithLength:(NSUInteger) length;

@end
