#import "MemorySwizzle.h"
#import <objc/runtime.h>

@implementation Memory

typedef enum ActionType : NSUInteger {
  kRetain,
  kRelease,
  kDealloc
} ActionType;

NSMutableDictionary *globalStack = nil;

+ (void)load {
  [Memory exchange];
}

+ (void)exchange {
  SEL retainSEL = NSSelectorFromString(@"retain");
  Method retainOriginal = class_getInstanceMethod([self class], retainSEL);
  
  SEL retainNewSEL = NSSelectorFromString(@"retainNew");
  Method retainNew = class_getInstanceMethod([self class], retainNewSEL);
  
  method_exchangeImplementations(retainOriginal, retainNew);
  
  SEL releaseSEL = NSSelectorFromString(@"release");
  Method releaseOriginal = class_getInstanceMethod([self class], releaseSEL);
  
  SEL releaseNewSEL = NSSelectorFromString(@"releaseNew");
  Method releaseNew = class_getInstanceMethod([self class], releaseNewSEL);
  
  method_exchangeImplementations(releaseOriginal, releaseNew);
}

-(void)releaseNew {
  SEL bReleaseSEL = NSSelectorFromString(@"releaseNew");
  Method bRelease = class_getInstanceMethod(NSClassFromString(@"Memory"), bReleaseSEL);
  IMP releaseIMP = method_getImplementation(bRelease);
  
  if ([self conformsToProtocol:@protocol(MemoryProtocol)]) {
    [self track: kRelease];
  }
  
  void (*callableImp)(id, SEL) = (typeof(callableImp))releaseIMP;
  callableImp(self, bReleaseSEL);
}

-(void)retainNew {
  SEL bRetainSEL = NSSelectorFromString(@"retainNew");
  Method bRetain = class_getInstanceMethod(NSClassFromString(@"Memory"), bRetainSEL);
  IMP retainIMP = method_getImplementation(bRetain);
  
  if ([self conformsToProtocol:@protocol(MemoryProtocol)]) {
    [self track: kRetain];
  }
  
  void (*callableImp)(id, SEL) = (typeof(callableImp))retainIMP;
  callableImp(self, bRetainSEL);
}

-(void)track:(ActionType)action {
  NSArray *array = [NSThread callStackSymbols];
  if (globalStack == nil) { globalStack = [[NSMutableDictionary alloc] init]; }
  
  NSString *stackName = array[2];
  NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:@"\\$(.*)\\s\\+"
                                                                         options: NSRegularExpressionDotMatchesLineSeparators
                                                                           error: nil];
  NSTextCheckingResult *result = [expression firstMatchInString: stackName
                                                        options: NSRegularExpressionDotMatchesLineSeparators
                                                          range: NSMakeRange(0, [stackName length])];
  
  NSString *name = [stackName substringWithRange:[result range]];
  NSString *className = NSStringFromClass([self class]);
  
  NSMutableDictionary *value = [globalStack valueForKey: className];
  if (value == nil) {
    [globalStack setObject:[[NSMutableDictionary alloc] initWithDictionary:@{name: @0}] forKey: className];
  } else {
    NSNumber *retainValue = [value valueForKey: name];
    if (retainValue == nil) {
      retainValue = @0;
    }
    
    if (action == kRelease) {
      retainValue = [[NSNumber alloc] initWithInteger: retainValue.intValue - 1];
    } else if (action == kRetain) {
      retainValue = [[NSNumber alloc] initWithInteger: retainValue.intValue + 1];
    } else if (action == kDealloc) {
      retainValue = [[NSNumber alloc] initWithInteger: 0];
    }
    
    [value setValue:retainValue forKey:name];
    [globalStack setObject:value forKey:className];
  }
}

-(void)dealloc {
  if ([self conformsToProtocol:@protocol(MemoryProtocol)]) {
    [self track: kDealloc];
  }
}

@end
