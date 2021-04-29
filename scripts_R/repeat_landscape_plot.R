#plotting of repeat landscape #s for paper
#by Cassie Ettinger

library(tidyverse)
library(ggplot2)
library(vroom)
library(RColorBrewer)
library(patchwork)

#sed 's/[[]//g' Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta.out.landscape.Div.Rclass.tab > Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta.out.landscape.Div.Rclass.fix.tab

repeat.land.class <- vroom("Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta.out.landscape.Div.Rclass.fix.tab", skip = 1)
#repeat.land.fam <- vroom("Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta.out.landscape.Div.Rfam.tab")

#transpose
repeat.land.class.t <- t(repeat.land.class)

#get rid of row 1
repeat.land.class.t2 <- repeat.land.class.t[-c(1),]

#add col names
colnames(repeat.land.class.t2) <- repeat.land.class.t[1,]

#convert to tibble
repeat.land.class.t3 <- as.tibble(repeat.land.class.t2)

#add column with bin divergences 
repeat.land.class.t3$DivBin <- 1:50


total = 1935783339 #total genome size used for repeatmasker
  
#get % genome for each bin
#had to use str_trim to get rid of whitespace
#then had to change from str -> numeric to do maths
repeat.land.class.t4 <- repeat.land.class.t3 %>%
  mutate(per_RC= (as.numeric(str_trim(RC)) / total) * 100, 
         per_DNA = (as.numeric(str_trim(DNA)) / total) * 100,
         per_Unk = (as.numeric(str_trim(Unknown)) / total) * 100,
         per_SINE = ((as.numeric(str_trim(SINE)) + as.numeric(str_trim(repeat.land.class.t3$`Retroposon?`))) / total) * 100,
         per_LINE = (as.numeric(str_trim(LINE)) / total) * 100,
         per_LTR = (as.numeric(str_trim(LTR)) / total) * 100)


#gather up percentages for plotting by divergence bin
repeat.land.class.t4 <- repeat.land.class.t4 %>%
  group_by(DivBin) %>%
  gather(key = "repeat_class", value = "percent_genome",
         per_RC, per_DNA, per_Unk, per_SINE, per_LINE, per_LTR)


repeat.land.class.t4$repeat_class <- factor(repeat.land.class.t4$repeat_class, levels = c("per_LINE", "per_SINE", "per_LTR", "per_DNA", "per_RC", "per_Unk"))

#Abbreviations: DNA = DNA transposon; LINE = long interspersed nuclear element; LTR = long terminal repeat retrotransposon; RC = rolling circle transposons (Helitron); SINE = small interspersed nuclear element.
kimplot <- ggplot(data = repeat.land.class.t4, aes(x = DivBin, y = percent_genome, fill = repeat_class)) +
  geom_bar(position='stack', stat="identity") + 
  theme(text = element_text(size = 12)) + 
#  theme(panel.background = element_blank()) + 
  xlab("Sequence Divergence (CpG adjusted Kimura divergence)") +
  ylab("Percent of genome") + 
  scale_fill_manual(labels = c(`per_RC` = "RC", 
                               `per_DNA` = "DNA", 
                               `per_Unk`= "Unknown",
                               `per_SINE` = "SINE",
                               `per_LINE` = "LINE",
                               `per_LTR` = "LTR"), values = c( "#CC79A7", "#E69F00", "#009E73", "#56B4E9","#F0E442", 
                                                               "#0072B2")) +
  guides(fill = guide_legend(title = "Repeat Class"))



#now summarize for total percentages
repeat.land.class.t5 <- repeat.land.class.t4 %>%
  group_by(repeat_class) %>%
  summarise(total_per = sum(percent_genome))


repeat.land.class.t5$repeat_class <- factor(repeat.land.class.t5$repeat_class, labels = c("LINE", "SINE", "LTR", "DNA", "RC", "Unknown"))

#plot class x total percent of genome
totplot <- ggplot(data = repeat.land.class.t5, aes(x = repeat_class, y = total_per, fill = repeat_class)) +
  geom_bar(position='stack', stat="identity") + 
  theme(text = element_text(size = 12)) + 
  xlab("Repeat Class") +
  ylab("Percent of genome") + 
  scale_fill_manual(labels = c(`per_RC` = "RC", 
                               `per_DNA` = "DNA", 
                               `per_Unk`= "Unknown",
                               `per_SINE` = "SINE",
                               `per_LINE` = "LINE",
                               `per_LTR` = "LTR"), values = c( "#CC79A7", "#E69F00", "#009E73", "#56B4E9","#F0E442", 
                                                               "#0072B2")) +
  guides(fill = guide_legend(title = "Repeat Class"))


totplot + kimplot + plot_annotation(tag_levels = "A") + plot_layout(guides = "collect", widths = c(1, 2)) & 
  theme(plot.tag = element_text(face = "bold"))

ggsave(filename = 'repeat_draft.png', plot = last_plot(), device = 'png', width = 12, height = 5, dpi = 300)


