library(tidyverse)
library(ggplot2)
library(dbplyr)

data=read.csv("../data/467300.csv")
#H 2.1 Histograma

histograma=data %>%  
  ggplot(aes(x=data$Vidutinis.darbo.užmokestis..avgWage.)) + 
  geom_histogram(bins = 200, fill="blue") + 
  labs(title = "Histograma", x="vid. atlygis", y="kiekis")


ggsave('../img/gr1.png', histograma, width = 20, height = 10)

# Penkios imones, kuriu faktinis sumoketas darbo uzmokestis buvo didziausias
names(data)=c("1", "2", "3", "Pavadinimas", "5", "6", "7", "menuo", "vidAtl", "ApdrSk", "11", "12", "13")

topimones= data%>%
  group_by(Pavadinimas) %>%
  summarise(didWage = max(vidAtl)) %>%
  arrange(desc(didWage)) %>%
  head(5)

top5 <- data %>% 
  filter(Pavadinimas%in%topimones$Pavadinimas)%>%
  mutate(Menesis=ym(menuo))%>%
  ggplot(aes(x = Menesis, y = vidAtl, color = Pavadinimas)) +
  geom_line()

ggsave("../img/top5.png", top5)

# Maksimalus top penkiu imoniu apdraustuju skaicius

apdraustieji <- data%>%
  filter(Pavadinimas %in% topimones$Pavadinimas)%>%
  group_by(Pavadinimas) %>%
  summarise(apdr=max(ApdrSk))%>%
  arrange(desc(apdr))

apdraustieji$Pavadinimas=factor(apdraustieji$Pavadinimas,levels=apdraustieji$Pavadinimas[order(apdraustieji$apdr,decreasing=TRUE)])

trecia <- apdraustieji%>%
  ggplot(aes(x=Pavadinimas, y=apdr, fill=Pavadinimas))+
  geom_col()+labs(title="Maksimalus apdraustųjų skaičius", x="Įmonių pavadinimai", y="Apdraustų žmonių skaičius")

ggsave("../img/img3.png", trecia)
