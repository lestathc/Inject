#import "Objection.h"

#import "AppDelegate.h"
#import "ViewController.h"


@interface ViewController (__Objection__Autogen__)
@end
@implementation ViewController (__Objection__Autogen__)
objection_requires(@"typedViewController",@"nonTypedViewController")
@end

@interface AppDelegate (__Objection__Autogen__)
@end
@implementation AppDelegate (__Objection__Autogen__)
objection_requires(@"abc",@"classA")
@end
