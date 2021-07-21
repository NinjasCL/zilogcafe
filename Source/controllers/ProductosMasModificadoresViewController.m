//
//  ProductosMasModificadoresViewController.m
//  ZilogCafe
//
//  Created by Camilo on 07-10-13.
//
//

#import "ProductosMasModificadoresViewController.h"
#import "Product.h"
#import "Modifier.h"
#import "ModifierValue.h"

@interface ProductosMasModificadoresViewController ()

@end

@implementation ProductosMasModificadoresViewController

- (void) viewDidLoad:(BOOL)animated {
    //[self crearAgregarImagenesAProductos];
}

- (void) crearAgregarImagenesAProductos {
    Product * latte = [[Product alloc] init];
    // s5Y5JS1yOx Latte
    latte.objectId = @"s5Y5JS1yOx";
    

    //CoreImage * productPhoto = [[CoreImage alloc] init];
    
    UIImage * photo;
    
    photo = [UIImage imageNamed:@"latte.jpg"];

    
    NSData * imageData;
    
    imageData = UIImageJPEGRepresentation(photo, 100);
    
    
    PFFile * image;
    
    image = [PFFile fileWithData:imageData];
    
    //productPhoto.displayImage = image;
    
    latte.displayImage = image;
    
    // Expreso
    
    Product * espresso = [[Product alloc] init];
    
    espresso.objectId = @"SKHFmaY8rW";
    

    // CoreImage * productPhotoE = [[CoreImage alloc] init];
    
    UIImage * photoE;
    
    photoE = [UIImage imageNamed:@"espresso.jpg"];
    
    
    NSData * imageDataE;
    
    imageDataE = UIImageJPEGRepresentation(photoE, 100);
    
    
    PFFile * imageE;
    
    imageE = [PFFile fileWithData:imageDataE];
    
    //productPhotoE.displayImage = imageE;
    
    espresso.displayImage = imageE;
    
    // Capuchino
    
    Product * cappuccino = [[Product alloc] init];
    cappuccino.objectId = @"Q1VvNRH8Vz";
    
    //CoreImage * productPhotoC = [[CoreImage alloc] init];
    
    UIImage * photoC;
    
    photoC = [UIImage imageNamed:@"cappuccino.jpg"];
    
    
    NSData * imageDataC;
    
    imageDataC = UIImageJPEGRepresentation(photoC, 100);
    
    
    PFFile * imageC;
    
    imageC = [PFFile fileWithData:imageDataC];
    
    //productPhotoC.displayImage = imageC;
    
    cappuccino.displayImage = imageC;
    
    // Guardar
    [SVProgressHUD show];

    NSLog(@"Guardando");
    
    [latte save];
    [espresso save];
    [cappuccino save];

    [SVProgressHUD dismiss];
}

