//
//  TestRACIndexSetSequenceTests.m
//  TestRACIndexSetSequenceTests
//
//  Created by ys on 2018/8/16.
//  Copyright © 2018年 ys. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <ReactiveCocoa.h>
#import <RACIndexSetSequence.h>
#import "RACIndexSetSequence+MyPrivate.h"

@interface TestRACIndexSetSequenceTests : XCTestCase

@end

@implementation TestRACIndexSetSequenceTests

- (void)test_sequenceWithIndexSet
{
    RACIndexSetSequence *sequence = [RACIndexSetSequence sequenceWithIndexSet:[NSIndexSet indexSetWithIndex:1]];
    NSLog(@"sequenceWithIndexSet -- %@", sequence);
    NSLog(@"sequenceWithIndexSet -- %@", sequence.head);
    NSLog(@"sequenceWithIndexSet -- %@", sequence.tail.head);
    
    // 打印日志；
    /*
     2018-08-16 17:58:09.695653+0800 TestRACIndexSetSequence[18761:17127607] sequenceWithIndexSet -- <RACIndexSetSequence: 0x604000250f50>{ name = , indexes = 1 }
     2018-08-16 17:58:09.696250+0800 TestRACIndexSetSequence[18761:17127607] sequenceWithIndexSet -- 1
     2018-08-16 17:58:09.696531+0800 TestRACIndexSetSequence[18761:17127607] sequenceWithIndexSet -- (null)
     */
}

- (void)test_sequenceWithIndexSetSequence
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    RACIndexSetSequence *sequence1 = [RACIndexSetSequence sequenceWithIndexSet:set];
    RACIndexSetSequence *sequence2 = [RACIndexSetSequence sequenceWithIndexSetSequence:sequence1 offset:2];
    NSLog(@"sequenceWithIndexSetSequence -- %@ -- %@ -- %@", sequence1, sequence1.head, sequence1.tail);
    NSLog(@"sequenceWithIndexSetSequence -- %@ -- %@ -- %@", sequence2, sequence2.head, sequence2.tail);
    
    // 打印日志：
    /*
     2018-08-16 18:03:26.545363+0800 TestRACIndexSetSequence[18992:17143794] sequenceWithIndexSetSequence -- <RACIndexSetSequence: 0x60400044d350>{ name = , indexes = 0, 1, 2 } -- 0 -- <RACIndexSetSequence: 0x60400044d260>{ name = , indexes = 1, 2 }
     2018-08-16 18:03:26.547246+0800 TestRACIndexSetSequence[18992:17143794] sequenceWithIndexSetSequence -- <RACIndexSetSequence: 0x60400044d200>{ name = , indexes = 2 } -- 2 -- <RACEmptySequence: 0x60400001e7c0>{ name =  }

     */
}

- (void)test_head
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    RACIndexSetSequence *sequence = [RACIndexSetSequence sequenceWithIndexSet:set];
    NSLog(@"head -- %@ -- %@", sequence, sequence.head);
    
    // 打印日志：
    /*
     2018-08-16 18:05:13.159825+0800 TestRACIndexSetSequence[19078:17149555] head -- <RACIndexSetSequence: 0x604000255150>{ name = , indexes = 0, 1, 2 } -- 0
     */
}

- (void)test_tail
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    RACIndexSetSequence *sequence = [RACIndexSetSequence sequenceWithIndexSet:set];
    NSLog(@"tail -- %@ -- %@", sequence, sequence.tail);
    
    // 打印日志：
    /*
     2018-08-16 18:06:40.614784+0800 TestRACIndexSetSequence[19156:17154407] tail -- <RACIndexSetSequence: 0x604000256cb0>{ name = , indexes = 0, 1, 2 } -- <RACIndexSetSequence: 0x604000257460>{ name = , indexes = 1, 2 }
     */
}


@end
