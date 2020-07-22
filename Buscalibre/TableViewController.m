//
//  TableViewController.m
//  buscalibre
//
//  Created by Mauro on 18-04-18.
//  Copyright © 2018 Magnet. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "AFNetworking.h"
#import <UNIRest.h>


static NSString * const BaseURL = @"https://www.buscalibre.cl";
static NSString * const BaseLimit = @"5";

@interface TableViewController ()
{
    NSArray *devimages;
    NSString *testString;
    NSMutableArray *list;
}
@end

@implementation TableViewController

- (IBAction)Volver:(id)sender {
[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Set values
    self.navigationItem.title = @"Novedades Top";
    self.listCategoryKey = @"Novedades top";
    
    if ([self.listCategory isEqualToString:@"showVendidos"])
    {
        self.navigationItem.title = @"Libros Más Vendidos";
        self.listCategoryKey = @"Libros Más Vendidos";
        
    }
    
    
    
    UIActivityIndicatorView * activityindicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.parentViewController.view.frame.size.width/2 - 10, self.parentViewController.view.frame.size.height/2 - 30, 20, 20)];
    [activityindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityindicator setColor:[UIColor orangeColor]];
    [self.view addSubview:activityindicator];
    [activityindicator startAnimating];
    self.indicator = activityindicator;
    
    list =  [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    NSDictionary *headers = @{@"accept": @"application/json"};
    NSDictionary *params = @{@"asJSON": @"1", @"token": @"5d2cb6d90d3914a280b0131820c767fc", @"limit":BaseLimit, @"offset":@"0"};
    
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:BaseURL];
        [request setHeaders:headers];
        [request setParameters:params];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response.rawBody
                                                             options:kNilOptions
                                                               error:nil];
        for ( NSMutableDictionary *dic in json[@"module"]) {
            
            if([json[@"module"][dic][@"title"]  isEqual: self.listCategoryKey]){
                list =  [[NSMutableArray alloc]init];
                int count = 0;
                for (NSMutableDictionary * _dic in json[@"module"][dic][@"product"])
                {
                    NSMutableDictionary * dic2 = [_dic mutableCopy];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic2[@"image"]]]];
                    
                    [dic2 setObject:image forKey:@"image"];
                    [list addObject:dic2];
                    count++;
//                    NSLog(@"libro %@", dic2[@"title"]);
//                    NSLog(@"count %i", count);
                }
                self.currentIndexList = count;
                break;
                
            }else{
                // Si no hay novedades acumula los libros en list
                for ( NSDictionary * _dic in json[@"module"][dic][@"product"]) {
                    NSMutableDictionary * dic2 = [_dic mutableCopy];
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic2[@"image"]]]];
                    [dic2 setObject:image forKey:@"image"];
                    [list addObject:dic2];
                }
            }
        }
    
       [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            [self.tableView reloadData];
            
            activityindicator.hidden = YES;
            [activityindicator stopAnimating];

        });
        
    }];
    

    

}
    
    


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return list.count;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        //NSLog(@"aca");
        //[self addRows:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addRows:scrollView];
}


