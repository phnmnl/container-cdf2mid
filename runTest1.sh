#!/bin/bash

apt-get update -y && apt-get install -y --no-install-recommends wget ca-certificates zip

wget "https://drive.google.com/uc?export=donwload&id=1FHlrPdWjjCtO8SfTycdPGfhdtv3iaQqB" -O metdata 
wget "https://drive.google.com/uc?export=donwload&id=1KxisW75gvZuN9lDVa3Q2wdnhZqMOL0mF" -O roldan.zip

unzip roldan.zip -d data

runcdf2mid.R -i metdata -o cdf2midout.csv -z data
rc=$?; 
if [[ $rc != 0 ]]; then 
	echo "R process failed with error $rc"
	exit $rc; 
fi

if [ ! -f cdf2midout.csv ]; then
   	echo "File out_exchanged.csv does not exist, failing test."
   	exit 1
fi

echo "cdf2mid runs with test data without error codes, all expected files created."
