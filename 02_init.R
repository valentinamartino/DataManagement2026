############################################################
# INTRODUZIONE AL TIDYVERSE
# Pipe nativo, pipe del tidyverse, select() e filter()
############################################################

### 1) CARICARE I PACCHETTI ----------------------------------

# dplyr contiene molte funzioni base del tidyverse per manipolare dati
library(tidyverse)



### 2) DATASET DI PARTENZA -----------------------------------

# Usiamo iris, già presente in R
data(iris)

dir.create("data")
#write.csv(iris, "data/iris.csv", row.names = FALSE)
rm(iris)  # rimuoviamo iris per poi ricaricarlo con read_cs
#altrimenti gc()
iris <- read.csv("data/iris.csv")

# Guardiamo il dataset
View(iris)
head(iris)
str(iris)


### 3) IDEA DI BASE DEL TIDYVERSE ----------------------------

# Nel tidyverse spesso lavoriamo in questo modo:
# dati |> funzione1() |> funzione2()
#
# cioè:
# prendo un oggetto
# poi lo trasformo passo dopo passo
# in una sequenza leggibile


### 4) PIPE NATIVO E PIPE DEL TIDYVERSE ----------------------

# PIPE NATIVO (base R, da R 4.1 in poi)
# Simbolo: |>

iris |>
  head()

# PIPE DEL TIDYVERSE / magrittr
# Simbolo: %>%

iris %>%
  head()

# Nella maggior parte dei casi fanno la stessa cosa:
# passano l'oggetto di sinistra come primo argomento
# della funzione a destra.

# Esempio senza pipe
head(iris)

# Esempio con pipe nativo
iris |>
  head()

# Esempio con pipe tidyverse
iris %>%
  head()

# Per iniziare oggi possiamo far vedere entrambi,
# ma poi usare soprattutto il pipe del tidyverse
# perché si incontra spesso nei materiali didattici.


### 5) SELECT(): SCEGLIERE LE COLONNE ------------------------

# select() serve a tenere solo alcune colonne

iris %>%
  select(Sepal.Length, Species)

iris[, c("Sepal.Length", "Species")]  #Sconsigliato
iris[, c(1,5)]  #Sconsigliato anche questo

# Posso cambiare l'ordine delle colonne
iris_mod <- iris %>%
  select(Species, Petal.Length, Sepal.Length)

# Posso selezionare un intervallo di colonne
iris %>%
  select(Sepal.Length:Petal.Width)

# Posso escludere colonne con il segno -
iris %>%
  select(-Species)

# Posso rinominare al volo
iris %>%
  select(specie = Species, petalo = Petal.Length)

iris |> 
  select(Species, everything())

### 6) FILTER(): FILTRARE LE RIGHE ---------------------------

# filter() serve a tenere solo le righe che rispettano una condizione

# Solo Setosa
iris %>%
  filter(Species == "setosa")  # == perchè solo "=" vuol dire "assegnazione" mentre "==" vuol dire "corrisponde a"

iris[iris$Species == "Setosa", ]  # Con Rbase si può fare in questo modo ma è sconsigliato

# Petali lunghi
iris %>%
  filter(Petal.Length > 5)

# Due condizioni insieme: AND
iris %>%
  filter(Species == "virginica", Petal.Length > 5)  # In modo implicito

# Stessa cosa scritta in modo esplicito
iris %>%
  filter(Species == "virginica" & Petal.Length > 5)

# Condizione OR
iris %>%
  filter(Species == "setosa" | Species == "versicolor") |>  # Seleziono solo i nomi delle specie che voglio
  filter(Petal.Length > 1.5)  # Seleziono solo le lunghezze dei petali che voglio...è meglio separare le cose piuttosto che selezionare troppe cose contemporaneamente

iris %>%
  filter(Species == "setosa" , Species == "versicolor")# Con la virgola non funziona perchè non possono essere rispettate tutte le condizioni contemporaneamente


# Posso combinare filter() e select()
iris_mod <- iris %>%
  filter(Petal.Length > 5) %>%
  select(Species, Petal.Length)


### 7) DIFFERENZA CON R BASE ---------------------------------

# In base R:
iris[iris$Petal.Length > 5, c("Species", "Petal.Length", "Petal.Width")]

# In tidyverse:
iris %>%
  filter(Petal.Length > 5) %>%
  select(Species, Petal.Length, Petal.Width)

# Il secondo approccio spesso è più leggibile,
# soprattutto quando le operazioni diventano tante.


### 8) ALCUNE REGOLE IMPORTANTI ------------------------------

# 1. select() lavora sulle colonne
# 2. filter() lavora sulle righe
# 3. == significa "uguale a"
# 4. >, <, >=, <= confrontano valori numerici
# 5. & significa AND
# 6. | significa OR


### 9) MINI ESEMPI RAPIDI -----------------------------------

