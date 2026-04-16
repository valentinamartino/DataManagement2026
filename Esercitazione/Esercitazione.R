# titolo dataset : Dietary breadth and overlap for lions and leopards in the Sabi Sand Game Reserve, South Africa
# autore/i : Balme Guy A., Pitman Ross T., Robinson Hugh S., Miller Jennie R.B., Funston Paul J., Hunter, Luke T.B.
# anno : 2017  
# link o DOI : https://doi.org/10.5061/dryad.cr43m
# breve descrizione  : The dataset contains information on the dietary breadth and overlap for lions and leopards in the Sabi Sand Game Reserve, South Africa. It includes data on the prey species consumed by both predators, as well as the frequency of occurrence of each prey species in their diets.

library(tidyverse)

data <- read.csv("C:/Users/mimmo/Vale/Rproject/Esercitazione/data_raw/Diet.lion.leo.csv")

head(data)
str(data)
print(data)
#Esploro il dataset

dim(data)  #Conto righe e colonne
names(data)  #Conto i nomi delle colonne


data |> 
  count(prey.sex)  
#Esplorando il dataset noto che la colonna prey.sex ha dei valori "unknown"
  

data_clean <- data |> 
  mutate(prey.sex = case_when(
    prey.sex == "unknow" ~ NA,
    prey.sex == "male" ~ "male",
    prey.sex == "female" ~ "female"
  ))

colSums(is.na(data_clean))
#Oltre alla colonna "prey.sex", tutte le altre colonne non presentano valori mancanti. La cotegoria "unknown" della colonna "prey.sex" è stata sostituita da "NA" per comodità. 


data_clean <- data_clean |> 
  select(-season)
#Siccome non ci sono dati problematici, uso solo la funzione select per rimuovere la colonna "season" che non è utile per le analisi che voglio fare.


data_clean <- data_clean |> 
  mutate(nonedible.biomass = prey.mass - edible.biomass)  
#Creo una nuova variabile numerica (lo so ho avuto poca fantasia ma il dataset permetteva solo questo).


data_clean |> 
  select(nonedible.biomass) |> 
    summary()  
#Uso summary per controllare i quartili in cui sono divisi i valori della colonna "nonedible.biomass".

data_clean <- data_clean |> 
  mutate(
    prey.taste = case_when(
      nonedible.biomass > 18.50 ~ "bad",
      nonedible.biomass > 8.20 ~ "neutral",
      nonedible.biomass > 5.20 ~ "good",
      nonedible.biomass <= 5.20 ~ "delicious"
    )
  )  
#Creo una nuova variabile categorica "prey.taste" che classifica le prede in base alla quantità di biomassa non commestibile. 
#La soglia per ogni categoria è stata scelta in base ai quartili della colonna "nonedible.biomass".


colSums(is.na(data_clean))
#Controllo che non ci siano valori mancanti dopo aver creato le nuove variabili


data_clean |> 
  count(prey.species)
#Noto che che ci sono molte specie di prede che compaiono solo una volta e che causerebbero problemi con il calcolo della sd.


sum_table <- data_clean |>
  group_by(prey.species) |> 
  filter(n() > 1) |>   #Filtro solo le specie che compaiono più di una volta per poter calcolare la deviazione standard.
  summarise(
    n = n(),
    across(
      ends_with("mass"),
      list(mean = mean, sd = sd, min = min, max = max),
      na.rm = TRUE
    )
  )
# Creo una tabella riassuntiva che mostra, per ogni specie di preda che compare più di una volta:
#il numero di osservazioni e le statistiche descrittive (media, deviazione standard, minimo e massimo) 
#per tutte le variabili che finiscono con "mass"


colSums(is.na(sum_table))
#Controllo che non ci siano valori mancanti nella tabella riassuntiva.


data_wide <- data_clean |> 
  group_by(prey.species) |> 
  summarise(
    across(
      c(prey.mass, edible.biomass),
      mean,
      na.rm = TRUE,
      .names = "mean_{.col}"
    )
  )
