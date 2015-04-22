#import "Objection.h"

#import "AppDelegate.h"
#import "ViewController.h"


@interface ViewController (__Objection__Autogen__)
@end
@implementation ViewController (__Objection__Autogen__)
objection_requires(@"typedViewController",@"nonTypedViewController",@"classA",@"classB",@"classC",@"classCF",@"classD")
@end

@interface InjectableClassC (__Objection__Autogen__)
@end
@implementation InjectableClassC (__Objection__Autogen__)
objection_requires(@"classA",@"classB")
@end
