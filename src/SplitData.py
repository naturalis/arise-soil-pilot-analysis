import csv
import pandas as pd
import warnings
warnings.simplefilter("ignore")

def location(log_extractNrs, log_loc):
  log_loc = log_loc[12:]
  loc_RegistCode = log_loc.values.tolist()
  matching = []
  for code in loc_RegistCode:
    for i in log_extractNrs:
      if code[0] == i[1]:
        matching.append(i[0])
  return matching

def basic_file(raw_data, loc_file):
  writer = csv.writer(loc_file)
  writer.writerow(raw_data['Kingdom'])
  writer.writerow(raw_data['Phylum'])
  writer.writerow(raw_data['Class'])
  writer.writerow(raw_data['Order'])
  writer.writerow(raw_data['Family'])
  writer.writerow(raw_data['Genus'])
  writer.writerow(raw_data['Species'])
  return loc_file

def new_files(raw_data, matches, loc_file):
  #print(raw_data[2])
  for i in matches:
    print(raw_data[i])  
  

def main():
  raw_data = pd.read_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv')
  log_extractNrs = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', header=None, sheet_name='Extract nrs', usecols=[0,1])
  log_loc1 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 1 list', usecols=[1])
  location1 = open('Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/loc1_file', 'w')
  #log_loc2 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 2 list', usecols=[1])
  log_loc3 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 3 list', usecols=[1])
  
  log_extractNrs = log_extractNrs.values.tolist()
  loc1_match = location(log_extractNrs, log_loc1)
  #loc2_match = location(log_extractNrs, log_loc2)
  loc3_match = location(log_extractNrs, log_loc3)

  location1 = basic_file(raw_data, location1)
  print(location1)
  #new_files(raw_data, loc1_match, location1)

if __name__ == "__main__":
    main()
