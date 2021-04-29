#trees for bins
#by Cassie Ettinger

library(tidyverse)
library(ggtree)
library(treeio)
library(ggplot2)
library(ape)
library(patchwork)

#read in gtdbtk tre file
gtdb <- read.newick("Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1_endosymbionts.gtbdk.bac120.classify.tree")


#subset to only small portions of tree that have our bins 
bin8_subset <- tree_subset(gtdb, "Bin_8-contigs", levels_back = 5)
bin7_subset <- tree_subset(gtdb, "Bin_7_2-contigs", levels_back = 4)
bin2_subset <- tree_subset(gtdb, "Bin_2-contigs", levels_back = 4)

#get metadata which has tip names
tree.meta <- read.csv("tree_ids.csv")

#get taxa from each tree
bin8_taxa_in_tree <- bin8_subset$tip.label
bin7_taxa_in_tree <- bin7_subset$tip.label
bin2_taxa_in_tree <- bin2_subset$tip.label

#now subset metadata
bin8_taxa_meta <- tree.meta %>% filter(label%in%bin8_taxa_in_tree)
bin7_taxa_meta <- tree.meta %>% filter(label%in%bin7_taxa_in_tree)
bin2_taxa_meta <- tree.meta %>% filter(label%in%bin2_taxa_in_tree)

#Join metadata with the tree
bin8_tree <-full_join(bin8_subset, bin8_taxa_meta, by = "label")
bin7_tree <-full_join(bin7_subset, bin7_taxa_meta, by = "label")
bin2_tree <-full_join(bin2_subset, bin2_taxa_meta, by = "label")


#bin 8
baumannia.tree <- ggtree(bin8_tree, color = "black", size = 1.5, linetype = 1) + 
  geom_tiplab(aes(label = Taxonomy, color = study),fontface = "bold.italic", size = 5, offset = 0.001) +
  xlim(0,1) + 
  scale_color_manual(values =c(study = "#EF7F4FFF", ref = "#000000")) +
  theme(legend.position = "none")


#bin 7
sulcia.tree <- ggtree(bin7_tree, color = "black", size = 1.5, linetype = 1) + 
  geom_tiplab(aes(label = Taxonomy, color = study),fontface = "bold.italic", size = 5, offset = 0.001) +
  xlim(0,2) + 
  scale_color_manual(values =c(study = "#EF7F4FFF", ref = "#000000")) +
  theme(legend.position = "none")


#bin 2
wolbachia.tree <- ggtree(bin2_tree, color = "black", size = 1.5, linetype = 1) + 
  geom_tiplab(aes(label = Taxonomy, color = study),fontface = "bold.italic", size = 5, offset = 0.001) +
  xlim(0,1) + 
  scale_color_manual(values =c(study = "#EF7F4FFF", ref = "#000000")) +
  theme(legend.position = "none")


wolbachia.tree / baumannia.tree / sulcia.tree  + plot_annotation(tag_levels = "A")

ggsave(filename = 'tree.png', plot = last_plot(), device = 'png', width = 10, height = 10, dpi = 300)




