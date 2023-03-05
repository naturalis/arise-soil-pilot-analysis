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

def basic_file(raw_data):
  seq = []
  kingdomlist, phylumlist, classlist = [], [], []
  orderlist, familylist, genuslist, specieslist = [],[],[],[]
  for i in raw_data['Unnamed: 0']:
    seq.append(i)
  for i in raw_data['Kingdom']:
    kingdomlist.append(i)
  for i in raw_data['Phylum']:
    phylumlist.append(i)
  for i in raw_data['Class']:
    classlist.append(i)
  for i in raw_data['Order']:
    orderlist.append(i)
  for i in raw_data['Family']:
    familylist.append(i)
  for i in raw_data['Genus']:
    genuslist.append(i)
  for i in raw_data['Species']:
    specieslist.append(i)
  new_dic = {'Sequence': seq, 'Kingdom': kingdomlist, 'Phylum': phylumlist, 'Class': classlist, 'Order': orderlist,
             'Family': familylist, 'Genus': genuslist, 'Species': specieslist}
  loc_file = pd.DataFrame(new_dic, columns = ['Sequence', 'Kingdom', 'Phylum', 'Class', 'Order',
                                              'Family', 'Genus', 'Species'])
  return loc_file

def new_files(raw_data, matches, basics_file):
  for i in matches:
    ilist = []
    for j in raw_data[i]:
      ilist.append(j)
    basics_file[i] = ilist
  return basics_file
  

def main():
  raw_data = pd.read_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv')
  log_extractNrs = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', header=None, sheet_name='Extract nrs', usecols=[0,1])
  log_loc1 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 1 list', usecols=[1])
  #log_loc2 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 2 list', usecols=[1])
  log_loc3 = pd.read_excel('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ARISE_Sample_information_logbook.xlsx', sheet_name='Location 3 list', usecols=[1])
  
  log_extractNrs = log_extractNrs.values.tolist()
  loc1_match = location(log_extractNrs, log_loc1)
  #loc2_match = location(log_extractNrs, log_loc2)
  loc3_match = location(log_extractNrs, log_loc3)

  basics_file = basic_file(raw_data)

  location1 = new_files(raw_data, loc1_match, basics_file)
  location1.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1.csv', index=False)

  #location2 = new_files(raw_data, loc2_match, basics_file)
  #location2.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location2.csv', index=False)

  location3 = new_files(raw_data, loc3_match, basics_file)
  location3.to_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3.csv', index=False)



if __name__ == "__main__":
    main()
