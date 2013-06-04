// Copyright (c) 2010 Little Joy Software
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
 uses tail recursion to compute factorial of n
 @return the factorial of n (n!)
 @param n n
 */
+ (NSUInteger) factorial:(NSUInteger) n;

/**
 the helper for factorial function 
 @return accumulated n
 @param n n
 @param accumulator the accumulated value
 */
+ (NSUInteger) _factorialHelperWithN:(NSUInteger) n
                         accumulator:(NSUInteger) accumulator;

/**
 @return a random BOOL value
 */
+ (BOOL) flip;

/**
 @return a random BOOL with aProbabilty of YES
 @param aProbability the probability of a YES
 */
+ (BOOL) flipWithProbilityOfYes:(double) aProbability;
 
/**
 Discussion 
 e is the base of the natural logarithm (e = 2.71828...)
 k is the number of occurrences of an event — the probability of which is given by the function
 k! is the factorial of k
 λ is a positive real number, equal to the expected number of occurrences during the given interval. For instance, if the events occur on average 4 times per minute, and one is interested in the probability of an event occurring k times in a 10 minute interval, one would use a Poisson distribution as the model with λ = 10×4 = 40.
 As a function of k, this is the probability mass function. The Poisson distribution can be derived as a limiting case of the binomial distribution.
 @return a poission random value
 @param aK is the number of occurrences of an event — the probability of which is given by the function
 @param aLambda s a positive real number, equal to the expected number of occurrences during the given interval. For instance, if the events occur on average 4 times per minute, and one is interested in the probability of an event occurring k times in a 10 minute interval, one would use a Poisson distribution as the model with λ = 10×4 = 40.
 */
+ (double) possionWithK:(NSUInteger) aK
                 lambda:(double) aLambda;

/**
 Generates a random double from 0.0 to 1.0 inclusive - (0.0, 1.0) 
 @return a random double on (0.0, 1.0)
 */
+ (double) randomDouble;

/**
 Generates a random double.
 @return a random double 
*/
+ (NSDecimalNumber *) randomDecimalDouble;

/**
 Generates a random double from min to max inclusive = (min, max)
 @param min the lowest value returned
 @param max the hightest value returned
 @return a random double on (min, max)
 */
+ (double) randomDoubleWithMin:(double) min max:(double) max;


/**
 Generates a random double and returns it as an NSDecimalNumber.
 @param min the lowest value returned
 @param max the hightest value returned
 @return a random double on (min, max) wrapped in NSDecimalNumber
 */
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
 @return a positive or negative integer
 */
+ (NSInteger) randomInteger;

/**
 Generates a random integer and returns it as an NSDecimalNumber.
 @return a positive or negative integer wrapped as an NSDecimalNumber.
 @see randomInteger
 */
+ (NSDecimalNumber *) randomDecimalInteger;

/**
 Generates a random int from min to max inclusive = (min, max)
 
 This method will occassionally (once every tens of millions of calls) produce
 a number that is +1 larger than max.  When this happens, another random integer
 is produced until the result is less-or-equal to the max.  This is expected.
 
 @param min the lowest value returned
 @param max the hightest value returned
 @return a random int on (min, max)
 */
+ (NSInteger) randomIntegerWithMin:(NSInteger) min max:(NSInteger) max;

/**
 Generates a random int from min to max inclusive = (min, max)
 
 This method will occassionally (once every tens of millions of calls) produce
 a number that is +1 larger than max.  When this happens, another random integer
 is produced until the result is less-or-equal to the max.  This is expected.
 
 @param min the lowest value returned
 @param max the hightest value returned
 @return a random int on (min, max) wrapped in an NSDecimalNumber
*/
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
 if `number > array count`, then this method returns nil.
 @param array the array to sample
 @param number the number to sample
 @return an array with randomly sampled elements
 */
+ (NSArray *) sampleWithoutReplacement:(NSArray *) array number:(NSUInteger) number;

  
/**
 @return a random element from the array
 @param array the array to sample
 */
+ (id) randomElement:(NSArray *) array;

/**
 @return a shuffled array
 @param array the array to shuffle
 */
+ (NSArray *) shuffle:(NSArray *) array;

/**
 @return an integer on the range eg. (-1, 5) ==> 5
 @param aRange the range to sample
 */
+ (NSInteger) randomIntegerWithRange:(NSRange) aRange;

/**
 returns a string of random alpha-numeric characters
 @param length the number of characters in the created string
 @return a string of random alpha-numeric characters
 */
+ (NSString *) randomStringWithLength:(NSUInteger) length;

+ (NSString *) randomAsciiWithLengthMin:(NSUInteger) aMin
                              lenghtMax:(NSUInteger) aMax;


+ (NSDate *) randomDateBetweenStart:(NSDate *) aStart end:(NSDate *) aEnd;
 
@end