#pragma message "TODO: Crear Modificadores para Productos"
- (void) agregarModificadoresAProductos {
    
    // Latte
    
//    Product * latte = [[Product alloc] init];
//    latte.objectId = @"s5Y5JS1yOx";
//    
    // Cappuccino
    
    Product * cappuccino = [Product object];
    cappuccino.objectId = @"Q1VvNRH8Vz";
    

    Modifier * tipoLeche = [Modifier object];
    tipoLeche.objectId = @"xM7wQiTgEn";
    
    ModifierValue * lecheEntera = [ModifierValue object];
    
    lecheEntera.displayName = @"Leche Entera";
    lecheEntera.product = cappuccino;
    lecheEntera.price = 0;
    
    lecheEntera.isAdultsOnly = NO;
    lecheEntera.isAvailable = YES;
    lecheEntera.isEnabled = YES;
    
    [lecheEntera save];
    NSLog(@"Guardado leche entera");
    
    
    ModifierValue * lecheSemiDescremada = [ModifierValue object];
    
    lecheSemiDescremada.displayName = @"Leche Semi-Descremada";
    lecheSemiDescremada.product = cappuccino;
    lecheSemiDescremada.price = 0;
    
    lecheSemiDescremada.isAdultsOnly = NO;
    lecheSemiDescremada.isAvailable = YES;
    lecheSemiDescremada.isEnabled = YES;
    
    [lecheSemiDescremada save];
    NSLog(@"Guardado leche semidescremada");
    
    
    ModifierValue * lecheDescremada = [ModifierValue object];
    
    lecheDescremada.displayName = @"Leche Descremada";
    lecheDescremada.product = cappuccino;
    lecheDescremada.price = 0;
    
    lecheDescremada.isAdultsOnly = NO;
    lecheDescremada.isAvailable = YES;
    lecheDescremada.isEnabled = YES;
    
    [lecheDescremada save];
    NSLog(@"Guardado leche entera");
    
    
    ModifierValue * lecheSoya = [ModifierValue object];
    
    lecheSoya.displayName = @"Leche Soya";
    lecheSoya.product = cappuccino;
    lecheSoya.price = [NSNumber numberWithInt:200];
    
    lecheSoya.isAdultsOnly = NO;
    lecheSoya.isAvailable = YES;
    lecheSoya.isEnabled = YES;
    
    [lecheSoya save];
    NSLog(@"Guardado leche entera");
    
    [tipoLeche.values addObject:lecheEntera];
    [tipoLeche.values addObject:lecheSemiDescremada];
    [tipoLeche.values addObject:lecheDescremada];
    [tipoLeche.values addObject:lecheSoya];
    
    [tipoLeche save];
    
    NSLog(@"Guardado Tpo de Leche");
    
    

    
//
//    tipoLeche.displayName = @"Tipo de Leche";
//    tipoLeche.displayDescription = @"Que leche usar";
//    
//    tipoLeche.isEnabled = YES;
//    
//    tipoLeche.isRequired = YES;
//    
//    tipoLeche.isAdultsOnly = NO;
//    
//    tipoLeche.product = cappuccino;
//    
//    [tipoLeche save];
//    
//    NSLog(@"Creado Modificador Tipo Leche");
//    
//    
//    [cappuccino.modifiers addObject:tipoLeche];
//    
//    NSLog(@"Agregado a modificadores");
//    
//    [cappuccino save];
    
    
    
//    Modifier * tamanio = [Modifier object];
//    tamanio.objectId = @"gk8hNo5FDd";
    
    

    
//    ModifierValue * sencillo = [ModifierValue object];
//    
//    
//        sencillo.displayName = @"Sencillo";
//        sencillo.price = 0;
//        sencillo.product = cappuccino;
//    
//        sencillo.isEnabled = YES;
//        sencillo.isAvailable = YES;
//        sencillo.isAdultsOnly = NO;
//        sencillo.isEdible = NO;
//    //
//        [sencillo save];
//    
//    NSLog(@"Guardado Sencillo");
//    
//    ModifierValue * doble = [ModifierValue object];
//    //  doble.objectId = @"zRvc9EDWjS";
//    
//        doble.displayName = @"Doble";
//        doble.price = [NSNumber numberWithInt:300];
//        doble.product = cappuccino;
//    //
//        doble.isEnabled = YES;
//        doble.isAdultsOnly = NO;
//        doble.isAvailable = YES;
//        doble.isEdible = NO;
//    //
//        [doble save];
//    
//    NSLog(@"Guardado Dboe");
//
//        [tamanio.values addObject:sencillo];
//        [tamanio.values addObject:doble];
//    //    
//    //    
//        [tamanio save];
//    
//    NSLog(@"Guardado Modificador");

//    tamanio.displayName = @"Tamaño";
//    tamanio.controlType = @"kJUMPITTModifierControlTypeSingleSelectionShort";
//    tamanio.isAdultsOnly = NO;
//    tamanio.isEnabled = YES;
//    tamanio.isRequired = YES;
//    tamanio.displayDescription = @"Selección de Tamaño";
//    
//    [tamanio save];
//    
//    NSLog(@"Tamanio Guardado");
//    
//    [tamanio fetchIfNeeded];
//    
//    [cappuccino.modifiers addObject:tamanio];
//    
//    [cappuccino save];
//    
//    NSLog(@"Modificador Capuccino Guardado");
    
    // Expreso
    
//    Product * espresso = [[Product alloc] init];
//    espresso.objectId = @"SKHFmaY8rW";
    
//    Modifier * tamanio = [[Modifier alloc] init];
//    tamanio.objectId = @"4H2J22P0eI";
    
    
    
//    ModifierValue * sencillo = [[ModifierValue alloc] init];
//    sencillo.objectId = @"JwSAvFIVdr";
    
//    sencillo.displayName = @"Sencillo";
//    sencillo.price = 0;
//    sencillo.product = espresso;
//    
//    sencillo.isEnabled = YES;
//    sencillo.isAvailable = YES;
//    sencillo.isAdultsOnly = NO;
//    sencillo.isEdible = NO;
//    
//    [sencillo save];
    
//    ModifierValue * doble = [[ModifierValue alloc] init];
//    doble.objectId = @"zRvc9EDWjS";
    
//    doble.displayName = @"Doble";
//    doble.price = [NSNumber numberWithInt:300];
//    doble.product = espresso;
//    
//    doble.isEnabled = YES;
//    doble.isAdultsOnly = NO;
//    doble.isAvailable = YES;
//    doble.isEdible = NO;
//    
//    [doble save];
    
//    [tamanio.values addObject:sencillo];
//    [tamanio.values addObject:doble];
//    
//    
//    [tamanio save];
    
    
    
}

- (IBAction)execute:(id)sender {
    [self agregarModificadoresAProductos];

}


@end
