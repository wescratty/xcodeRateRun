//
//
////
////  FirstViewController.m
////  sampleTabBar
////
////  Created by Wes Cratty on 1/2/15.
////  Copyright (c) 2015 Wes Cratty. All rights reserved.
////
//
//#import "ResultGraph.h"
//
////@interface ResultGraph ()
////
////@end
////
////@implementation ResultGraph
////
////- (void)viewDidLoad {
////    [super viewDidLoad];
////    // Do any additional setup after loading the view, typically from a nib.
////}
////
////- (void)didReceiveMemoryWarning {
////    [super didReceiveMemoryWarning];
////    // Dispose of any resources that can be recreated.
////}
////
////@end
////
//
//
//#import "AppDelegate.h"
////#import "corePlotView.h"
//
//
////bool askedForResults = false;
//
//
//@implementation NSArray (StaticArray)
//
//+(NSMutableArray *)sharedInstance{
//    
//    static dispatch_once_t pred;
//    static NSMutableArray *sharedArray = nil;
//    dispatch_once(&pred, ^{ sharedArray = [[NSMutableArray alloc] init]; });
//    return sharedArray;
//}
//@end
//
//
//@interface ResultGraph ()
//
//@end
//
//@implementation ResultGraph
//
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // [[NSNotificationCenter defaultCenter] addObserver:self selector :@selector(setNeedsDisplay) name:@"ViewControllerShouldReloadNotification" object:nil];
//    //[self.view bringSubviewToFront:[UIButton myButton]];
//    //
//    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
//    CPTGraphHostingView* hostView = [[CPTGraphHostingView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview: hostView];
//    //
//    // Create a CPTGraph object and add to hostView
//    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
//    hostView.hostedGraph = graph;
//    //
//    // Get the (default) plotspace from the graph so we can set its x/y ranges
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
//    //
//    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
//    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -2 ) length:CPTDecimalFromFloat( 16 )]];
//    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -1 ) length:CPTDecimalFromFloat( 8 )]];
//    
//    //    //-------------- plot ------------------------------
//    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
//    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
//    
//    
//    [plot setIdentifier:@"plot"];
//    [plot setDelegate:self];
//    
//    
//    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
//    plot.dataSource = self;
//    
//    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
//    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
//    
//    
//    CPTMutableLineStyle *mainPlotLineStyle = [[plot dataLineStyle] mutableCopy];
//    [mainPlotLineStyle setLineWidth:2.0f];
//    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor redColor] CGColor]]];
//    
//    [plot setDataLineStyle:mainPlotLineStyle];
//    //    //-------------- plot ------------------------------
//    
//    
//    //    //-------------- plot2 ------------------------------
//    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
//    CPTScatterPlot* plot2 = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
//    
//    [plot2 setIdentifier:@"plot2"];
//    [plot2 setDelegate:self];
//    
//    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
//    plot2.dataSource = self;
//    
//    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
//    [graph addPlot:plot2 toPlotSpace:graph.defaultPlotSpace];
//    
//    
//    //    CPTMutableLineStyle *mainPlotLineStyle2 = [[plot2 dataLineStyle] mutableCopy];
//    //    [mainPlotLineStyle setLineWidth:2.0f];
//    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]]];
//    
//    [plot2 setDataLineStyle:mainPlotLineStyle];
//    //-------------- plot2 ------------------------------
//    
//    
//}
////
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//
//- (IBAction)didPressButton:(UIButton*)sender {
//    if ([[sender currentTitle] isEqualToString:@"Display Results"]) {
//        NSLog(@"Pressed Results");
//        
//        
//        askedForResults = true;
//        // [self setNeedsDisplay];
//        //[UIView setNeedsDisplay];
//        // viewWillAppear();
//        [self.view setNeedsDisplay];
//    }
//}
////
////
////// This method is here because this class also functions as datasource for our graph
////// Therefore this class implements the CPTPlotDataSource protocol
//-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
//    return 9; // Our sample graph contains 9 'points'
//}
////
////// This method is here because this class also functions as datasource for our graph
////// Therefore this class implements the CPTPlotDataSource protocol
//-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
//{
//    
//    int x = (int)index ;
//    
//    //NSPredicate *predicate = nil;
//    
//    if ([[plot identifier] isEqual:@"plot"])
//    {
//        printf("\nin plot1");
//        //predicate = [NSPredicate predicateWithFormat:@"dayEnrolled == %d", index];
//        if(fieldEnum == CPTScatterPlotFieldX)
//        {
//            // Return x value, which will, depending on index, be between -4 to 4
//            return [NSNumber numberWithInt: x];
//        } else {
//            // Return y value, for this example we'll be plotting y = x * x
//            return [NSNumber numberWithInt: (x * x)];
//            
//        }
//        
//        
//    }
//    else if ([[plot identifier] isEqual:@"plot2"]&&askedForResults)
//    {
//        printf("\nin plot2");
//        //predicate = [NSPredicate predicateWithFormat:@"dayEnrolled == %d AND subjectID == %d", index, 0];
//        if(fieldEnum == CPTScatterPlotFieldX)
//        {
//            // Return x value, which will, depending on index, be between -4 to 4
//            return [NSNumber numberWithInt: x];
//        } else {
//            // Return y value, for this example we'll be plotting y = x * x
//            //[NSArray sharedInstance.size];
//            
//            return [NSNumber numberWithInt: [[[NSArray sharedInstance] objectAtIndex:index]doubleValue]];
//            
//        }
//        
//    }else{
//        
//        printf("\nno graph");
//        return 0;
//    }
//    
//    
//}
//
//@end
