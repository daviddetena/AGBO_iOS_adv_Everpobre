//
//  DTCEverpobreBaseClass.m
//  Everpobre
//
//  Created by David de Tena on 09/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCEverpobreBaseClass.h"

@implementation DTCEverpobreBaseClass

#pragma mark - Class methods
+(NSArray *) observableKeys{
    return @[];
}

#pragma mark - Lifecycle

-(void)awakeFromInsert{
    // Sólo una vez en la vida del objeto
    [super awakeFromInsert];
    
    // KVO (alta en notificaciones de cambio)
    [self setupKVO];
}


-(void)awakeFromFetch{
    // n-veces a lo largo de la vida del objeto
    [super awakeFromFetch];
    
    // KVO (alta en notificaciones de cambio)
    [self setupKVO];
}

-(void)willTurnIntoFault{
    // Cuando el objeto se vacía convirtiéndose en un fault.
    [super willTurnIntoFault];
    
    // Nos damos de baja en todas las notificaciones
    [self tearDownKVO];
    
}

#pragma mark - KVO
-(void)setupKVO{
    
    // Observamos todas las propiedades EXCEPTO modificationDate
    for (NSString *key in [[self class] observableKeys]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
    }
}

-(void)tearDownKVO{
    
    // Me doy de baja de todas las notificaciones
    for (NSString *key in [[self class] observableKeys]) {
        [self removeObserver:self forKeyPath:key];
    }
}


@end