- (void)addRows:(UIScrollView *)scrollView {

    CGRect r = [self.indicator frame];
    //r.origin.y = scrollView.contentSize.height - self.indicator.frame.size.height;
    r.origin.y = scrollView.contentSize.height - self.view.frame.size.height/2;
    [self.indicator setFrame:r];
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    NSLog(@"traer desde offset %i", self.currentIndexList);
    NSString* currentOffset = [NSString stringWithFormat:@"%i", self.currentIndexList];
    
    NSDictionary *headers = @{@"accept": @"application/json"};
    NSDictionary *params = @{@"asJSON": @"1", @"token": @"5d2cb6d90d3914a280b0131820c767fc", @"limit":BaseLimit, @"offset":currentOffset};
    
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:BaseURL];
        [request setHeaders:headers];
        [request setParameters:params];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response.rawBody
                                                             options:kNilOptions
                                                               error:nil];
        
        
        for ( NSMutableDictionary *dic in json[@"module"]) {
            if([json[@"module"][dic][@"title"]  isEqual: self.listCategoryKey]){
                //int count = self.currentIndexList;
                if(json[@"module"][dic][@"product"]){
                    for (NSMutableDictionary * _dic in json[@"module"][dic][@"product"]) {
                    
                        NSMutableDictionary * dic2 = [_dic mutableCopy];
                        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:dic2[@"image"]]]];
                    
                        [dic2 setObject:image forKey:@"image"];
                        [list addObject:dic2];
                        
                        
//                      NSLog(@"libro %@", dic2[@"title"]);
//                      NSLog(@"count %i", self.currentIndexList);
                    

                    }
                
                }
                self.currentIndexList = self.currentIndexList + 5;
                //self.currentIndexList = count;
                
            }
        }
        
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            [self.tableView reloadData];
            
            self.indicator.hidden = YES;
            [self.indicator stopAnimating];
            
        });
        
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    //cell.ItemTitle.text = [list[indexPath.row] objectForKey:@"title"];
    

    NSString *Dcto = [[list[indexPath.row] objectForKey:@"discount"] stringValue];
    NSString *str = [NSString stringWithFormat: @"%@%% Dcto.", Dcto];
    cell.ItemDcto.text = str;
    
    NSInteger DctoInt = [Dcto integerValue];
    
    if (DctoInt <= 10)
    {
        cell.ItemDcto.backgroundColor = [UIColor colorWithRed:0.98 green:0.93 blue:0.14 alpha:1.0];
        cell.ItemDcto.textColor = [UIColor blackColor];
    }else if(DctoInt <= 20){
        cell.ItemDcto.backgroundColor = [UIColor colorWithRed:0.05 green:0.54 blue:0.27 alpha:1.0];
        cell.ItemDcto.textColor = [UIColor whiteColor];
    }else if(DctoInt <= 30){
        cell.ItemDcto.backgroundColor = [UIColor colorWithRed:0.24 green:0.58 blue:0.74 alpha:1.0];
        cell.ItemDcto.textColor = [UIColor whiteColor];
    }else if(DctoInt <= 40){
        cell.ItemDcto.backgroundColor = [UIColor colorWithRed:0.84 green:0.08 blue:0.46 alpha:1.0];
        cell.ItemDcto.textColor = [UIColor whiteColor];
    }else if(DctoInt <= 50){
        cell.ItemDcto.backgroundColor = [UIColor colorWithRed:0.89 green:0.12 blue:0.15 alpha:1.0];
        cell.ItemDcto.textColor = [UIColor whiteColor];
    }else if(DctoInt <= 60){
        cell.ItemDcto.backgroundColor = [UIColor colorWithRed:0.58 green:0.00 blue:1.00 alpha:1.0];
        cell.ItemDcto.textColor = [UIColor whiteColor];
    }
    
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[list[indexPath.row] objectForKey:@"list_price"]];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    cell.ItemListPrice.attributedText = attributeString;
    
    cell.ItemAutor.text = @"";
    if(![[list[indexPath.row] objectForKey:@"author"] isEqual:[NSNull null]]){
        cell.ItemAutor.text = [list[indexPath.row] objectForKey:@"author"];
    }
    
    cell.ItemEditorial.text = [list[indexPath.row] objectForKey:@"editorial"];
    
    //cell.ItemImages.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[list[indexPath.row] objectForKey:@"image"]]]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{ // go to a background thread to load the image and not interfere with the UI
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[list[indexPath.row] objectForKey:@"image"]]]];
        dispatch_async(dispatch_get_main_queue(), ^{ // synchronize back to the main thread to update the UI with your loaded image
            cell.ItemImages.image = [list[indexPath.row] objectForKey:@"image"];
        });
    });

    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        cell.ItemImages.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[list[indexPath.row] objectForKey:@"image"]]]];
//    });
        
    cell.LinkText = [list[indexPath.row] objectForKey:@"url"];
    
    NSString *price = [list[indexPath.row] objectForKey:@"price"];
    [cell.ItemLink setTitle: price forState: UIControlStateNormal];
    
    //NSString *title = [list[indexPath.row] objectForKey:@"title"];
    NSString *title = [self getShortTitle:[list[indexPath.row] objectForKey:@"title"]];
    UIFont *font = [UIFont fontWithName:@"System Font Regular" size:16.0];
    UIColor *color = [UIColor blackColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraphStyle setLineHeightMultiple:1.0f];
   
    

    NSDictionary *attrs = @{ NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName:font};
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:attrs];

    
    [cell.ItemlTitleLink setAttributedTitle: attrString forState: UIControlStateNormal];
    
    
    return cell;
}


- (NSString *)getShortTitle:(NSString *)title {
    
    NSArray *titleItems = [title componentsSeparatedByString:@"- "];
    
    //titleItems[0];
    
    return titleItems[0];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
