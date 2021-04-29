#plotting of busco #s for paper
#by Cassie Ettinger

library(tidyverse)
library(ggplot2)
library(vroom)

busco.stats <- vroom("busco_wide.csv")

busco.stats.v2 <- busco.stats %>%
  filter(!genome == "gwss")

busco.stats.v2 <- busco.stats.v2 %>%
  mutate(per_complete = (complete / total) * 100, 
         per_single = (singlecopy / total) * 100,
         per_dup = (duplicate / total) * 100,
         per_frag = (fragmented / total) * 100,
         per_missing = (missing / total) * 100)


busco.stats.v2 <- busco.stats.v2 %>%
  group_by(genome, busco_set) %>%
  gather(key = "busco_cat", value = "percent",
         per_single, per_dup, per_frag, per_missing)



busco.stats.v2$busco_cat <- factor(busco.stats.v2$busco_cat, levels = c("per_missing", "per_frag", "per_dup", "per_single"))
busco.stats.v2$busco_set <- factor(busco.stats.v2$busco_set, levels = c("euk", "hem"), 
                  labels = c("eukaryota_odb10", "hemiptera_odb10"))
busco.stats.v2$genome <- factor(busco.stats.v2$genome, levels = c("gwss_nc", "ref"), 
                                  labels = c("this study", "i5k"))


ggplot(data = busco.stats.v2, aes(x = genome, y = percent, fill = busco_cat)) +
  geom_bar(position='stack', stat="identity") + 
  theme(text = element_text(size = 12)) + 
  theme(panel.background = element_blank()) + 
  facet_grid(~busco_set) + 
  xlab("") +
  ylab("Percent of total BUSCO groups searched") + 
  scale_fill_manual(labels = c(`per_single` = "Complete and single-copy", 
                                `per_dup` = "Complete and duplicated", `per_frag` = "Fragmented", `per_missing`= "Missing"), values = c("grey", "#DCE318FF", 
                                 "#1F968BFF", "#3F4788FF")) +
  guides(fill = guide_legend(title = "Busco Status")) +
  theme(axis.ticks.x = element_blank()) 
  
ggsave(filename = 'busco_draft.png', plot = last_plot(), device = 'png', width = 6, height = 4, dpi = 300)
