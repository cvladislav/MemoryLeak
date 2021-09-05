#import <Foundation/Foundation.h>

#ifndef MemorySwizzle_h
#define MemorySwizzle_h

@protocol MemoryProtocol <NSObject>

@end

@interface Memory : NSObject <MemoryProtocol>

extern NSMutableDictionary *globalStack;

@end

#endif /* MemorySwizzle_h */
