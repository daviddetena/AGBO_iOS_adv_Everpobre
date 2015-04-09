//
//  AppDelegate.m
//  Everpobre
//
//  Created by David de Tena on 09/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTCoreDataStack.h"
#import "DTCNotebook.h"
#import "DTCNote.h"
#import "DTCNotebooksViewController.h"

@interface AppDelegate ()
@property (nonatomic,strong) AGTCoreDataStack *stack;
@end

@implementation AppDelegate

#pragma mark - App Lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Cremos una instancia del stack
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];
    
    // Creamos datos chorras
    [self createDummyData];
    
    // Creamos el Fetch Request => Búsqueda de todas las libretas
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[DTCNotebook entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DTCNotebookAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)],
                            [NSSortDescriptor sortDescriptorWithKey:DTCNotebookAttributes.modificationDate ascending:NO]];
    req.fetchBatchSize = 20;
    
    // Creamos el FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:nil
                                      cacheName:nil];
    
    // Creamos el controlador y lo metemos en un navigation controller
    DTCNotebooksViewController *nVC = [[DTCNotebooksViewController alloc]
                                       initWithFetchedResultsController:fc
                                       style:UITableViewStylePlain];
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:nVC];
    
    // Y lo mostramos en pantalla
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Utils
- (void) createDummyData{
    
    // Elimino datos anteriores
    [self.stack zapAllData];
    
    
    // Creamos nuevos objetos
    DTCNotebook *exs = [DTCNotebook notebookWithName:@"Ex-novias para el recuerdo"
                                             context:self.stack.context];
    
    [DTCNote noteWithName:@"Mariana Dávalos"
                 notebook:exs
                  context:self.stack.context];
    
    [DTCNote noteWithName:@"Camila Dávalos"
                 notebook:exs
                  context:self.stack.context];
    
    [DTCNote noteWithName:@"Pampita"
                 notebook:exs
                  context:self.stack.context];
    
    DTCNote *vega = [DTCNote noteWithName:@"María Teresa de la Vega"
                                 notebook:exs
                                  context:self.stack.context];
    
    NSLog(@"Una nota: %@",vega);
    
    // Buscar, ordenando por los criterios de nombre alfabético y de fecha de modificación más reciente
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[DTCNote entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:DTCNoteAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)],
                            [NSSortDescriptor sortDescriptorWithKey:DTCNoteAttributes.modificationDate ascending:NO]];
    // Número de resultados que devolverá en cada lote
    req.fetchBatchSize = 20;
    //Queremos todas las notas de la libreta exs
    req.predicate = [NSPredicate predicateWithFormat:@"notebook = %@",exs];
    
    // Ejecutamos la búsqueda guardando los resultados en un array (el método es de AGTCoreDataStack
    NSArray *results = [self.stack
                        executeFetchRequest:req
                        errorBlock:^(NSError *error) {
                            NSLog(@"Error al buscar! %@",error);
                        }];
    NSLog(@"Notas: %@",results);
    
    
    // Borrar (queda marcado como listo para ser destruido, ya no aparece en búsquedas)
    // Cuando se guarde (se haga commit) se aplicarán las validaciones y se llevarán a
    // cabo las operaciones pendientes (como por ejemplo, borrados)
    [self.stack.context deleteObject:vega];
    
    // Guardamos
    [self.stack saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar! %@",error);
    }];
}

@end
