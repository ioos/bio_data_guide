import pandas as pd
import csv

from pkg_resources import split_sections


def enumerate_row(row, field):
    # expands rows which contain multiple observations into discrete records
    row_data = row[1]
    calanus_count = row_data[field]

    # convert to dict so we can mutate
    new_data = row_data.to_dict()

    split_species = field.rsplit('_', 1)
    scientific_name = split_species[0].replace('_', ' ')
    life_stage = split_species[1]

    # add count of specified species as a new column
    new_data['individualCount'] = calanus_count
    new_data['scientificName'] = scientific_name
    # we're only processing records with occurances
    new_data['occuranceStatus'] = 'present'

    new_data['lifeStage'] = life_stage if life_stage != 'F' and life_stage != 'M' else 'adult'

    if life_stage == 'F':
        new_data['sex'] = 'female'
    elif life_stage == 'M':
        new_data['sex'] = 'male'
    else:
        new_data['sex'] = 'NA'

    return new_data


url = "http://www.neracoos.org/erddap/tabledap/WBTS_CFIN_2005_2017.csv"
df = pd.read_csv(url, header=[0])

target_data_columns = ['Calanus_finmarchicus_N',
                       'Calanus_finmarchicus_CI',
                       'Calanus_finmarchicus_CII',
                       'Calanus_finmarchicus_CIII',
                       'Calanus_finmarchicus_CIV',
                       'Calanus_finmarchicus_CV',
                       'Calanus_finmarchicus_F',
                       'Calanus_finmarchicus_M']


# grab all records where there is at least one calanus observation
calanus_records = df.loc[(pd.notna(df[target_data_columns]) & (df[target_data_columns] != 0)).all(1)]

# drop units row from calanus records
calanus_records = calanus_records.iloc[1:, :]

enumerated_rows = []
# loop through target column list, for each, select all records (via loc) where a given column has a value of >0
for field in target_data_columns:

    # returns df with all records where there is an occurance of the given calanus
    current_df = calanus_records.loc[pd.to_numeric(calanus_records[field]) > 0]

    # now enumerate each input row, extracting the value
    for row in current_df.iterrows():

        flipped_row = enumerate_row(row, field)

        # delete other calanus records from flipped row
        for k in target_data_columns:
            flipped_row.pop(k, None)

        enumerated_rows.append(flipped_row)

# now convert the list of dicts into a dataframe
output_frame = pd.DataFrame.from_dict(enumerated_rows)

# sort by time, ascending
output_frame.sort_values(by='time', ascending=True, inplace=True)

# write out csv
output_frame.to_csv(
    'flipped_test.csv',
    header=True,
    index=False,)
