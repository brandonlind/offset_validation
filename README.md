# Genetic Offset Validation

This repository contains code used in our manuscript <i>How useful is genomic data for predicting maladaptation to future climate?</i>. 

---

## Usage

If you use or inspired by code in this repository, please cite the manuscript (doi TBD).

```
Lind, B. M., R. Candido-Ribeiro, P. Singh, M. Lu, D. O. Vidakovic, T. R. Booker, M. Whitlock, N. Isabel, S. Yeaman,
and S. N. Aitken. 2023. How useful is genomic data for predicting  maladaptation to future climate? doi TBD
```


---

## Outline

Notebooks are hyperlinked to be viewed on nbviewer.org, but are best viewed in a jupyter session so that cells can be collapsed or scrolled (html and nbviewer versions, links below) do not allow scrolling.

01_split_training_and_testing.ipynb - split populations into training and test sets to use for cross validation of offset methods

02_update_species_range_shapefiles.ipynb - clip future climate (or common garden climate) using species range shapefiles to ease computational burdens of gradient forests

03_clip_climate_data.ipynb - Get range-wide climate and elevation data to fit trained gradient forest models to current/future climate

04_create_datasets-wza_baypass_random.ipynb - create the files that will be needed to run the R script created in ../05_gradient_forest_processing_scripts.ipynb

05_gradient_forest_processing_scripts.ipynb - create R scripts for training and fitting gradient forest models

06_get_common_garden_climate_data.ipynb - retrieve common garden data for the time of growth for douglas-fir and jack pine

07_fit_gradient_forest_models_to_climate_data.ipynb - fit output models to climate of common garden as well as future climate projections

08_climate_and_geographic_distance_vs_phenotypes.ipynb - calculate climate and geographic distance

09_RONA.ipynb - Calculate genetic offset using risk of non-adaptedness (RONA, sensu Rellstab et al. 2016)

11_validate_GF_offset_predictions.ipynb - validate offset calculations by plotting relationships between GF offset and phenotypes, and calculation correlation coeficients for pearson and spearman

13_consistency_of_factor_importance.ipynb - investigate the consistency of the rank of environmental importance output by Gradient Forest

14_GF_figs_with_RONA_and_climate-geo.ipynb - create figures to visualize validation of Gradient Forests, combine RONA and non-genetic validation scores

15_recreate_table_1.ipynb - create table of locus counts for manuscript using printouts from 04_create_datasets-wza_baypass_random.ipynb

16_future_RONA.ipynb - estimate RONA for future envs

17_future_RONA_and_GF_figs.ipynb - create figures from future RONA, and correlations between future RONA and future GradientForests

18_gf_future_offset_maps.ipynb - create figs that show predicted offset to future climates - choose which model to use based on model validation performance

19_climate_PCAs.ipynb - create PCAs for climate that display the populations as well as the common gardens

20_look_at_validation_relationships.ipynb - look to see if the flip flop between interior varieties from the future offset is also apparent in the projection to the common garden for either GF or RONA

21_relationship_between_kfold_and_full_GF_models.ipynb - explore GF model sensitivity by looking at the relationship between the union of out-of-bag offset predictions with that of the model using all populations

22_recreate_scatterplot.ipynb - recreate the scatter plot between GF WZA full agains increment growth for the cross-variety model

99_common_garden_maps.ipynb - create maps of populations that include the common gardens used


---

pythonimports in notebooks can be found here: https://github.com/brandonlind/pythonimports
