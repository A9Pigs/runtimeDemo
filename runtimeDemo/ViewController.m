//
//  ViewController.m
//  runtimeDemo
//
//  Created by aoliday on 16/5/26.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "ViewController.h"

#import "AddIvarTest.h"
#import "PropertyTest.h"
#import "FunctionTest.h"
#import "IMPWithBlockTest.h"


#import "OperationQueueTest.h"

@interface ViewController ()

@end

@interface AClass : NSObject {
    
    NSString *_privateName;
}

@property int (*hehe)(char *);

@end

@implementation AClass

- (instancetype)init {
    
    if (self = [super init]) {
        
        _privateName = @"Kobe";
    }
    return self;
}
@end

const char *charName = "_privateName";

NSString * nameGetter(id instance, SEL cmd) {
    
    Ivar ivar = class_getInstanceVariable([instance class],charName);
    return object_getIvar(instance, ivar);
}

void nameSetter(id instance , SEL cmd , NSString *newName) {
    
    Ivar ivar = class_getInstanceVariable([instance class], charName);
    id oldName = object_getIvar(instance, ivar);
    if (oldName != newName) {
        
        object_setIvar(instance, ivar, [newName copy]);
    }
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取类实例的长度.
    size_t size = class_getInstanceSize([self class]);
    //size_t 实际是unsign long类型,使用%zu输出.
    NSLog(@"%zu",size);
    
    /*
     *4种动态添加属性的方式.
     * .associate.
     * .通过runtime添加Ivar.
     * .通过runtime添加Peoperty
     * .通过setValue:forUndefinedKey动态添加键值.
     * .请实现.//TODO: KOBE
     *
     */
    [self testDynamicAddProperty];
    
    [self testAddIvar];
    [self testProperty];
    [self testFunction];
    
    [self addClassDynamic];
    
    [self testIMPWithBlock];
    
    [OperationQueueTest test];
    
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_BEGIN
    [self performSelector:@selector(unrecginzedSelctorViewController) withObject:nil];
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_END
}

- (void)testDynamicAddProperty {
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t nonatomic = {"N",""};
    objc_property_attribute_t backingivar = {"V",charName};
    objc_property_attribute_t attrs[] = {type,ownership,nonatomic,backingivar};
    
    class_addProperty([AClass class], "name", attrs, 3);
    class_addMethod([AClass class], @selector(name), (IMP)nameGetter, "@@:");
    class_addMethod([AClass class], @selector(setName:), (IMP)nameSetter, "v@:@");
    
    id  A = [[AClass alloc] init];
    NSLog(@"%@",[A name]);
    [A setName:@"Kobe Brainte"];
    NSLog(@"%@",[A name]);
    
}


- (void)testAddIvar {
    
    [AddIvarTest new];
}

- (void)testProperty {
    
    [PropertyTest new];
}

- (void)testFunction {
    
    [FunctionTest new];
}

void methodIMP3(id self , SEL _cmd , NSString * name) {
    
    NSLog(@"this is IMP which has three arguments. and name is :%@",[NSString stringWithString:name]);
}

void methodIMP2(id self , SEL _cmd , NSString *name ,NSNumber * sex) {
    
    NSLog(@"the person sex is :%d , name is :%@",[sex boolValue],[NSString stringWithString:name]);
}

void IMPMultiParams(id self , SEL _cmd , NSString * para1 , NSNumber *para2 , NSInteger para3 , double para4) {
    
    NSLog(@"multiParameter is 1:%@ , 2:%@ , 3:%ld , 4:%.2f",para1,para2,para3,para4);
}

void metaClassMethodIMP(id self , SEL _cmd) {
    
    NSLog(@"this is class function...");
}

NSString *propertyDesc(id self , SEL _cmd) {
    
    Ivar ivar = class_getInstanceVariable([self class], "p2");
    
    return object_getIvar(self, ivar);
}

void descSetter(id self , SEL _cmd ,NSString * newDesc) {
    
    Ivar ivar = class_getInstanceVariable([self class], "p2");
    id desc = object_getIvar(self, ivar);
    if (desc != newDesc) {
        
        object_setIvar(self, ivar, newDesc);
    }
}

- (void)addClassDynamic {
    
    Class class = objc_allocateClassPair([NSObject class], "subObject", 0);
    Class metaClass = object_getClass(class);
    NSLog(@"class:%@ , metaClass:%@",class,metaClass);

    //添加方法.
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_BEGIN
        BOOL added = class_addMethod(class, @selector(dynamicClassMethod1:), (IMP)methodIMP3, "v@:@");
        if (added) {
            printf("函数 dynamicClassMethod1  添加成功,");
        }
        added = class_addMethod(class, @selector(dynamicClassMethod2::), (IMP)methodIMP2, "v@:@@");
        if (added) {
            printf("函数 dynamicClassMethod2  添加成功,");
        }
        class_addMethod(class, @selector(IMPMultiParams::::), (IMP)IMPMultiParams, "v@:@@Ld");
        
        added = class_addMethod(metaClass, @selector(classMethods), (IMP)metaClassMethodIMP, "v@:");
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_END
    if (added) {
        printf("类方法,添加成功.\n");
    }

    //添加变量.
    added = class_addIvar(class,"_dV1", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
    if (added) {
        printf("变量 _dV1  添加成功,");
    }
    
    added = class_addIvar(class, "_dV2", sizeof(NSNumber *), log2(sizeof(NSNumber *)), @encode(NSNumber *));
    if (added) {
        
        printf("变量 _dV2 添加成功,");
    }
    
    added = class_addIvar(class, "_dV3", sizeof(char *), log2(sizeof(char *)), "*");
    if (added) {
        
        printf("变量 _dV3 添加成功.\n");
    }
    //添加属性.
    objc_property_attribute_t type = {"T","@\"NSNumber\""};
    objc_property_attribute_t strong = {"&",""};
    objc_property_attribute_t nonatomic = {"N",""};
    objc_property_attribute_t name = {"V","number"};
    
    objc_property_attribute_t type1 = {"T","@\"NSString\""};
    objc_property_attribute_t name1 = {"V","desc"};
    
    objc_property_attribute_t attrs[] = {type,strong,nonatomic,name};
    objc_property_attribute_t attrs2[] = {type1,strong,nonatomic,name1};
    class_addProperty(class, "p1", attrs, 4);
    //动态修改p2的setter和getter方法.
    class_addProperty(class, "p2", attrs2, 4);
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_BEGIN
        class_addMethod(class, @selector(p2), (IMP)propertyDesc, "@@:");
        class_addMethod(class,@selector(setP2:),(IMP)descSetter,"v@:@");
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_END
    
    objc_registerClassPair(class);
    
    [AddIvarTest  logIvars:class];
    [PropertyTest logProperties:class];
    [FunctionTest logInstanceMethods:class];
    
    id instance = [class new];
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_BEGIN
        [instance performSelector:@selector(dynamicClassMethod1:) withObject:@"oneParameters"];
        [instance performSelector:@selector(dynamicClassMethod2::) withObject:@"Kobe" withObject:@(1)];
        objc_msgSend(instance ,@selector(IMPMultiParams::::),@"Kobe",@(18),1000,21.2);
        [[instance class] performSelector:@selector(classMethods)];
    PERFORMSELECTOR_IGNOR_LEAD_AND_UNDECLARED_END
    
}

- (void)testIMPWithBlock {
    
    [IMPWithBlockTest doTest];
}

@end

