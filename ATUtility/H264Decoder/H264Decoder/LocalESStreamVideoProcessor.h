//
//  LocalESStreamVideoProcessor.h
//  H264DecoderForiOS
//
//  Created by arvin.tan on 2/25/16.
//  Copyright © 2016 arvin.tan. All rights reserved.
//

#import "BaseVideoPreprocessor.h"

@interface LocalESStreamVideoProcessor : BaseVideoPreprocessor

@property (copy, nonatomic) NSString *filePath;

- (instancetype)initWithFilePath:(NSString *)filePath;

- (void)startProcess;

@end
