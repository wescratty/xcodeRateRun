//
//  Graph1.m
//  sampleTabBar
//
//  Created by Wes Cratty on 1/2/15.
//  Copyright (c) 2015 Wes Cratty. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import <math.h>

@implementation NSArray (StaticArray)

+(NSMutableArray *)sharedInstance{
    
    static dispatch_once_t pred;
    static NSMutableArray *sharedArray = nil;
    dispatch_once(&pred, ^{ sharedArray = [[NSMutableArray alloc] init]; });
    return sharedArray;
}
@end


@interface FirstViewController ()
@property (nonatomic, retain) IBOutlet UILabel *label_a;
@property (nonatomic, retain) IBOutlet UILabel *label_b;
@property (nonatomic, retain) IBOutlet UILabel *label_c;
@property (nonatomic, retain) IBOutlet UILabel *label_d;
@property (nonatomic, retain) IBOutlet UISlider *slider_a;
@property (nonatomic, retain) IBOutlet UISlider *slider_b;
@property (nonatomic, retain) IBOutlet UISlider *slider_c;
@property (nonatomic, retain) IBOutlet UISlider *slider_d;
@property (weak, nonatomic) IBOutlet UISlider *plotsNumSlider;
@property (weak, nonatomic) IBOutlet UILabel *plotsNumLabel;
//@property (weak, nonatomic) IBOutlet UIView *MiniGraphView;
//
//-(void) compareLines;
//-(void) loadMainGraph;
//-(void) loadSmallGraph;

- (IBAction)sliderListener:(id)sender;
// Adding a comment
@end

@implementation FirstViewController

int sizeofMyarray = 0;
int records = 5;
int graphsMade =0;
int smallgraphsMade =0;
int plotsSliderNum =10;

double A=.2;
double B=.1;
double C=0;
double D=1;
double tabItemIndex =0;

NSNumber *max =0;

//UIView *MiniGraphView;

CPTGraphHostingView* hostView;
CPTGraph* graph;
CPTGraph* graph2;
CPTScatterPlot* plot;
CPTScatterPlot* plot2;


//===========================================================================

-(void) viewDidAppear:(BOOL)animated    {
   // NSLog(@"tab selected: %lu", (unsigned long)self.tabBarController.selectedIndex);
    tabItemIndex=self.tabBarController.selectedIndex;
    if(tabItemIndex==3)
    {
        if (smallgraphsMade>0) {
            [graph2 reloadData];
            
        }else{
            [self loadSmallGraph];
            //max = [NSNumber numberWithInt:7];
            //[self clientMessage];
        }
    }else if (tabItemIndex==0){
        //NSLog(@"\nEnters on first");

        if (graphsMade>0) {
            [graph reloadData];
            [self getArraySize];
            
            if (sizeofMyarray>2) {
                [self compareLines];
                [self clientMessage];
            }
            
        }else{
            
            [self loadMainGraph];
            //[self clientMessage];
        }
    }
}

//===========================================================================
// Finds differance between the two lines and stores in max
-(void) compareLines
{
    NSNumber *funct1 =0;
    NSNumber *location1 =0;
    NSNumber *difference=[NSNumber numberWithDouble:0.0];
    printf(" comparing lines");
    [self getArraySize];
    
    if (sizeofMyarray>0) {
        //check arrays for closeness to line.
        for (int i=0; i<sizeofMyarray; i++) {
            
            funct1 =([NSNumber numberWithDouble: (((pow(i,A))+(pow(i,B))+i*C)+D)]);
            location1 =([NSNumber numberWithDouble: [[[NSArray sharedInstance] objectAtIndex:i]doubleValue]]);
            difference = [NSNumber numberWithDouble:([funct1 floatValue] - [location1 floatValue])];
            difference = [NSNumber numberWithDouble:fabs([difference doubleValue])];
            NSLog(@"\ndifference is:%@",difference);
            
            if ([difference doubleValue ]>[max doubleValue]) {
                max= difference ;
            }
        }
        //NSLog(@"\nmax is:%@",max);
    }
}


