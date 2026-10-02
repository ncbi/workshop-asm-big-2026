# Outbreak investigation

Using Pathogen Detection tools to identify closely related isolates.

We will be using the example of the [Enoki mushroom _Listeria_ outbreak](https://pmc.ncbi.nlm.nih.gov/articles/PMC10947956/) that was solved thanks to connecting isolates from sick individuals in the USA to isolates from food sequenced in Canada and submitted to NCBI Pathogen Detection.

An ongoing outbreak of _Listeria_ was being investigated by the CDC with multiple investigations opened and closed starting in 2017 without finding a contaminated food source eventually covering 36 cases 2 fetal losses and 4 deaths. In 2020 the Canadian Food Inspection Agency uploaded sequence of Listeria isolates they had collected from Enoki mushrooms and closely related isolates were identified using Pathogen Detection data. This connection eventually identified additional cases in Canada, Australia, Korea, and France. 

## Look for a new clinical isolate submitted to NCBI

Imagine you have sequenced a clinical Listeria SAMN13001002 and submitted to NCBI Pathogen Detection run SRR10252179.

### Go to the [NCBI Pathogen Detection Homepage](https://www.ncbi.nlm.nih.gov/pathogens)

### Search the isolates browser for SAMN13001002

[Direct link](https://www.ncbi.nlm.nih.gov/pathogens/isolates/#SAMN13001002)

### Look at the results

- Notice there is a matched cluster with 80 isolates
- Notice that the min-diff value is 3

These both mean that there is at least one very closely related environmental isolate in the system. Maybe this will provide a clue as to the source of your illness.

### Click on the SNP cluster

[Direct link](https://www.ncbi.nlm.nih.gov/pathogens/tree/#Listeria/PDG000000001.4723/PDS000011550.54?accessions=PDT000603604.1)

- Look at the tree and note the closely related isolates
- Canadian "food" isolates, Selecting multiple nodes lets you see the SNP distances in the left panel
- Look at metadata and what you can see about the origin of the isolates and the creation dates.
- You can watch isolates and safe searches


- 
