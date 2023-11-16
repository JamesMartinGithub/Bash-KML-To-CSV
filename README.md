# Bash-KML-To-CSV
A Bash script that converts storm data in a .kml file to .csv so that it can be plotted

# Code Explanation:
I began by looking at the structure of one of the .kml files in a text editor to find the required information blocks - I found that these were easily identifiable as the blocks begin with a string not found anywhere else in the file. I used the grep command to search for lines containing this string identifier, then stored those lines and 9 subsequent lines (of each) in an array called 'lines'. To achieve this I needed to temporarily change the IFS value of the bash shell to a newline delimiter, otherwise individual words were stored in the array and not lines.

I then used a for loop to iterate through this array and used a counter to track the meaning of each line - each data block has the same number of lines and lines in the same position represent the same data field. I used this fact to store each data block's field values in individual arrays for each field; I used the echo command to provide input to the awk command that splits each line into padding and data. I used pipes to use the output of echo as the input to awk.

Next I wrote the field names to a new csv file (as specified by passed arguments) along with the data for each field, for each weather plot. This used output pipes to set then update the file with each plot.
