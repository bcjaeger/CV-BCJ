
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Curriculum-Vitae (CV)

<!-- badges: start -->

<!-- badges: end -->

This repo is based on a fantastic [blog
post](https://livefreeordichotomize.com/2019/09/04/building_a_data_driven_cv_with_r/)
by Nick Strayer. I have lightly modified his code to make my own CV a
little more data-driven and a little easier to update.

The basic idea of this repo is to store all of your static data in a
main file (`BCJ.csv`). By static data, I mean things that probably won’t
change (e.g., where you went to school, previous jobs, etc.). Then, make
separate data files for dynamic data, such as your publications and R
packages.

I am lucky to have access to the University of Alabama Profiles system,
which allows me to download up-to-date .csv files of my
grants/publications. This is what creates the files in `data/source`. I
manually edited the info in those files to create files in `data/manual`
these files are easier to build a CV with. After writing scripts to edit
the manual data files and save them to `data/source`, everything is
bound together and fed to the `Index.Rmd` file.

Please feel free to re-work my process for your own needs, and thank
[Nick Strayer](https://livefreeordichotomize.com/) for making such a
neat framework\!
