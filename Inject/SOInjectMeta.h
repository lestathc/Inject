
/**
 *  Follow macro defines the lifetime of property which will be injected.
 *  
 *  Usage:
 *  @InjectSingltonProperty ClassA *Inject(classA)
 *  @InjectProperty ClassB *Inject(classB)
 */
#define InjectStrongProperty property(strong, nonatomic)
#define InjectWeakProperty property(weak, nonatomic)
#define InjectSingltonProperty InjectWeakProperty
#define InjectProperty InjectStrongProperty
