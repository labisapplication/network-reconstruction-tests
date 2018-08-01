all: data/InSilicoSize10-Yeast1_dream4_timeseries.tsv iota/IOTA.R

gnw/:
	git clone https://github.com/tschaffter/gnw --depth 1

data/:
	mkdir $@

data/InSilicoSize10-Yeast1_dream4_timeseries.tsv: gnw/ data/
	java -jar gnw/gnw-3.1.2b.jar --simulate --input-net gnw/sandbox/InSilicoSize10-Yeast1.xml --output-path "$(pwd)/datasets"
	mv *.tsv *.xml data/

iota/IOTA.R: iota/
	wget http://tocsy.pik-potsdam.de/IOTA/IOTA.zip
	mv IOTA.zip iota/
	cd iota && unzip IOTA.zip

iota/:
	mkdir iota/

clean:
	rm -rf gnw/ data/ iota/
