//
//  ViewController.m
//  runtimeDemo
//
//  Created by aoliday on 16/5/26.
//  Copyright © 2016年 aoliday. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@interface AClass : NSObject {
    
    NSString *_privateName;
}

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
}

- (void)testDynamicAddProperty {
    
    objc_property_attribute_t type = {"T","@\"NSString\""};
    objc_property_attribute_t ownership = {"C",""};
    objc_property_attribute_t backingivar = {"V",charName};
    objc_property_attribute_t attrs[] = {type,ownership,backingivar};
    
    class_addProperty([AClass class], "name", attrs, 3);
    class_addMethod([AClass class], @selector(name), (IMP)nameGetter, "@@:");
    class_addMethod([AClass class], @selector(setName:), (IMP)nameSetter, "v@:@");
    
    id  A = [[AClass alloc] init];
    NSLog(@"%@",[A name]);
    [A setName:@"Kobe Brainte"];
    NSLog(@"%@",[A name]);
    
}
@end

