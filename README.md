##### `RACIndexSetSequence`作为`RACSequence`的子类，通过名字可以知道该类与`NSIndexSet`类有关系。

如果对`NSIndexSet`不了解的，可以先看下[这篇文章](https://www.jianshu.com/p/84a1d5296844)。

完整测试用例[在这里](https://github.com/jianghui1/TestRACIndexSetSequence)。

接下来对`.m`中的方法进行分析。
***

    + (instancetype)sequenceWithIndexSet:(NSIndexSet *)indexSet {
    	NSUInteger count = indexSet.count;
    	
    	if (count == 0) return self.empty;
    	
    	NSUInteger sizeInBytes = sizeof(NSUInteger) * count;
    
    	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:sizeInBytes];
    	[indexSet getIndexes:data.mutableBytes maxCount:count inIndexRange:NULL];
    
    	RACIndexSetSequence *seq = [[self alloc] init];
    	seq->_data = data;
    	seq->_indexes = data.bytes;
    	seq->_count = count;
    	return seq;
    }
初始化方法，根据`indexSet`的`count`来判断返回空序列还是indexSet序列。如果返回indexSet序列，通过`_indexes`保存`indexSet`的信息，完成初始化工作。

测试用例：

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
***

    + (instancetype)sequenceWithIndexSetSequence:(RACIndexSetSequence *)indexSetSequence offset:(NSUInteger)offset {
    	NSCParameterAssert(offset < indexSetSequence.count);
    
    	RACIndexSetSequence *seq = [[self alloc] init];
    	seq->_data = indexSetSequence.data;
    	seq->_indexes = indexSetSequence.indexes + offset;
    	seq->_count = indexSetSequence.count - offset;
    	return seq;
    }
也是一个初始化方法，通过参数`indexSetSequence` `offset`获取一个新的序列。

测试用例：

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
***

    - (id)head {
    	return @(self.indexes[0]);
    }
由于`indexes`存放着`indexSet`的索引信息，然后通过`0`获取到第一个索引值。

测试用例：

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
***

    - (RACSequence *)tail {
    	if (self.count <= 1) return [RACSequence empty];
    
    	return [self.class sequenceWithIndexSetSequence:self offset:1];
    }
如果索引值最多只有一个，就返回一个空序列；否则调用`sequenceWithIndexSetSequence:offset:`并指定`offset`为`1`。

测试用例：

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
***
关于 遍历、格式化日志的方法不再分析。

##### 综上，这个类的作用是将`NSIndexSet`存储的索引值可以用序列的方法处理。
