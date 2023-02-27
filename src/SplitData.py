import csv
import pandas as pd

def main():
  #raw_data = pd.read_csv('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv')
  with open('/Users/winnythoen/Desktop/BioInformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv', 'r') as rawdata:
    reader = csv.reader(rawdata, delimiter='\t')
    for row in reader:
      print(row)
  

if __name__ == "__main__":
    main()
