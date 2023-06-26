# Source code

This section contains R and Python scripts that perform various processing and reporting steps:

- [AlphaMetricsLoc1and2.R](AlphaMetricsLoc1and2.R) - Script to generate Shannon, Simpson, Inverse Simpson and richness index of Leidse Hout and Berkheide
- [AlphaMetricsS1S2S3.R](AlphaMetricsS1S2S3.R) - Script to generate Shannon, Simpson, Inverse Simpson and richness index of S1, S2, and S3 of Leidse Hout and Berkheide
- [LocationSplitter.py](LocationSplitter.py) - Python file to split the OTU table into the three differend scales (S1, S2, and S3)
- [RarefactionCurve.R](RarefactionCurve.R) - R script to generate a rarefaction curve
- [SplitData_OTU.py](SplitData_OTU.py) - Python file to split the OTU table into the location Leidse Hout and the location Berkheide

## [AlphaMetricsLoc1and2.R](AlphaMetricsLoc1and2.R)

### Needed R packages
- vegan
- tidyverse
- dplyr

Install packages in console using:

    install.package(..)
      
Load all packages before working with the pipeline using `library()`, line 1-3.

Import the 'your_data', that is saved in the 'data' directory, as path:

    your_data = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/your_data.csv", sep = ';', row.names = 1, header = TRUE)

Activate the three functions to calculate the Shannon, Simpson and richness indeces, lines 86-100,

Save your data as a dataframe and give rownames to the samples, line 8-9.

    your_data <- as.data.frame(t(your_data))
    your_data <- tibble::rownames_to_column(your_data, "enummers")
    
Remove first row, so the sample names are the row names, line 11-13.

    your_data_df <- as.data.frame(your_data)
    rownames(your_data_df) <- your_data_df$enummers
    your_data_df <- your_data_df[,-1]
    
Create a three variable file where all samples, and OTU are places together with a count how many times the OTU is presented in the sample, line 15-23.

    your_data_dftt <- loc3zt %>%
    bind_cols(Group = rownames(your_data_df),.) %>%
    select(Group, starts_with("OTU")) %>%
    pivot_longer(-Group) %>%
    mutate(total = sum(value)) %>%
    group_by(name) %>%
    mutate(total = sum(value)) %>%
    ungroup() %>%
    select(-total)

Creating random Alpha diversity metrics, not necessary only if interested, line 25-28.

Creating a metrics table including all indeces of Shannon, Simpson, Inverse Simpson, richness and the present variants in each sample, line 30-36.

    metric_statistics <- your_data_dftt %>%
    group_by(Group) %>%
    summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value))
            
Create plots of the indeces, line 38-50.

    your_data_dftt %>%
    group_by(Group) %>%
    summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value)) %>%
    pivot_longer(cols = c(sobs, shannon, invsimpson, simpson),
               names_to = "metric") %>%
    ggplot(aes(x=n, y=value)) +
    geom_point() +
    geom_smooth() +
    facet_wrap(~metric, nrow = 4, scales = "free_y")

## [AlphaMetricsS1S2S3.R](AlphaMetricsS1S2S3.R)

### Needed R packages
- vegan
- tidyverse
- dplyr

This script works the same as AlphaMetricsLoc1and2.R, but there are more importantions of data beceause we are looking at the subplots of the two locations.

## [LocationSplitter.py](LocationSplitter.py)

Imports:
- csv
- pandas
- warnings.simplefilter("ignore")

This script splits the OTU file of Location 1 and Location 3 in the three subplots (S1, S2 and S3).

### Def main

The original OTU table is imported
    
    raw_data = pd.read_csv('/path/data/OTU97tab_tax.csv')

The logs (names) of location 1 Leidse Hout is imported from an excel file. The sheetname and col names are speciffied.

      log_loc1 = pd.read_excel('/path/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 1 list', usecols=[1])
      
The log (names) of location 3 Berkheide is also imported from the same excel file, differend sheet.

      log_loc3 = pd.read_excel('/path/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 3 list', usecols=[1])

The extract numbers are imported. The extract numbers tell us the sample names. They need to be compared to continu to make a new OTU file for each subplot.

      log_extractNrs = pd.read_excel('/path/data/ARISE_Sample_information_logbook.xlsx', header=None, sheet_name='Extract nrs', usecols=[0,1,2])

Subplots are speccified
    
    S1, S2, S3 = 'S1', 'S2', 'S3'
    
Extract numbers are made in to a list, for easy access.

     log_extractNrs = log_extractNrs.values.tolist()
     
Extract numbers and sublocations are compared and saved into `loc?S?_match` using the Function [location](location). Location and S subplot can be specified.
    
    loc?S?_match = location(log_extractNrs, log_loc?, S?)