//===========================================================================
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
// Returns number of points to plot
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plotnumberOfRecords {
    
    [self getArraySize];
    if (sizeofMyarray>1) {
        return sizeofMyarray;
    }else{
        return plotsSliderNum; // Our sample graph contains 9 'points'
    }
    
    
}

//===========================================================================
// This method is here because this class also functions as datasource for our graph
// Therefore this class implements the CPTPlotDataSource protocol
// Depending on which graph is needed it creates the x vals or returns x vals from array
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    
    int x = (int)index ;
    
    if ([[plot identifier] isEqual:@"plot"])
    {
        if(fieldEnum == CPTScatterPlotFieldX)
        {
            return [NSNumber numberWithInt: x];
        } else {
            return [NSNumber numberWithInt: (((pow(x,A))+(pow(x,B))+x*C)+D)];
        }
    }
    else if ([[plot identifier] isEqual:@"plot2"]&& [[NSArray sharedInstance] count]>1)//askedForResults)
    {
        if(fieldEnum == CPTScatterPlotFieldX)
        {
            return [NSNumber numberWithInt: x];
        } else {
            
            return [NSNumber numberWithInt: [[[NSArray sharedInstance] objectAtIndex:index]doubleValue]];
        }
    }else{
        return 0;
    }
}

//===========================================================================
// Builds small graph to see what you are making
-(void) loadMainGraph
{
   // NSLog(@"\n Number of graphs made%d",graphsMade);
    graphsMade++;
    
    //------------- Sets up graph -----------------------------------------------------------
    // We need a hostview, you can create one in IB (and create an outlet) or just do this:
    hostView = [[CPTGraphHostingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: hostView];
    graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = graph;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -2 ) length:CPTDecimalFromFloat( 16 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( -1 ) length:CPTDecimalFromFloat( 20 )]];
    
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    
    CPTXYAxis *y = axisSet.yAxis;
    CPTXYAxis *x = axisSet.xAxis;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    
    y.labelFormatter = formatter;
    x.labelFormatter = formatter;
    
    y.title = @"Speed";
    x.title = @"Time";
    //y.titleTextStyle = axisTitleStyle;
    x.titleOffset = 20.0f;
    y.titleOffset = 20.0f;
    
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    // 5 - Enable user interactions for plot space
    plotSpace.allowsUserInteraction = YES;
    
    
    //-------------- plot ------------------------------
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    //plot.interpolation = CPTScatterPlotInterpolationCurved;
    
    [plot setIdentifier:@"plot"];
    [plot setDelegate:self];
    
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    
    
    CPTMutableLineStyle *mainPlotLineStyle = [[plot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor redColor] CGColor]]];
    
    [plot setDataLineStyle:mainPlotLineStyle];
    //-------------- plot ------------------------------
    
    
    //-------------- plot2 ------------------------------
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot2 = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    [plot2 setIdentifier:@"plot2"];
    [plot2 setDelegate:self];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot2.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot2 toPlotSpace:graph.defaultPlotSpace];
    
    
    //    CPTMutableLineStyle *mainPlotLineStyle2 = [[plot2 dataLineStyle] mutableCopy];
    //    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor blueColor] CGColor]]];
    
    [plot2 setDataLineStyle:mainPlotLineStyle];
    //-------------- plot2 ------------------------------

}

//===========================================================================

