# Election-results-comparison

This repository includes R code that I have used to compare the number of votes
received by a single candidate in the Finnish 2015 parliamentary election and
2017 municipal election, grouped by aggregated voting areas.

The results data from all Finnish elections is freely available on the website
https://tulospalvelu.vaalit.fi/indexe.html. However, in its raw form, the data
includes a lot of information that is not relevant for making the comparisons
I am interested in. Also, as the absolute as well as  relative vote counts are
given per single voting area, the granularity of the data is unnecessarily high.

Thus, the purpose of the code that I have written is twofold: first, to pull out
from the raw data only those variables that are relevant for my comparisons,
and second, to aggregate the data into larger geographical units.

As written, the code is directly applicable only for pulling out data for
candidates registered in the Finnish capital city of Helsinki, since Helsinki
forms a single voting district in both parliamentary and municipal elections.
It might be possible to adapt the code for doing similar comparisons in other
voting districts as well, but so far I have not looked into that.

The descriptions and specifications of the various fields in the raw data files
can be found at the following web addresses:

https://tulospalvelu.vaalit.fi/E-2015/en/Election_result_data_file_description_CSV-data_EKV2015.pdf
https://tulospalvelu.vaalit.fi/KV-2017/en/Election_data_file_descriptions_CSV-data_KV2017.pdf
