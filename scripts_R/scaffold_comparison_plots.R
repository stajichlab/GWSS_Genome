#plotting scaffold size vs. i5k
#by Cassie Ettinger

library(tidyverse)
library(ggplot2)
library(vroom)

i5k.len <- vroom("i5k.count.txt", col_names = c("scaffold.id", "assembly", "length"))
gwss.len <- vroom("gwss.count.txt", col_names = c("scaffold.id", "assembly", "length"))

#remove scaffolds from MAGs
scaffolds.to.remove <- read.delim("scaffold_ids_MAGs.txt")

gwss.subset <- gwss.len %>%
  filter(!scaffold.id %in% scaffolds.to.remove$scaffold.id)

#add column that represents assembly
i5k.len$assembly <- "i5k"
gwss.subset$assembly <- "gwss"

#sort by scaffold length and get cumulative length
i5k.sort <- i5k.len %>% 
  mutate(cum_length = cumsum(length))



#get an index # for scaffolds for plotting
i5k.sort$index <- row.names(i5k.sort)



#sort by scaffold length / get cum legnth
gwss.sort <- gwss.subset %>% 
  mutate(cum_length = cumsum(length))  


gwss.sort$index <- row.names(gwss.sort)


genome.len <- full_join(i5k.sort, gwss.sort)


genome.len$assembly <- factor(genome.len$assembly, levels = c("gwss", "i5k"), 
                                labels = c("this study", "i5k"))


ggplot(data = genome.len, aes(x = as.numeric(index), y = (cum_length / 1000000), color = assembly)) +
  geom_line(size = 1.5) +
  #theme_linedraw()+
  theme(text = element_text(size = 14)) +
  xlab("Number of scaffolds") +
  ylab("Cumulative length (Mbp)") +
  scale_color_manual(values = c("#EF7F4FFF", "#0D0887FF"))+
  guides(color = guide_legend(title = "Assembly"))  

ggsave(filename = 'scaffold_draft.png', plot = last_plot(), device = 'png', width = 6, height = 4, dpi = 300)