A basic file set up is created by the function [basics_file](basic_file).

    basics_file = basic_file(raw_data)

Matches and the basic files are compared and a new file is created using the [new_files](new_files) function.

    location?S? = new_files(raw_data, loc?S?_match, basics_file)

The output can be saved as an csv file. And the basic file is set back to the basic template.

      location?S?.to_csv('/path/data/location?otuS?.csv', index=False)
      basics_file = basic_file(raw_data)

This process is repeated for each subplot, and then for each location.

### [location](location)

Inputs:
- log_loc
- log_extractNrs
- S

Output:
- matching (list)

The function location views all extract numbers present in the `log_loc`, and compares them to the `log_extractNrs`, this is where all sample names are saved. If the subplots is the same as the subplot given to the function `S`, then the sample name is saved as a match in the macthing list.

### [basics_file](basic_file)

Inputs:
- raw_data

Output:
- basics_file

This function to create a basic file where all present OTU's are saved. This is the base for all new files.

### [new_files](new_files)

Inputs:
- raw_data
- matches
- basics_file

Output:
- basics_file

This function all matches are compared to the raw data and the information is saved in the basic_file. At the end of the function all present samples of the subplots are saved in basic_file and this is the output of the function.

## [SplitData_OTU.py](SplitData_OTU.py)

Imports:
- csv
- pandas
- warnings
- warnings.simplefilter("ignore")

### Def main

The original OTU table is imported
    
    raw_data = pd.read_csv('/path/data/OTU97tab_tax.csv')

The logs (names) of location 1 Leidse Hout is imported from an excel file. The sheetname and col names are speciffied.

      log_loc1 = pd.read_excel('/path/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 1 list', usecols=[1])
      
The log (names) of location 3 Berkheide is also imported from the same excel file, differend sheet.

      log_loc3 = pd.read_excel('/path/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 3 list', usecols=[1])

The extract numbers are imported. The extract numbers tell us the sample names. They need to be compared to continu to make a new OTU file for each subplot.

      log_extractNrs = pd.read_excel('/path/data/ARISE_Sample_information_logbook.xlsx', header=None, sheet_name='Extract nrs', usecols=[0,1,2])

Extract numbers are made in to a list, for easy access.

     log_extractNrs = log_extractNrs.values.tolist()

Extract numbers are compared and saved into `loc?_match` using the Function [location](location). Location can be specified.
    
    loc?_match = location(log_extractNrs, log_loc?)
    
A basic file set up is created by the function [basics_file](basic_file).

    basics_file = basic_file(raw_data)
    
Matches and the basic files are compared and a new file is created using the [new_files](new_files) function.

    location? = new_files(raw_data, loc?_match, basics_file)

The output can be saved as an csv file. And the basic file is set back to the basic template.

    location1.to_csv('/path/data/location1OTU.csv', index=False)
    basics_file = basic_file(raw_data)

This process is repeated for each location.

### [location](location)

Inputs:
- log_loc
- log_extractNrs

Output:
- matching (list)

The function location views all extract numbers present in the `log_loc`, and compares them to the `log_extractNrs`, this is where all sample names are saved in a matching list

### [basics_file](basic_file)

Inputs:
- raw_data

Output:
- basics_file (df)

This function created a template dataframe including all OTU and the taxonomic classification.

### [new_files](new_files)

Inputs:
- raw_data
- matches
- basics_file

Output:
- basics_file

This function all matches are compared to the raw data and the information is saved in the basic_file. At the end of the function all present samples of the subplots are saved in basic_file and this is the output of the function.

## [RarefactionCurve.R](RarefactionCurve.R)

### Needed R packages
- vegan
- tidyverse
- dplyr

Install packages in console using:

    install.package(..)
      
Load all packages before working with the pipeline using `library()`, line 1-3.

Set seed at line 5

    set.seed(19760620)

Import OTU without Taxonomic classification from a location.

    your_data = read.csv("~/path/data/location?OTU.csv", sep = ';', row.names = 1, header = TRUE)

Save your data as a dataframe and give rownames to the samples, line 11-12.

    your_data <- as.data.frame(t(your_data))
    your_data <- tibble::rownames_to_column(your_data, "enummers")
    
Remove first row, so the sample names are the row names, line 11-13.

    your_data_df <- as.data.frame(your_data)
    rownames(your_data_df) <- your_data_df$enummers
    your_data_df <- your_data_df[,-1]
    
Generate rarefaction curve using vegan, line 19
 
    rarecurve_data <- rarecurve(your_data_df, step = 50, label=FALSE)