# Tenere solo Species e Sepal.Width
iris %>%
  select(Species, Sepal.Width)

# Tenere solo i fiori con Sepal.Length maggiore di 7
iris %>%
  filter(Sepal.Length > 7)

# Tenere solo versicolor e vedere due colonne
iris %>%
  filter(Species == "versicolor") %>%
  select(Petal.Length, Petal.Width)

# Escludere la colonna Species
iris %>%
  select(-Species)


library(tidyverse)
library(palmerpenguins)
data(penguins)

# Per vedere bene le variabili disponibili
glimpse(penguins)


############################################################
# ESERCIZI
############################################################

### ESERCIZIO 1
# Seleziona solo le colonne:
# species, island, bill_length_mm, body_mass_g
penguins %>%
  select(species, island, bill_length_mm, body_mass_g)


### ESERCIZIO 2
# Mostra solo i pinguini dell'isola Dream
# e tieni solo le colonne species, island e sex
penguins |> 
  filter(island == "Dream") |> 
  select(species, island, sex)


### ESERCIZIO 3
# Mostra solo i pinguini con body_mass_g maggiore di 5000
# e tieni solo species, island e body_mass_g
penguins |> 
  filter(body_mass_g > 5000) |> 
  select(species, island, body_mass_g)


### ESERCIZIO 4
# Mostra solo i pinguini della specie Adelie
# che si trovano sull'isola Torgersen
penguins |> 
  filter(species == "Adelie", island == "Torgersen")


### ESERCIZIO 5
# Mostra solo i pinguini che NON appartengono alla specie Adelie
# e tieni solo species, bill_length_mm e bill_depth_mm
penguins |> 
  filter(species != "Adelie") |> 
  select(species, bill_length_mm, bill_depth_mm)


### ESERCIZIO 6
# Mostra solo i pinguini con flipper_length_mm > 200
# e body_mass_g < 5000
penguins |> 
  filter(bill_length_mm > 200, body_mass_g < 5000)


### ESERCIZIO 7
# Mostra solo i pinguini che appartengono
# alle specie Adelie oppure Gentoo
# e tieni solo species, island, body_mass_g
penguins |> 
  filter(species == "Adelie" | species == "Gentoo") |> 
  select(species, island, body_mass_g)


### ESERCIZIO 8
# Mostra solo i pinguini dell'isola Biscoe
# con body_mass_g > 4500
# e tieni solo species, island, body_mass_g, sex
penguins |> 
  filter(island == "Biscoe") |> 
  select(species, island, body_mass_g, sex)


### ESERCIZIO 9
# Seleziona tutte le colonne tranne year e sex
# poi filtra solo i pinguini della specie Chinstrap
penguins |> 
  select(1:6) |> 
  filter(species == "Chinstrap")



### ESERCIZIO 10
# Mostra solo i pinguini con bill_length_mm > 45
# e flipper_length_mm > 210
# poi tieni solo species, bill_length_mm, flipper_length_mm
penguins |> 
  filter(bill_length_mm > 45, flipper_length_mm > 210) |> 
  select(species, bill_length_mm, flipper_length_mm)


### ESERCIZIO 11
# Mostra solo i pinguini con sex mancante (NA)
# e tieni solo species, island, sex
penguins |> 
  filter(is.na(sex)) |> 
  select(species, island, sex)


### ESERCIZIO 12
# Mostra solo i pinguini con body_mass_g mancante (NA)
# oppure bill_length_mm mancante (NA)
penguins |> 
  filter(is.na(body_mass_g) | is.na(bill_length_mm))


### ESERCIZIO 13
# Mostra solo i pinguini che:
# - stanno su Dream oppure Torgersen
# - NON sono Gentoo
# poi tieni solo species, island, bill_length_mm
penguins |> 
  filter(island == "Dream" | island == "Torgersen") |> 
  filter(species != "Gentoo") |> 
  select(species, island, bill_length_mm)


### ESERCIZIO 14
# Mostra solo i pinguini con:
# - body_mass_g compreso tra 4000 e 5000
# - flipper_length_mm maggiore di 190
# poi tieni solo species, island, flipper_length_mm, body_mass_g
penguins |> 
  filter(body_mass_g > 4000, body_mass_g < 5000, flipper_length_mm > 190) |> 
  select(species, island, flipper_length_mm, body_mass_g)


### ESERCIZIO 15
# Mostra solo i pinguini che soddisfano una di queste due condizioni:
# - specie Gentoo e body_mass_g > 5500
# OPPURE
# - specie Adelie e flipper_length_mm < 190
# poi tieni solo species, island, flipper_length_mm, body_mass_g
penguins |> 
  filter(species == "Gentoo", body_mass_g < 5500 | species == "Adelie", flipper_length_mm < 190) |> 
  select(species, island, flipper_length_mm, body_mass_g)
