from get_region import *

#run our code 
print(">betatubulin_60d_scaffold_2372_plus10kbpregion")
get_region("data/scaffold_2372.fasta", 14001, 18910, 5000)
print(">bbetatubulin_56d_scaffold_41_plus10kbpregion")
get_region("data/scaffold_41.fasta", 668806, 670659, 5000)
print(">betatubulin_85d_scaffold_42_plus10kbpregion")
get_region("data/scaffold_42.fasta", 747344, 764258, 5000)
print(">betatubulin_97e_scaffold_627_plus10kbpregion")
get_region("data/scaffold_627.fasta", 138634, 152944, 5000)
print(">betatubulin_tub2b_scaffold_411_plus10kbpregion")
get_region("data/scaffold_411.fasta", 15112, 24986, 5000)

