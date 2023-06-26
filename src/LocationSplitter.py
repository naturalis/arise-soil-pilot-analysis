import csv
import pandas as pd
import warnings
warnings.simplefilter("ignore")

# The function location views all extract numbers present in the `log_loc`, 
# and compares them to the `log_extractNrs`, this is where all sample names are saved. 
# The sample name is saved as a match in the macthing list.
def location(log_extractNrs, log_loc, S):
  log_loc = log_loc[12:]
  loc_RegistCode = log_loc.values.tolist()
  matching = []
  for code in loc_RegistCode:
    for i in log_extractNrs:
      if code[0] == i[1]:
        string = i[2]
        index = string.find(S)
        if index != -1:
          print(code[0], i[2])
          matching.append(i[0])
  print(matching)
  return matching

# This function to create a basic file where all present OTU's are saved. This is the base for all new files.
def basic_file(raw_data):
  OTUnr = []
  for i in raw_data['Unnamed: 0']:
    OTUnr.append(i)
  new_dic = {'OTUnr': OTUnr}
  loc_file = pd.DataFrame(new_dic, columns = ['OTUnr'])
  return loc_file

# # This function all matches are compared to the raw data and the information 
# is saved in the basic_file. 
# At the end of the function all present samples of the subplots are saved in 
# basic_file and this is the output of the function.
def new_files(raw_data, matches, basics_file):
  for i in matches:
    ilist = []
    for j in raw_data[i]:
      ilist.append(j)
    basics_file[i] = ilist
  return basics_file
  

def main():
  raw_data = pd.read_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/OTU97tab_tax.csv')
  log_loc1 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 1 list', usecols=[1])
  log_extractNrs = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', header=None, sheet_name='Extract nrs', usecols=[0,1,2])
  log_loc3 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 3 list', usecols=[1])


  S1, S2, S3 = 'S1', 'S2', 'S3'
  log_extractNrs = log_extractNrs.values.tolist()
  loc1S1_match = location(log_extractNrs, log_loc1, S1)
  loc1S2_match = location(log_extractNrs, log_loc1, S2)
  loc1S3_match = location(log_extractNrs, log_loc1, S3)

  basics_file = basic_file(raw_data)

  location1S1 = new_files(raw_data, loc1S1_match, basics_file)
  location1S1.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1otuS1.csv', index=False)
  basics_file = basic_file(raw_data)
  
  location1S2 = new_files(raw_data, loc1S2_match, basics_file)
  location1S2.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1otuS2.csv', index=False)
  basics_file = basic_file(raw_data)
  
  location1S3 = new_files(raw_data, loc1S3_match, basics_file)
  location1S3.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1otuS3.csv', index=False)
  basics_file = basic_file(raw_data)
  
  loc3S1_match = location(log_extractNrs, log_loc3, S1)
  loc3S2_match = location(log_extractNrs, log_loc3, S2)
  loc3S3_match = location(log_extractNrs, log_loc3, S3)
  basics_file = basic_file(raw_data)
  
  location3S1 = new_files(raw_data, loc3S1_match, basics_file)
  location3S1.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3otuS1.csv', index=False)
  basics_file = basic_file(raw_data)
  
  location3S2 = new_files(raw_data, loc3S2_match, basics_file)
  location3S2.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3otuS2.csv', index=False)
  basics_file = basic_file(raw_data)
  
  location3S3 = new_files(raw_data, loc3S3_match, basics_file)
  location3S3.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3otuS3.csv', index=False)


if __name__ == "__main__":
    main()