-(void) loadSmallGraph
{
    smallgraphsMade++;
    hostView = [[CPTGraphHostingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: hostView];
    graph2 = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    hostView.hostedGraph = graph2;
    
    //[[self chartHostingView] setFrame:CGRectMake(0, 0, chartWidth, chartHeight)];
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph2.defaultPlotSpace;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:CPTDecimalFromFloat( 10 )]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat( 0 ) length:
                           
                           CPTDecimalFromFloat( 10 )]];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) hostView.hostedGraph.axisSet;
    
    CPTXYAxis *y = axisSet.yAxis;
    CPTXYAxis *x = axisSet.xAxis;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    
    y.labelFormatter = formatter;
    x.labelFormatter = formatter;
    
    
    [graph2.plotAreaFrame setPaddingTop:100.0f];
    [graph2.plotAreaFrame setPaddingLeft:350.0f];
    [graph2.plotAreaFrame setPaddingBottom:100.0f];
    [graph2.plotAreaFrame setPaddingRight:100.0f];
    
    // 5 - Enable user interactions for plot space
    plotSpace.allowsUserInteraction = YES;
    
    
    //-------------- plot ------------------------------
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    //plot.interpolation = CPTScatterPlotInterpolationCurved;
    
    [plot setIdentifier:@"plot"];
    [plot setDelegate:self];
    
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    plot.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph2 addPlot:plot toPlotSpace:graph2.defaultPlotSpace];
    
    
    CPTMutableLineStyle *mainPlotLineStyle = [[plot dataLineStyle] mutableCopy];
    [mainPlotLineStyle setLineWidth:2.0f];
    [mainPlotLineStyle setLineColor:[CPTColor colorWithCGColor:[[UIColor redColor] CGColor]]];
    
    [plot setDataLineStyle:mainPlotLineStyle];
    //-------------- plot ------------------------------
    
    [self.view bringSubviewToFront:_slider_a];
    [self.view bringSubviewToFront:_slider_b];
    [self.view bringSubviewToFront:_slider_c];
    [self.view bringSubviewToFront:_slider_d];
    [self.view bringSubviewToFront:_plotsNumSlider];
    

}

//===========================================================================
// Displays alert view of the diff betwen lines
-(void) clientMessage
{
    NSString *title;
    NSString *string;
    //NSLog(@"%@", string);
    switch ([max integerValue])
    {
        case 0:
        {
            title = @"How to";
            string =@"Go to Get Data and start recording your speed or go to Select New Graph and make a new graph ";
            break;
        }

        case 1:
        {
            title = @"Results";
            string =@"Nice work ";
            break;
        }
        case 2:
        {
            title = @"Results";
            string =@"Pretty good ";
            break;
        }
        case 3:
        {
            title = @"Results";
            string =@"Getting Closer";
            break;
        }
        case 4:
        {
            title = @"Results";
            string =@"So So ";
            break;
        }
        case 5:
        {
            title = @"Results";
            string =@"You could probably do better ";
            break;
        }
            
        case 6:
        {
            title = @"Results";
            string =@"Rookie ";
            break;
        }
        case 7:
        {
            title = @"How to";
            string =@"Move the sliders to change the graph to somthing you think you can do ";
            break;
        }
        default:{
            title = @"Results";
            string = @"try again ";
            break;
        }
            
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: title
                                                   message: string
                                                  delegate: self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    
    [alert setTag:1];
    [alert show];
    title = @"Results";
}

//===========================================================================

- (IBAction)sliderListener:(id)sender {
    UISlider * slider = (UISlider *)sender;
    
    //NSLog(@"slider selected: %lu", (unsigned long)slider.tag);
    switch (slider.tag)
    {
        case 1:
        {
            A = slider.value;
            self.label_a.text = [NSString stringWithFormat:@"%.1f", A];
        }
            break;
        case 2:
        {
            B = slider.value;
            self.label_b.text = [NSString stringWithFormat:@"%.1f", B];
        }
            break;
        case 3:
        {
            C = slider.value;
            self.label_c.text = [NSString stringWithFormat:@"%.1f", C];
        }
            break;
        case 4:
        {
            D = slider.value;
            self.label_d.text = [NSString stringWithFormat:@"%.1f", D];
        }
            break;
        case 5:
        {
            plotsSliderNum = slider.value ;
            self.plotsNumLabel.text = [NSString stringWithFormat:@"%d", plotsSliderNum];
        }
            break;
    }
    [graph2 reloadData];
}

//===========================================================================
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//===========================================================================

-(void) getArraySize
{
    sizeofMyarray=(int)[[NSArray sharedInstance] count];
}

@end
