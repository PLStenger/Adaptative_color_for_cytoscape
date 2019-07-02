#!/usr/bin/env document

# 1) Extraction of the HEX code color of the downloaded file, in order to put them in a list

grep "fill=" REViGO.xgmml > REViGO-FILL.xgmml
sed 's/ /\'$'\t/g' REViGO-FILL.xgmml > REViGO-FILL-2.xgmml
awk '{print $5}' REViGO-FILL-2.xgmml > REViGO-FILL-3.xgmml
sed 's/fill="#//g' REViGO-FILL-3.xgmml > REViGO-FILL-4.xgmml
sed 's/"\/\>//' REViGO-FILL-4.xgmml > REViGO-FILL-5.xgmml

# Cleanning
rm REViGO-FILL-4.xgmml
rm REViGO-FILL-3.xgmml
rm REViGO-FILL-2.xgmml
rm REViGO-FILL.xgmml

# 2) change HEX code to RGB
cat REViGO-FILL-5.xgmml | while read in; do hextorgb.sh "$in"; done > REViGO-FILL-5-RGB.xgmml

# 3) Create a corresponding file
paste REViGO-FILL-5.xgmml REViGO-FILL-5-RGB.xgmml > REViGO-FILL-5-RGB-corresponding.txt

# 4) clean and prepare the file for "being" a R script
sed 's/ /,/g' REViGO-FILL-5-RGB-corresponding.txt > REViGO-FILL-5-RGB-corresponding-2.txt
tr -d '\r' < REViGO-FILL-5-RGB-corresponding-2.txt > REViGO-FILL-5-RGB-corresponding-2-ok.txt

# 5) Create the R script in order to convert the convert the RGB code into HSV code in the goal of change only the hue of the colors (so, the saturation and darkness levels will stay the same, and the less "important" GO will appears still more grey than the importanter)
awk '{print $2}' REViGO-FILL-5-RGB-corresponding-2-ok.txt > REViGO-FILL-5-RGB-corresponding-3-ok.txt
awk '{print "rgb2hsv("$2")[,1]"}' REViGO-FILL-5-RGB-corresponding-2-ok.txt > REViGO-FILL-5-RGB-corresponding-3-ok.R

# 6) Lunch the R script and kept the result into file
Rscript REViGO-FILL-5-RGB-corresponding-3-ok.R > Result_R_script.txt

# 7) clean the result file
sed '/h/d' Result_R_script.txt > Result_R_script_clean.txt
sed 's/ /\'$'\t/g' Result_R_script_clean.txt > Result_R_script_clean_2.txt
# for the yellow

################################################################################
######### HERE WE CHANGE THE COLOR OF THE HUE (first parameter in hsv) #########
################################################################################
# create script to change the hue of HSV and then change the new HSV to RGB

################################################################################
############## For yellow: put 0.15
################################################################################

awk '{print "col2rgb(hsv(0.15, "$2","$3"))[,1]"}' Result_R_script_clean_2.txt > Result_R_script_clean_2_yellow.R

# lunch the script
Rscript Result_R_script_clean_2_yellow.R > Result_R_yellow.txt

# Clean the results
sed '/red/d' Result_R_yellow.txt > Result_R_yellow_clean.txt
awk '{print $1","$2","$3}' Result_R_yellow_clean.txt > Result_R_yellow_clean_2.txt

# Create a corresponding file
paste REViGO-FILL-5.xgmml Result_R_yellow_clean_2.txt > original_HEX_whith_RGB_yellow_corresponding.txt

# Clean the corresponding file
tr -d '\r' < original_HEX_whith_RGB_yellow_corresponding.txt > original_HEX_whith_RGB_yellow_corresponding2.txt

# kind of vlookup to change the corresponding HEX orginal code of the original file by the new RGB colors
sed "$(<original_HEX_whith_RGB_yellow_corresponding2.txt sed 's/\./\\./g' | xargs -n2 printf "s@%s@%s@g\n")" REViGO.xgmml > REViGO-whith-yellow-color.xgmml

# Clean
sed 's/fill="#/fill="rgb(/g' REViGO-whith-yellow-color.xgmml > REViGO-whith-yellow-color2.xgmml
sed 's/fill=\(.*\)\/\>/fill=\1)\/\>/g' REViGO-whith-yellow-color2.xgmml > REViGO-whith-yellow-color3.xgmml
sed 's/")/)"/g' REViGO-whith-yellow-color3.xgmml > REViGO-for-yellow-input.xgmml

#rm REViGO-whith*
#rm original*
#rm Result_R*



################################################################################
############## For green: put 0.35
################################################################################

awk '{print "col2rgb(hsv(0.35, "$2","$3"))[,1]"}' Result_R_script_clean_2.txt > Result_R_script_clean_2_green.R

# lunch the script
Rscript Result_R_script_clean_2_green.R > Result_R_green.txt

# Clean the results
sed '/red/d' Result_R_green.txt > Result_R_green_clean.txt
awk '{print $1","$2","$3}' Result_R_green_clean.txt > Result_R_green_clean_2.txt

# Create a corresponding file
paste REViGO-FILL-5.xgmml Result_R_green_clean_2.txt > original_HEX_whith_RGB_green_corresponding.txt

# Clean the corresponding file
tr -d '\r' < original_HEX_whith_RGB_green_corresponding.txt > original_HEX_whith_RGB_green_corresponding2.txt

# kind of vlookup
sed "$(<original_HEX_whith_RGB_green_corresponding2.txt sed 's/\./\\./g' | xargs -n2 printf "s@%s@%s@g\n")" REViGO.xgmml > REViGO-whith-green-color.xgmml

# kind of vlookup to change the corresponding HEX orginal code of the original file by the new RGB colors
sed 's/fill="#/fill="rgb(/g' REViGO-whith-green-color.xgmml > REViGO-whith-green-color2.xgmml
sed 's/fill=\(.*\)\/\>/fill=\1)\/\>/g' REViGO-whith-green-color2.xgmml > REViGO-whith-green-color3.xgmml
sed 's/")/)"/g' REViGO-whith-green-color3.xgmml > REViGO-for-green-input.xgmml

rm REViGO-whith*
rm original*
rm Result_R*
rm REViGO-FILL*



