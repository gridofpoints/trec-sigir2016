#! /bin/sh

# Information
# 
# * *Author*: <mailto:silvello@dei.unipd.it Gianmaria Silvello>
# * *Version*: 1.00
# * *Since*: 1.00
# * *Requirements*: MATTERS 1.0 or higher; Matlab 2013b or higher
# * *Copyright:* (C) 2015 <http://ims.dei.unipd.it/ Information 
# Management Systems> (IMS) research group, <http://www.dei.unipd.it/ 
# Department of Information Engineering> (DEI), <http://www.unipd.it/ 
# University of Padua>, Italy
# * *License:* <http://www.apache.org/licenses/LICENSE-2.0 Apache License, 
# Version 2.0>

# This script creates different runs with Terrier using different settings


## declare the langs array
declare -a langs=("bg" "cs" "de" "en" "enCLEF" "es" "fa" "fi" "fr" "hu" "it" "nl" "pt" "ru" "sv");

if [ "$1" == "-h" ]; then
  printf "Usage: `basename $0` \n\n" >&2
  printf "Input parameters: \n" >&2
  printf "'-l': the language expressed as ISO 639-1 (two-letter codes); e.g. nl for Dutch or it for Italian.\n" >&2
  echo "Valid languages for experiments are: ${langs[@]}";
  printf "'-t': the track name. \n" >&2
  printf "'-c': the collection name. \n" >&2
  exit 0