#Creo una tabella in formato wide che mostra, per ogni specie di preda, la media di "prey.mass" e "edible.biomass". 
#Le nuove colonne si chiamano "mean_prey.mass" e "mean_edible.biomass".


data_long <- data_wide |>
  pivot_longer(
    cols = -prey.species,
    names_to = "measure",
    values_to = "mean_value"
  )
#Creo una tabella in formato long che mostra per ogni specie di preda, il nome della misura (prey.mass o edible.biomass) e il valore medio corrispondente.

# Il formato long è più utile per fare grafici perchè permette di lavorare su più variabili contemporaneamente.


data_long |> 
  pivot_wider(
    names_from = measure,
    values_from = mean_value
  )
#Con pivot_wider() posso tornare al formato wide a partire dal formato long. 

# Il formato wide presenta una variabile distribuita su più colonne, mentre il formato long ha una colonna per il nome della variabile e una colonna per il valore.


scatterplot <- ggplot(data_clean, aes(x = prey.mass, y = edible.biomass, color = prey.size)) +
  geom_point() +
  labs(
    title = "Comparison between prey mass and edible biomass",
    x = "Prey Mass (kg)",
    y = "Edible Biomass (kg)",
    color = "Prey Size"
  ) +
  theme_bw()
#Creo uno scatterplot che mostra la relazione tra "prey.mass" e "edible.biomass", con i punti colorati in base alla variabile "prey.size".

scatterplot

ggsave("C:/Users/mimmo/Vale/Rproject/Esercitazione/figures/scatterplot.png", plot = scatterplot)


boxplot <- ggplot(data_clean, aes(x = prey.size, y = edible.biomass)) +
  geom_boxplot() +
  labs(
    title = "Comparison between prey size and edible biomass",
    x = "Prey Size",
    y = "Edible Biomass (kg)",
  ) +
  theme_bw()
#Creo un boxplot che mostra la distribuzione di "edible.biomass" per ogni categoria di "prey.size".

boxplot

ggsave("C:/Users/mimmo/Vale/Rproject/Esercitazione/figures/boxplot.png", plot = boxplot)


data_long2 <- data_clean |> 
  group_by(prey.age) |> 
  summarise(
    mean_prey_mass = mean(prey.mass, na.rm = TRUE),
    mean_edible_biomass = mean(edible.biomass, na.rm = TRUE)
  ) |> 
  pivot_longer(
    cols = -prey.age,
    names_to = "measure",
    values_to = "mean_value"
  )
#Creo una tabella in formato long che mostra, per ogni categoria di "prey.age", la media di "prey.mass" e "edible.biomass".


barplot <- ggplot(data_long2, aes(x = prey.age, y = mean_value, fill = measure)) +
  geom_col(position = "dodge") +
  labs(
    title = "Mean prey mass and mean edible biomass by prey age",
    x = "Prey Age",
    y = "Value (kg)",
    fill = "Measure"
  ) +
  theme_classic()
#Creo un barplot che mostra, per ogni categoria di "prey.age", la media di "prey.mass" e "edible.biomass". I due valori sono rappresentati con barre affiancate (position = "dodge") e colorate in base alla variabile "measure".

barplot

ggsave("C:/Users/mimmo/Vale/Rproject/Esercitazione/figures/barplot.png", plot = barplot)

write.csv(sum_table,
          "C:/Users/mimmo/Vale/Rproject/Esercitazione/output/sum_table.csv",
          row.names = FALSE)

write.csv(data_clean,
          "C:/Users/mimmo/Vale/Rproject/Esercitazione/output/data_clean.csv",
          row.names = FALSE)

ggsave("C:/Users/mimmo/Vale/Rproject/Esercitazione/output/scatterplot.png", plot = scatterplot)
ggsave("C:/Users/mimmo/Vale/Rproject/Esercitazione/output/boxplot.png", plot = boxplot)
ggsave("C:/Users/mimmo/Vale/Rproject/Esercitazione/output/barplot.png", plot = barplot)


saveRDS(data_clean, "C:/Users/mimmo/Vale/Rproject/Esercitazione/output/data_clean.rds")