else
	# check the input paramenters
	if [ $# -lt 4 ]; then
		echo "You must specify all the input parameters: -l, -c, -cp" 1>&2
		exit 1
	else
		echo "Starting the execution.";
		if [ "$1" == "-l" ]; then
			lang=$2;
			tmp=false;
			for i in "${langs[@]}"
			do
			    if [ "$i" == "$lang" ] ; then
			        tmp=true;
			        break;
			    fi
			done

			if  [ "$tmp" = false ]; then
				printf "first parameter must be the language -l expressed as ISO 639-1 (two-letter codes)\n";
  				echo "Valid languages for experiments are: ${langs[@]}";
  				exit 1
  			fi
  				 
		else
			echo "The first parameter must be the language -l expressed as ISO 639-1 (two-letter codes)"
			exit 1
		fi

		if [ "$3" == "-t" ]; then
			track_name=$4;
		else
			echo "The second parameter must be the track name -t; e.g. AH-CLEF2000"
			exit 1
		fi

		if [ "$5" == "-c" ]; then
			collection_name=$6;
		else
			echo "The second parameter must be the collection name -c; e.g. French_topics_AH-MONO-FR-CLEF2000"
			exit 1
		fi
	
	fi
fi


# get the osx
os=`uname`;

if [ "$os" == "Darwin" ] ; then
	corpus=/Users/silvello/Documents/LearningToRank/publications/2015_TVCG/corpus/TIPSTER;
elif [ "$os" == "Linux" ] ; then
	path=/data/silvello/performance-hypercube;
	if [ "$lang" == "en" ] ; then
		collectionPath=/data/silvello/experimental-collections/TREC;
	else
		collectionPath=/data/silvello/experimental-collections/CLEF;
	fi
else
	echo "Cannot locate the corpus for the os: $os";
  	exit 1
fi


indexDir="$path"/index;

# config dir
configDir=$path/config/terrier/;

# the lang of the topics
declare -A topicLang;

topicLang["bg"]="Bulgarian_topics";
topicLang["cs"]="Czech_topics";
topicLang["de"]="German_topics";
topicLang["enCLEF"]="English_topics";
topicLang["en"]="English_topics";
topicLang["es"]="Spanish_topics";
topicLang["fa"]="Persian_topics";
topicLang["fi"]="Finnish_topics";
topicLang["fr"]="French_topics";
topicLang["hu"]="Hungarian_topics";
topicLang["it"]="Italian_topics";
topicLang["nl"]="Dutch_topics";
topicLang["pt"]="Portuguese_topics";
topicLang["ru"]="Russian_topics";
topicLang["sv"]="Swedish_topics";

# the index to be used
declare -A indexNames;

indexNames["AH-MONO-BG-CLEF2005"]=bg_ah_mono_0507;
indexNames["AH-MONO-BG-CLEF2006"]=bg_ah_mono_0507;
indexNames["AH-MONO-BG-CLEF2007"]=bg_ah_mono_0507;

indexNames["AH-MONO-EN-TREC1996"]=en_tipster_96;
indexNames["AH-MONO-EN-TREC1997"]=en_tipster_97;
indexNames["AH-MONO-EN-TREC1998"]=en_tipster_9899;
indexNames["AH-MONO-EN-TREC1999"]=en_tipster_9899;
indexNames["ROB-MONO-EN-TREC2003"]=en_tipster_9899;
indexNames["ROB-MONO-EN-TREC2004"]=en_tipster_9899;

indexNames["AH-MONO-EN-CLEF2000"]=en_ah_mono_0002;
indexNames["AH-MONO-EN-CLEF2001"]=en_ah_mono_0002;
indexNames["AH-MONO-EN-CLEF2002"]=en_ah_mono_0002;

indexNames["AH-MONO-EN-CLEF2003"]=en_ah_mono_0306;
indexNames["AH-MONO-EN-CLEF2004"]=en_ah_mono_0306;
indexNames["AH-MONO-EN-CLEF2005"]=en_ah_mono_0306;
indexNames["AH-MONO-EN-CLEF2006"]=en_ah_mono_0306;

indexNames["AH-MONO-EN-CLEF2007"]=en_ah_mono_0707;

indexNames["AH-MONO-DE-CLEF2000"]=de_ah_mono_0000;

indexNames["AH-MONO-DE-CLEF2001"]=de_ah_rob_mono_0106;
indexNames["AH-MONO-DE-CLEF2002"]=de_ah_rob_mono_0106;
indexNames["AH-MONO-DE-CLEF2003"]=de_ah_rob_mono_0106;

indexNames["AH-MONO-ES-CLEF2001"]=es_ah_mono_0102;
indexNames["AH-MONO-ES-CLEF2002"]=es_ah_mono_0102;

indexNames["AH-MONO-ES-CLEF2003"]=es_ah_rob_mono_0306;

indexNames["AH-PERSIAN-MONO-FA-CLEF2008"]=fa_ah_mono_0809;
indexNames["AH-PERSIAN-MONO-FA-CLEF2009"]=fa_ah_mono_0809;

indexNames["AH-MONO-FI-CLEF2002"]=fi_ah_mono_0204;
indexNames["AH-MONO-FI-CLEF2003"]=fi_ah_mono_0204;
indexNames["AH-MONO-FI-CLEF2004"]=fi_ah_mono_0204;

indexNames["AH-MONO-FR-CLEF2000"]=fr_ah_mono_0000;

indexNames["AH-MONO-FR-CLEF2001"]=fr_ah_mono_0102;
indexNames["AH-MONO-FR-CLEF2002"]=fr_ah_mono_0102;

indexNames["AH-MONO-FR-CLEF2003"]=fr_ah_rob_mono_0307;

indexNames["AH-MONO-FR-CLEF2004"]=fr_ah_mono_0404;

indexNames["AH-MONO-FR-CLEF2005"]=fr_ah_mono_0506;
indexNames["AH-MONO-FR-CLEF2006"]=fr_ah_mono_0506;

indexNames["AH-MONO-HU-CLEF2005"]=hu_ah_mono_0507;
indexNames["AH-MONO-HU-CLEF2006"]=hu_ah_mono_0507;
indexNames["AH-MONO-HU-CLEF2007"]=hu_ah_mono_0507;

indexNames["AH-MONO-IT-CLEF2000"]=it_ah_mono_0002;
indexNames["AH-MONO-IT-CLEF2001"]=it_ah_mono_0002;
indexNames["AH-MONO-IT-CLEF2002"]=it_ah_mono_0002;

indexNames["AH-MONO-IT-CLEF2003"]=it_ah_rob_mono_0306;

indexNames["AH-MONO-NL-CLEF2001"]=nl_mono_0106;
indexNames["AH-MONO-NL-CLEF2002"]=nl_mono_0106;
indexNames["AH-MONO-NL-CLEF2003"]=nl_mono_0106;

indexNames["AH-MONO-PT-CLEF2004"]=pt_ah_mono_0404;

indexNames["AH-MONO-PT-CLEF2005"]=pt_ah_rob_mono_0506;
indexNames["AH-MONO-PT-CLEF2006"]=pt_ah_rob_mono_0506;

indexNames["AH-MONO-RU-CLEF2003"]=ru_ah_mono_0304;
indexNames["AH-MONO-RU-CLEF2004"]=ru_ah_mono_0304;

indexNames["AH-MONO-CS-CLEF2007"]=cs_ah_mono_0707;

indexNames["AH-MONO-SV-CLEF2002"]=sv_ah_mono_0203;
indexNames["AH-MONO-SV-CLEF2003"]=sv_ah_mono_0203;

# run paths
run_path=$path/runs;

systemDir="terrier-4.1";

# the system location
terrier=$path/systems/$systemDir;

# config dir, where properties files will be retrieved
configDir=$path/config/terrier/;

# declare the stoplists array
declare -a stopwords=(indri lucene mild proteus smart terrier nostop);

# declare the ngrams array
declare -a ngrams=(4grams 5grams nograms);

# declare the stemmer array
declare -a stemmers=(wkporter porter nostem krovetz lovins);

## declare the rank models array
declare -a models=("BB2" "BM25" "DFR_BM25" "DLH" "DLH13" "DPH" "DFRee" "Hiemstra_LM" "IFB2" "In_expB2" "In_expC2" "InL2" "LemurTF_IDF" "LGD" "PL2" "TF_IDF");

## declare the qe array
declare -a qe=("noqe");

## declare the topic field array
declare -a tfield=("td");

propertyFile="$terrier"/etc/terrier.properties

	for sl in "${stopwords[@]}"
	do
		for st in "${stemmers[@]}"
		do
			for expansion in "${qe[@]}"
			do
				for tf in "${tfield[@]}"
				do
					# set the topic fileds to be used for the query
					if [ "$tf" == "t" ]; then
						if [ "$lang" = "en" ]; then
							topic_command="-DTrecQueryTags.process=TOP,NUM,TITLE -DTrecQueryTags.skip=DESC,NARR";
						else
							topic_command="-DTrecQueryTags.process=topic,identifier,title -DTrecQueryTags.skip=<?xml,description,narrative";
						fi

					else
						if [ "$lang" = "en" ]; then
							topic_command="-DTrecQueryTags.process=TOP,NUM,TITLE,DESC -DTrecQueryTags.skip=NARR";
						else
							topic_command="-DTrecQueryTags.process=topic,identifier,title,description -DTrecQueryTags.skip=<?xml,narrative";					
						fi
					fi

					if [ "$st" == "${stemmers[0]}" -o "$st" == "${stemmers[1]}" ]; then

						indexName="$sl"_"$st"; 

						currIndexDir="$indexDir"/"${indexNames[$collection_name]}"/"$indexName";
						# build the name of the properties file to be used
						propertyTmpFile="$configDir"/"${indexNames[$collection_name]}"/"$indexName".properties;

						#copy the properties file in the right place with the right name for terrier
						cp $propertyTmpFile $propertyFile;

						for model in "${models[@]}"
						do
							# remove "_" char from the model name
							modelName=$(echo "$model" | sed 's/_//g');
							# build the runtag name
							runTag="$indexName"_"$modelName"_"$expansion"_"$tf";
							
							topics="$collectionPath"/"$track_name"/topics/"${topicLang[$lang]}"_"$collection_name".xml;

							runDir="$run_path"/"$track_name"/"$collection_name"/

							#create the dir if it does not exists
							if [ ! -d "$runDir" ]; then
								mkdir -p $runDir;
							fi

							runFile="$run_path"/"$track_name"/"$collection_name"/"$runTag".txt

							if [ "$expansion" == "qe" ]; then
								sh "$terrier"/bin/trec_terrier.sh -r -q -c 0.9 -Dtrec.model=$model -Dtrec.topics=$topics $topic_command -Dtrec.results.file=$runFile -Dtrec.runtag=$runTag
								rm "$runFile".settings;
								sed -i "s/$runTag.*/$runTag/g" $runFile;
								file=$(basename $runFile);

								name=$(echo $file | sed s/.txt//g);

								sed -i "s/$name.*/$name/g" "$runFile";
										
								#sed -i "s/Infinity/1000/g" "$runFile";
							else
								sh "$terrier"/bin/trec_terrier.sh -r -Dtrec.model=$model -Dtrec.topics=$topics $topic_command -Dtrec.results.file=$runFile -Dtrec.runtag=$runTag
								rm "$runFile".settings;
								sed -i "s/$runTag.*/$runTag/g" $runFile;
								file=$(basename $runFile);

								name=$(echo $file | sed s/.txt//g);

								sed -i "s/$name.*/$name/g" "$runFile";
										
								#sed -i "s/Infinity/1000/g" "$runFile";
							fi
						done
					else
						# no stemmer
						for grams in "${ngrams[@]}"
						do
							if [ "$grams" == "${ngrams[2]}" ]; then
								indexName="$sl"_"$st"; 

								currIndexDir="$indexDir"/"${indexNames[$collection_name]}"/"$indexName";
								# build the name of the properties file to be used
								propertyTmpFile="$configDir"/"${indexNames[$collection_name]}"/"$indexName".properties;

								#copy the properties file in the right place with the right name for terrier
								cp $propertyTmpFile $propertyFile;

								for model in "${models[@]}"
								do
									# remove "_" char from the model name
									modelName=$(echo "$model" | sed 's/_//g');
									# build the runtag name
									runTag="$indexName"_"$modelName"_"$expansion"_"$tf";
									
									topics="$collectionPath"/"$track_name"/topics/"${topicLang[$lang]}"_"$collection_name".xml;

									runDir="$run_path"/"$track_name"/"$collection_name"/

									#create the dir if it does not exists
									if [ ! -d "$runDir" ]; then
										mkdir -p $runDir;
									fi

									runFile="$run_path"/"$track_name"/"$collection_name"/"$runTag".txt

									if [ "$expansion" == "qe" ]; then
										sh "$terrier"/bin/trec_terrier.sh -r -q -c 0.9 -Dtrec.model=$model -Dtrec.topics=$topics $topic_command -Dtrec.results.file=$runFile -Dtrec.runtag=$runTag
										rm "$runFile".settings;
										sed -i "s/$runFile.*/$runFile/g" $runFile
										file=$(basename $runFile);

										name=$(echo $file | sed s/.txt//g);

										sed -i "s/$name.*/$name/g" "$runFile";
											
										#sed -i "s/Infinity/1000/g" "$runFile";
									else
										sh "$terrier"/bin/trec_terrier.sh -r -Dtrec.model=$model -Dtrec.topics=$topics $topic_command -Dtrec.results.file=$runFile -Dtrec.runtag=$runTag
										rm "$runFile".settings;
										sed -i "s/$runFile.*/$runFile/g" $runFile
										
										file=$(basename $runFile);

										name=$(echo $file | sed s/.txt//g);

										sed -i "s/$name.*/$name/g" "$runFile";
											
										#sed -i "s/Infinity/1000/g" "$runFile";

									fi
								done	
							else
								indexName="$sl"_"$grams"; 

								currIndexDir="$indexDir"/"${indexNames[$collection_name]}"/"$indexName";
								# build the name of the properties file to be used
								propertyTmpFile="$configDir"/"${indexNames[$collection_name]}"/"$indexName".properties;

								#copy the properties file in the right place with the right name for terrier
								cp $propertyTmpFile $propertyFile;

								for model in "${models[@]}"
								do
									# remove "_" char from the model name
									modelName=$(echo "$model" | sed 's/_//g');
									# build the runtag name
									runTag="$indexName"_"$modelName"_"$expansion"_"$tf";
									
									topics="$collectionPath"/"$track_name"/topics/"${topicLang[$lang]}"_"$collection_name".xml;

									runDir="$run_path"/"$track_name"/"$collection_name"/

									#create the dir if it does not exists
									if [ ! -d "$runDir" ]; then
										mkdir -p $runDir;
									fi

									runFile="$run_path"/"$track_name"/"$collection_name"/"$runTag".txt

									if [ "$expansion" == "qe" ]; then
										sh "$terrier"/bin/trec_terrier.sh -r -q -c 0.9 -Dtrec.model=$model -Dtrec.topics=$topics $topic_command -Dtrec.results.file=$runFile -Dtrec.runtag=$runTag
										rm "$runFile".settings;
										sed -i "s/$runFile.*/$runFile/g" $runFile
										file=$(basename $runFile);

										name=$(echo $file | sed s/.txt//g);

										sed -i "s/$name.*/$name/g" "$runFile";
											
										#sed -i "s/Infinity/1000/g" "$runFile";
									else
										sh "$terrier"/bin/trec_terrier.sh -r -Dtrec.model=$model -Dtrec.topics=$topics $topic_command -Dtrec.results.file=$runFile -Dtrec.runtag=$runTag
										rm "$runFile".settings;
										sed -i "s/$runFile.*/$runFile/g" $runFile
										
										file=$(basename $runFile);

										name=$(echo $file | sed s/.txt//g);

										sed -i "s/$name.*/$name/g" "$runFile";
											
										#sed -i "s/Infinity/1000/g" "$runFile";

									fi
								done	
							fi

						done
					fi

				done # topic fields for
			done #qe for

		done
	done






