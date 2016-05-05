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

# This script creates the indexes for Terrier with different settings


## declare the langs array
declare -a langs=("bg" "cs" "de" "en" "enCLEF" "es" "fa" "fi" "fr" "hu" "it" "nl" "pt" "ru" "sv");

declare -a collections=("en_tipster_9899" "en_tipster_97" "en_tipster_96" "en_ah_mono_0002" "en_ah_mono_0306" "en_ah_mono_0707" "bg_ah_mono_0507" "de_ah_mono_0000" "de_ah_rob_mono_0106" "es_ah_mono_0102" "es_ah_rob_mono_0306" "fa_ah_mono_0809" "fi_ah_mono_0204" "fr_ah_mono_0000" "fr_ah_mono_0102" "fr_ah_rob_mono_0307" "fr_ah_mono_0404" "fr_ah_mono_0506" "hu_ah_mono_0507" "it_ah_mono_0002" "it_ah_rob_mono_0306" "nl_mono_0106" "pt_ah_mono_0404" "pt_ah_rob_mono_0506" "ru_ah_mono_0304" "cs_ah_mono_0707" "sv_ah_mono_0203");


if [ "$1" == "-h" ]; then
  printf "Usage: `basename $0` \n\n" >&2
  printf "Input parameters: \n" >&2
  printf "'-l': the language expressed as ISO 639-1 (two-letter codes); e.g. nl for Dutch or it for Italian.\n" >&2
  echo "Valid languages for experiments are: ${langs[@]}";
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

		if [ "$3" == "-c" ]; then
			collection_name=$4;
			tmp=false;
			for i in "${collections[@]}"
			do
			    if [ "$i" == "$collection_name" ] ; then
			        tmp=true;
			        break;
			    fi
			done

			if  [ "$tmp" = false ]; then
				printf "second parameter must be the collection name -c \n";
  				echo "Valid collection names for experiments are: ${collections[@]}";
  				exit 1
  			fi
		else
			echo "The second parameter must be the collection name -c"
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
		corpus=/data/silvello/experimental-collections/TIPSTER/;
	else
		corpus=/data/silvello/experimental-collections/CLEF/;
	fi
else
	echo "Cannot locate the corpus for the os: $os";
  	exit 1
fi

## create the tmp dir for the corpus
mkdir "$path"/corpus;

systemDir="terrier-4.1";

# the system location
terrier=$path/systems/$systemDir;

# a map between the collection name and the corpora
declare -A corpusPaths;

corpusPaths["bg_ah_mono_0507"]="$corpus"AH-CLEF2005/documents/AH-MONO-BG-CLEF2005;

corpusPaths["cs_ah_mono_0707"]="$corpus"AH-CLEF2007/documents/AH-MONO-CS-CLEF2007;

corpusPaths["de_ah_mono_0000"]="$corpus"AH-CLEF2000/documents/AH-MONO-DE-CLEF2000;

corpusPaths["de_ah_rob_mono_0106"]="$corpus"AH-CLEF2001/documents/AH-MONO-DE-CLEF2001;

corpusPaths["en_ah_mono_0002"]="$corpus"AH-CLEF2000/documents/AH-MONO-EN-CLEF2000;

corpusPaths["en_ah_mono_0306"]="$corpus"AH-CLEF2003/documents/AH-MONO-EN-CLEF2003;

corpusPaths["en_ah_mono_0707"]="$corpus"AH-CLEF2007/documents/AH-MONO-EN-CLEF2007;

corpusPaths["en_tipster_96"]="$corpus"TREC5Corpus;

corpusPaths["en_tipster_97"]="$corpus"TREC6Corpus;

corpusPaths["en_tipster_9899"]="$corpus"TREC7Corpus;

corpusPaths["es_ah_mono_0102"]="$corpus"AH-CLEF2001/documents/AH-MONO-ES-CLEF2001;

corpusPaths["es_ah_rob_mono_0306"]="$corpus"AH-CLEF2003/documents/AH-MONO-ES-CLEF2003;

corpusPaths["fa_ah_mono_0809"]="$corpus"AH-PERSIAN-CLEF2008/documents/AH-PERSIAN-MONO-FA-CLEF2008;

corpusPaths["fi_ah_mono_0204"]="$corpus"AH-CLEF2002/documents/AH-MONO-FI-CLEF2002;

corpusPaths["fr_ah_mono_0000"]="$corpus"AH-CLEF2000/documents/AH-MONO-FR-CLEF2000;

corpusPaths["fr_ah_mono_0102"]="$corpus"AH-CLEF2001/documents/AH-MONO-FR-CLEF2001;

corpusPaths["fr_ah_rob_mono_0307"]="$corpus"AH-CLEF2003/documents/AH-MONO-FR-CLEF2003;

corpusPaths["fr_ah_mono_0404"]="$corpus"AH-CLEF2004/documents/AH-MONO-FR-CLEF2004;

corpusPaths["fr_ah_mono_0506"]="$corpus"AH-CLEF2005/documents/AH-MONO-FR-CLEF2005;

corpusPaths["hu_ah_mono_0507"]="$corpus"AH-CLEF2005/documents/AH-MONO-HU-CLEF2005;

corpusPaths["it_ah_mono_0002"]="$corpus"AH-CLEF2000/documents/AH-MONO-IT-CLEF2000;

corpusPaths["it_ah_rob_mono_0306"]="$corpus"AH-CLEF2003/documents/AH-MONO-IT-CLEF2003;

corpusPaths["nl_ah_mono_0106"]="$corpus"AH-CLEF2001/documents/AH-MONO-NL-CLEF2001;

corpusPaths["pt_ah_mono_0404"]="$corpus"AH-CLEF2004/documents/AH-MONO-PT-CLEF2004;

corpusPaths["pt_ah_rob_mono_0506"]="$corpus"AH-CLEF2005/documents/AH-MONO-PT-CLEF2005;

corpusPaths["ru_ah_mono_0304"]="$corpus"AH-CLEF2003/documents/AH-MONO-RU-CLEF2003;

corpusPaths["sv_ah_mono_0203"]="$corpus"AH-CLEF2002/documents/AH-MONO-SV-CLEF2002;


## the corpus sizes
BG_0507_CORPUS_SIZE=69195;
DE_0000_CORPUS_SIZE=139715;
DE_0106_CORPUS_SIZE=225371;
ES_0102_CORPUS_SIZE=215738;
ES_0306_CORPUS_SIZE=454045;
FA_CORPUS_SIZE=166774;
FI_CORPUS_SIZE=55344;
FR_0000_CORPUS_SIZE=44013;
FR_0102_CORPUS_SIZE=87191;
FR_0307_CORPUS_SIZE=129806;
FR_0404_CORPUS_SIZE=90261;
FR_0506_CORPUS_SIZE=177452;
HU_0507_CORPUS_SIZE=49530;
IT_0002_CORPUS_SIZE=108578;
IT_0306_CORPUS_SIZE=157558;
NL_CORPUS_SIZE=190604;
PT_0404_CORPUS_SIZE=106821;
PT_0506_CORPUS_SIZE=210734;
RU_CORPUS_SIZE=16716;
SV_CORPUS_SIZE=142819;

# config dir, where properties files will be stored
configDir=$path/config/terrier/;

if  [ "$verbose" = true ]; then
	printf "Creating the %s corpus copying the documents from %s into the directory corpus \n" "$lang" "$collection_path" >&2
fi


#stoplists path
sl_path=$path/resources/stoplists/"$lang"/;


## declare the stoplists array
declare -a stopwords=(stop nostop);

declare -a ngrams=(4grams 5grams nograms);
		
case "$lang" in
    bg) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(BulgarianStemmerLight BulgarianStemmerAgressive NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "bg_ah_mono_0507" ]; then
			indexDir=$path/index/bg_ah_mono_0507/
			propertyDir=$path/config/terrier/bg_ah_mono_0507/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi
			
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

		ls -1 ${corpusPaths["bg_ah_mono_0507"]}/SEGA2002 | xargs -i cp ${corpusPaths["bg_ah_mono_0507"]}/SEGA2002/{} "$path"/corpus;
		ls -1 ${corpusPaths["bg_ah_mono_0507"]}/STANDART2002 | xargs -i cp ${corpusPaths["bg_ah_mono_0507"]}/STANDART2002/{} "$path"/corpus;

		## create the collection.spec file needed for indexing purposes
		"$terrier"/bin/trec_setup.sh ./corpus

		## count the number of docs
		docs=$(wc -l < "$terrier"/etc/collection.spec);
		##let "docs-=1";
		let docs=$docs-1;
		
		## check if the total number of docs to be indexes is correct
		if [ "$BG_0507_CORPUS_SIZE" != "$docs" ]; then
			printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$BG_0507_CORPUS_SIZE" >&2
			exit 1
		fi

       ;; 

    cs) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakCzechStemmer CzechAggressiveStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "cs_ah_mono_0707" ]; then
			indexDir=$path/index/cs_ah_mono_0707/
			propertyDir=$path/config/terrier/cs_ah_mono_0707/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	

			fi
			
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

		ls -1 ${corpusPaths["cs_ah_mono_0707"]}/LIDOVE2002 | xargs -i cp ${corpusPaths["cs_ah_mono_0707"]}/LIDOVE2002/{} "$path"/corpus;
		ls -1 ${corpusPaths["cs_ah_mono_0707"]}/MLADA2002 | xargs -i cp ${corpusPaths["cs_ah_mono_0707"]}/MLADA2002/{} "$path"/corpus;

		## create the collection.spec file needed for indexing purposes
		"$terrier"/bin/trec_setup.sh ./corpus

       ;;    
    de) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakGermanStemmer GermanSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "de_ah_mono_0000" ]; then
			indexDir=$path/index/de_ah_mono_0000/
			propertyDir=$path/config/terrier/de_ah_mono_0000/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["de_ah_mono_0000"]}/FRANKFURTER1994 | xargs -i cp ${corpusPaths["de_ah_mono_0000"]}/FRANKFURTER1994/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$DE_0000_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$DE_0000_CORPUS_SIZE" >&2
				exit 1
			fi

		elif [ "$collection_name" == "de_ah_rob_mono_0106" ]; then
			indexDir=$path/index/de_ah_rob_mono_0106/
			propertyDir=$path/config/terrier/de_ah_rob_mono_0106/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["de_ah_rob_mono_0106"]}/FRANKFURTER1994 | xargs -i cp ${corpusPaths["de_ah_rob_mono_0106"]}/FRANKFURTER1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["de_ah_rob_mono_0106"]}/SDA1994 | xargs -i cp ${corpusPaths["de_ah_rob_mono_0106"]}/SDA1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["de_ah_rob_mono_0106"]}/SPIEGEL1994 | xargs -i cp ${corpusPaths["de_ah_rob_mono_0106"]}/SPIEGEL1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["de_ah_rob_mono_0106"]}/SPIEGEL1995 | xargs -i cp ${corpusPaths["de_ah_rob_mono_0106"]}/SPIEGEL1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$DE_0106_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$DE_0106_CORPUS_SIZE" >&2
				exit 1
			fi
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

       ;; 

    en) indexDir="$lang";

				## declare the stemmers available
			declare -a stemmers=(WeakPorterStemmer PorterStemmer NoStemmer KrovetzStemmer);
			declare -a stemmerNames=(wkporter porter nostem krovetz lovins);

			#declare the stoplist ONLY for TREC English
			declare -a stopwords=(indri lucene smart terrier nostop);
			
			if [ "$collection_name" == "en_tipster_96" ]; then
				indexDir=$path/index/en_tipster_96/
				propertyDir=$path/config/terrier/en_tipster_96/
				
				# create the index dir if it does not exist
				if [ ! -d "$indexDir" ]; then
	  				mkdir $indexDir;	
	  				mkdir $propertyDir;	
				fi

				"$terrier"/bin/trec_setup.sh ${corpusPaths["en_tipster_96"]}

			elif [ "$collection_name" == "en_tipster_97" ]; then
				indexDir=$path/index/en_tipster_97/
				propertyDir=$path/config/terrier/en_tipster_97/
				
				# create the index dir if it does not exist
				if [ ! -d "$indexDir" ]; then
	  				mkdir $indexDir;	
	  				mkdir $propertyDir;	
				fi

				"$terrier"/bin/trec_setup.sh ${corpusPaths["en_tipster_97"]}

			elif [ "$collection_name" == "en_tipster_9899" ]; then
				indexDir=$path/index/en_tipster_9899/
				propertyDir=$path/config/terrier/en_tipster_9899/
				
				# create the index dir if it does not exist
				if [ ! -d "$indexDir" ]; then
	  				mkdir $indexDir;	
	  				mkdir $propertyDir;	
				fi

				## create the collection.spec file needed for indexing purposes
				"$terrier"/bin/trec_setup.sh ${corpusPaths["en_tipster_9899"]}
					
				else
					printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
					exit 1
				fi

	       ;; 

    enCLEF) indexDir="$lang";

				## declare the stemmers available
			declare -a stemmers=(WeakPorterStemmer PorterStemmer NoStemmer);
			declare -a stemmerNames=(wkstem agstem nostem);

			if [ "$collection_name" == "en_ah_mono_0002" ]; then
				indexDir=$path/index/en_ah_mono_0002/
				propertyDir=$path/config/terrier/en_ah_mono_0002/
				
				# create the index dir if it does not exist
				if [ ! -d "$indexDir" ]; then
	  				mkdir $indexDir;	
	  				mkdir $propertyDir;	
				fi

				ls -1 ${corpusPaths["en_ah_mono_0002"]}/LATIMES1994 | xargs -i cp ${corpusPaths["en_ah_mono_0002"]}/LATIMES1994/{} "$path"/corpus;

				## create the collection.spec file needed for indexing purposes
				"$terrier"/bin/trec_setup.sh ./corpus

				## count the number of docs
				docs=$(wc -l < "$terrier"/etc/collection.spec);

			elif [ "$collection_name" == "en_ah_mono_0306" ]; then
				indexDir=$path/index/en_ah_mono_0306/
				propertyDir=$path/config/terrier/en_ah_mono_0306/
				
				# create the index dir if it does not exist
				if [ ! -d "$indexDir" ]; then
	  				mkdir $indexDir;	
	  				mkdir $propertyDir;	
				fi

				ls -1 ${corpusPaths["en_ah_mono_0306"]}/LATIMES1994 | xargs -i cp ${corpusPaths["en_ah_mono_0306"]}/LATIMES1994/{} "$path"/corpus;
				ls -1 ${corpusPaths["en_ah_mono_0306"]}/GLASGOW1995 | xargs -i cp ${corpusPaths["en_ah_mono_0306"]}/GLASGOW1995/{} "$path"/corpus;

				## create the collection.spec file needed for indexing purposes
				"$terrier"/bin/trec_setup.sh ./corpus

				## count the number of docs
				docs=$(wc -l < "$terrier"/etc/collection.spec);

			elif [ "$collection_name" == "en_ah_mono_0707" ]; then
				indexDir=$path/index/en_ah_mono_0707/
				propertyDir=$path/config/terrier/en_ah_mono_0707/
				
				# create the index dir if it does not exist
				if [ ! -d "$indexDir" ]; then
	  				mkdir $indexDir;	
	  				mkdir $propertyDir;	
				fi

				ls -1 ${corpusPaths["en_ah_mono_0707"]}/LATIMES2002 | xargs -i cp ${corpusPaths["en_ah_mono_0707"]}/LATIMES2002/{} "$path"/corpus;

				## create the collection.spec file needed for indexing purposes
				"$terrier"/bin/trec_setup.sh ./corpus

				## count the number of docs
				docs=$(wc -l < "$terrier"/etc/collection.spec);	
				
			else
				printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
				exit 1
			fi

	       ;; 

    es) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakSpanishStemmer SpanishSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "es_ah_mono_0102" ]; then
			indexDir=$path/index/es_ah_mono_0102/
			propertyDir=$path/config/terrier/es_ah_mono_0102/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			cp -Lr ${corpusPaths["es_ah_mono_0102"]}/EFE1994 "$path"/corpus

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$ES_0102_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$ES_0102_CORPUS_SIZE" >&2
				exit 1
			fi

		elif [ "$collection_name" == "es_ah_rob_mono_0306" ]; then
			indexDir=$path/index/es_ah_rob_mono_0306/
			propertyDir=$path/config/terrier/es_ah_rob_mono_0306/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			cp -Lr ${corpusPaths["es_ah_rob_mono_0306"]}/EFE1994 "$path"/corpus
			cp -Lr ${corpusPaths["es_ah_rob_mono_0306"]}/EFE1995 "$path"/corpus

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$ES_0306_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$ES_0306_CORPUS_SIZE" >&2
				exit 1
			fi
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

       ;; 

    fa) indexDir="$lang";

		# TO DO
       ;;    
    fi) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakFinnishStemmer FinnishSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "fi_ah_mono_0204" ]; then
			indexDir=$path/index/fi_ah_mono_0204/
			propertyDir=$path/config/terrier/fi_ah_mono_0204/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi
			
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

		ls -1 ${corpusPaths["fi_ah_mono_0204"]}/AAMULEHTI1994 | xargs -i cp ${corpusPaths["fi_ah_mono_0204"]}/AAMULEHTI1994/{} "$path"/corpus;
		ls -1 ${corpusPaths["fi_ah_mono_0204"]}/AAMULEHTI1995 | xargs -i cp ${corpusPaths["fi_ah_mono_0204"]}/AAMULEHTI1995/{} "$path"/corpus;

		## create the collection.spec file needed for indexing purposes
		"$terrier"/bin/trec_setup.sh ./corpus

		## count the number of docs
		docs=$(wc -l < "$terrier"/etc/collection.spec);
		##let "docs-=1";
		let docs=$docs-1;
		
		## check if the total number of docs to be indexes is correct
		if [ "$FI_CORPUS_SIZE" != "$docs" ]; then
			printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$FI_CORPUS_SIZE" >&2
			exit 1
		fi
       ;;  

    fr) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakFrenchStemmer FrenchSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "fr_ah_mono_0000" ]; then
			indexDir=$path/index/fr_ah_mono_0000/
			propertyDir=$path/config/terrier/fr_ah_mono_0000/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["fr_ah_mono_0000"]}/LEMONDE1994 | xargs -i cp ${corpusPaths["fr_ah_mono_0000"]}/LEMONDE1994/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$FR_0000_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$FR_0000_CORPUS_SIZE" >&2
				exit 1
			fi

		elif [ "$collection_name" == "fr_ah_mono_0102" ]; then
			indexDir=$path/index/fr_ah_mono_0102/
			propertyDir=$path/config/terrier/fr_ah_mono_0102/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["fr_ah_mono_0102"]}/LEMONDE1994 | xargs -i cp ${corpusPaths["fr_ah_mono_0102"]}/LEMONDE1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_mono_0102"]}/ATS1994 | xargs -i cp ${corpusPaths["fr_ah_mono_0102"]}/ATS1994/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$FR_0102_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$FR_0102_CORPUS_SIZE" >&2
				exit 1
			fi
		elif [ "$collection_name" == "fr_ah_rob_mono_0307" ]; then
			indexDir=$path/index/fr_ah_rob_mono_0307/
			propertyDir=$path/config/terrier/fr_ah_rob_mono_0307/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["fr_ah_rob_mono_0307"]}/LEMONDE1994 | xargs -i cp ${corpusPaths["fr_ah_rob_mono_0307"]}/LEMONDE1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_rob_mono_0307"]}/ATS1994 | xargs -i cp ${corpusPaths["fr_ah_rob_mono_0307"]}/ATS1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_rob_mono_0307"]}/ATS1995 | xargs -i cp ${corpusPaths["fr_ah_rob_mono_0307"]}/ATS1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$FR_0307_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$FR_0307_CORPUS_SIZE" >&2
				exit 1
			fi		
		elif [ "$collection_name" == "fr_ah_mono_0404" ]; then
			indexDir=$path/index/fr_ah_mono_0404/
			propertyDir=$path/config/terrier/fr_ah_mono_0404/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["fr_ah_mono_0404"]}/LEMONDE1995 | xargs -i cp ${corpusPaths["fr_ah_mono_0404"]}/LEMONDE1995/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_mono_0404"]}/ATS1995 | xargs -i cp ${corpusPaths["fr_ah_mono_0404"]}/ATS1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$FR_0404_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$FR_0404_CORPUS_SIZE" >&2
				exit 1
			fi				
		elif [ "$collection_name" == "fr_ah_mono_0506" ]; then
			indexDir=$path/index/fr_ah_mono_0506/
			propertyDir=$path/config/terrier/fr_ah_mono_0506/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["fr_ah_mono_0506"]}/LEMONDE1994 | xargs -i cp ${corpusPaths["fr_ah_mono_0506"]}/LEMONDE1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_mono_0506"]}/LEMONDE1995 | xargs -i cp ${corpusPaths["fr_ah_mono_0506"]}/LEMONDE1995/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_mono_0506"]}/ATS1994 | xargs -i cp ${corpusPaths["fr_ah_mono_0506"]}/ATS1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["fr_ah_mono_0506"]}/ATS1995 | xargs -i cp ${corpusPaths["fr_ah_mono_0506"]}/ATS1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$FR_0506_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$FR_0506_CORPUS_SIZE" >&2
				exit 1
			fi	

		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

       ;;    
    hu) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakHungarianStemmer HungarianSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "hu_ah_mono_0507" ]; then
			indexDir=$path/index/hu_ah_mono_0507/
			propertyDir=$path/config/terrier/hu_ah_mono_0507/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi
			
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

		ls -1 ${corpusPaths["hu_ah_mono_0507"]}/MAGYAR2002 | xargs -i cp ${corpusPaths["hu_ah_mono_0507"]}/MAGYAR2002/{} "$path"/corpus;

		## create the collection.spec file needed for indexing purposes
		"$terrier"/bin/trec_setup.sh ./corpus

		## count the number of docs
		docs=$(wc -l < "$terrier"/etc/collection.spec);
		##let "docs-=1";
		let docs=$docs-1;
		
		## check if the total number of docs to be indexes is correct
		if [ "$HU_0507_CORPUS_SIZE" != "$docs" ]; then
			printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$HU_0507_CORPUS_SIZE" >&2
			exit 1
		fi

       ;;    
    it) indexDir="$lang";
		
		## declare the stemmers available
		declare -a stemmers=(WeakItalianStemmer ItalianSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "it_ah_mono_0002" ]; then
			indexDir=$path/index/it_ah_mono_0002/
			propertyDir=$path/config/terrier/it_ah_mono_0002/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["it_ah_mono_0002"]}/LASTAMPA1994 | xargs -i cp ${corpusPaths["it_ah_mono_0002"]}/LASTAMPA1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["it_ah_mono_0002"]}/AGZ1994 | xargs -i cp ${corpusPaths["it_ah_mono_0002"]}/AGZ1994/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$IT_0002_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$IT_0002_CORPUS_SIZE" >&2
				exit 1
			fi

		elif [ "$collection_name" == "it_ah_rob_mono_0306" ]; then
			indexDir=$path/index/it_ah_rob_mono_0306/
			propertyDir=$path/config/terrier/it_ah_rob_mono_0306/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["it_ah_rob_mono_0306"]}/LASTAMPA1994 | xargs -i cp ${corpusPaths["it_ah_rob_mono_0306"]}/LASTAMPA1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["it_ah_rob_mono_0306"]}/AGZ1994 | xargs -i cp ${corpusPaths["it_ah_rob_mono_0306"]}/AGZ1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["it_ah_rob_mono_0306"]}/AGZ1995 | xargs -i cp ${corpusPaths["it_ah_rob_mono_0306"]}/AGZ1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$IT_0306_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$IT_0306_CORPUS_SIZE" >&2
				exit 1
			fi
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

       ;;
    nl) indexDir="$lang";

		# TO DO
       ;;  
    pt) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakPortugueseStemmer PortugueseSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "pt_ah_mono_0404" ]; then
			indexDir=$path/index/pt_ah_mono_0404/
			propertyDir=$path/config/terrier/pt_ah_mono_0404/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["pt_ah_mono_0404"]}/PUBLICO1994 | xargs -i cp ${corpusPaths["pt_ah_mono_0404"]}/PUBLICO1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["pt_ah_mono_0404"]}/PUBLICO1995 | xargs -i cp ${corpusPaths["pt_ah_mono_0404"]}/PUBLICO1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$PT_0404_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$PT_0404_CORPUS_SIZE" >&2
				exit 1
			fi

		elif [ "$collection_name" == "pt_ah_rob_mono_0506" ]; then
			indexDir=$path/index/pt_ah_rob_mono_0506/
			propertyDir=$path/config/terrier/pt_ah_rob_mono_0506/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi

			ls -1 ${corpusPaths["pt_ah_rob_mono_0506"]}/PUBLICO1994 | xargs -i cp ${corpusPaths["pt_ah_rob_mono_0506"]}/PUBLICO1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["pt_ah_rob_mono_0506"]}/PUBLICO1995 | xargs -i cp ${corpusPaths["pt_ah_rob_mono_0506"]}/PUBLICO1995/{} "$path"/corpus;
			ls -1 ${corpusPaths["pt_ah_rob_mono_0506"]}/FOLHA1994 | xargs -i cp ${corpusPaths["pt_ah_rob_mono_0506"]}/FOLHA1994/{} "$path"/corpus;
			ls -1 ${corpusPaths["pt_ah_rob_mono_0506"]}/FOLHA1995 | xargs -i cp ${corpusPaths["pt_ah_rob_mono_0506"]}/FOLHA1995/{} "$path"/corpus;

			## create the collection.spec file needed for indexing purposes
			"$terrier"/bin/trec_setup.sh ./corpus

			## count the number of docs
			docs=$(wc -l < "$terrier"/etc/collection.spec);
			##let "docs-=1";
			let docs=$docs-1;
			
			## check if the total number of docs to be indexes is correct
			if [ "$PT_0506_CORPUS_SIZE" != "$docs" ]; then
				printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$PT_0506_CORPUS_SIZE" >&2
				exit 1
			fi
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

       ;;
    ru) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakRussianStemmer RussianSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "ru_ah_mono_0304" ]; then
			indexDir=$path/index/ru_ah_mono_0304/
			propertyDir=$path/config/terrier/ru_ah_mono_0304/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi
			
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

		ls -1 ${corpusPaths["ru_ah_mono_0304"]}/IZVESTIA1995 | xargs -i cp ${corpusPaths["ru_ah_mono_0304"]}/IZVESTIA1995/{} "$path"/corpus;

		## create the collection.spec file needed for indexing purposes
		"$terrier"/bin/trec_setup.sh ./corpus

		## count the number of docs
		docs=$(wc -l < "$terrier"/etc/collection.spec);
		##let "docs-=1";
		let docs=$docs-1;
		
		## check if the total number of docs to be indexes is correct
		if [ "$RU_CORPUS_SIZE" != "$docs" ]; then
			printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$RU_CORPUS_SIZE" >&2
			exit 1
		fi
       ;;         
    sv) indexDir="$lang";

		## declare the stemmers available
		declare -a stemmers=(WeakSwedishStemmer SwedishSnowballStemmer NoStemmer);
		declare -a stemmerNames=(wkstem agstem nostem);

		if [ "$collection_name" == "sv_ah_mono_0203" ]; then
			indexDir=$path/index/sv_ah_mono_0203/
			propertyDir=$path/config/terrier/sv_ah_mono_0203/
			
			# create the index dir if it does not exist
			if [ ! -d "$indexDir" ]; then
  				mkdir $indexDir;	
  				mkdir $propertyDir;	
			fi
			
		else
			printf "The collection %s is not allowed for the language %s \n" "$collection_name" "$lang" >&2
			exit 1
		fi

		ls -1 ${corpusPaths["sv_ah_mono_0203"]}/TT1994 | xargs -i cp ${corpusPaths["sv_ah_mono_0203"]}/TT1994/{} "$path"/corpus;
		ls -1 ${corpusPaths["sv_ah_mono_0203"]}/TT1995 | xargs -i cp ${corpusPaths["sv_ah_mono_0203"]}/TT1995/{} "$path"/corpus;

		## create the collection.spec file needed for indexing purposes
		"$terrier"/bin/trec_setup.sh ./corpus

		## count the number of docs
		docs=$(wc -l < "$terrier"/etc/collection.spec);
		##let "docs-=1";
		let docs=$docs-1;
		
		## check if the total number of docs to be indexes is correct
		if [ "$SV_CORPUS_SIZE" != "$docs" ]; then
			printf "The size (%s docs) of the current corpus does not correspond to the corpus size used for defining the baselines; indeed, the %s corpus must count %s documents.\n" "$docs" "$lang" "$SV_CORPUS_SIZE" >&2
			exit 1
		fi
       ;;   
  esac

## create the terrier.properties file
create_terrier_properties()
{
	if  [ "$verbose" = true ]; then
		printf "Creating the terrier.properties file \n"
	fi
	
     # initialize a local var
     local file="$terrier/etc/terrier.properties";

     # check if file exists. 
     if [ ! -f "$file" ] ; then
         # if not create the file
         touch "$file"
     else
     	rm "$file"
     	touch "$file";
     fi

	printf "
	#default controls for query expansion
	querying.postprocesses.order=QueryExpansion
	querying.postprocesses.controls=qe:QueryExpansion
	#default controls for the web-based interface. SimpleDecorate
	#is the simplest metadata decorator. For more control, see Decorate.
	querying.postfilters.order=SimpleDecorate,SiteFilter,Scope
	querying.postfilters.controls=decorate:SimpleDecorate,site:SiteFilter,scope:Scope

	#default and allowed controls
	querying.default.controls=
	querying.allowed.controls=scope,qe,qemodel,start,end,site,scope

	#document tags specification
	#for processing the contents of
	#the documents, ignoring DOCHDR
	TrecDocTags.doctag=DOC
	TrecDocTags.idtag=DOCNO
	TrecDocTags.skip=DOCID
	#set to true if the tags can be of various case
	TrecDocTags.casesensitive=false
	max.term.length=40
	ignore.low.idf.terms=false\n" >> "$file"

	if [ "$lang" = "en" ]; then
		printf "tokeniser=EnglishTokeniser
		TrecQueryTags.doctag=TOP
		TrecQueryTags.idtag=NUM\n" >> "$file"
	elif [ "$lang" = "enCLEF" ]; then
		printf "tokeniser=EnglishTokeniser
		TrecQueryTags.doctag=topic
		TrecQueryTags.idtag=identifier\n" >> "$file"
	else
		printf "tokeniser=UTFTokeniser
		trec.encoding=UTF-8
		#query tags specification
		TrecQueryTags.doctag=topic
		TrecQueryTags.idtag=identifier\n" >> "$file"
	fi

	if [ "$lang" = "fr" ]; then
		printf "indexer.meta.forward.keylens=64\n" >> "$file"

	fi

	if [ "$gramCond" = true ]; then
		if [ "$gram" = "${ngrams[0]}" ]; then
			printf "tokeniser.ngram=4\n" >> "$file"
		elif [ "$gram" = "${ngrams[1]}" ]; then
			printf "tokeniser.ngram=5\n" >> "$file"
		fi
	fi

      printf "stopwords.filename=%s\n" "$stoplist" >> "$file"

      if [ "$slCond" = true -a "$gramCond" = false -a "$stCond" = true ]; then
			 printf "termpipelines=%s,%s\n" "Stopwords" "$st" >> "$file"
	  elif [ "$slCond" = true -a "$gramCond" = false -a "$stCond" = false ]; then
			printf "termpipelines=%s\n" "Stopwords">> "$file"
	  elif [ "$slCond" = true -a "$gramCond" = true -a "$stCond" = false ]; then
			printf "termpipelines=%s,%s\n" "Stopwords" "BasicNGramsTokenizer">> "$file"
	  elif [ "$slCond" = false -a "$gramCond" = true -a "$stCond" = false ]; then
			printf "termpipelines=%s\n" "BasicNGramsTokenizer">> "$file"			
      elif [ "$slCond" = false -a "$gramCond" = false -a "$stCond" = true ]; then
			printf "termpipelines=%s\n" "$st">> "$file"
	  else		
	  		printf "termpipelines=\n">> "$file"
	  fi
     
     printf "terrier.index.path=%s\n" "$currIndexDir">> "$file"
     
     # copy the file in the property directory 
     cp $file $propertyDir$propertyName

 }

## create the terrier.properties file
create_terrier_query_properties()
{
	if  [ "$verbose" = true ]; then
		printf "Creating the terrier.properties file \n"
	fi
	
     # initialize a local var
     local file="$terrier/etc/terrier.properties";

     # check if file exists. 
     if [ ! -f "$file" ] ; then
         # if not create the file
         touch "$file"
     else
     	rm "$file"
     	touch "$file";
     fi

	printf "#default controls for query expansion
	querying.postprocesses.order=QueryExpansion
	querying.postprocesses.controls=qe:QueryExpansion
	#default controls for the web-based interface. SimpleDecorate
	#is the simplest metadata decorator. For more control, see Decorate.
	querying.postfilters.order=SimpleDecorate,SiteFilter,Scope
	querying.postfilters.controls=decorate:SimpleDecorate,site:SiteFilter,scope:Scope

	#default and allowed controls
	querying.default.controls=
	querying.allowed.controls=scope,qe,qemodel,start,end,site,scope

	#document tags specification
	#for processing the contents of
	#the documents, ignoring DOCHDR
	TrecDocTags.doctag=DOC
	TrecDocTags.idtag=DOCNO
	TrecDocTags.skip=DOCID
	#set to true if the tags can be of various case
	TrecDocTags.casesensitive=false
	max.term.length=40
	ignore.low.idf.terms=false\n" >> "$file"

	if [ "$lang" = "en" ]; then
		printf "tokeniser=EnglishTokeniser
		TrecQueryTags.doctag=TOP
		TrecQueryTags.idtag=NUM\n" >> "$file"
	elif [ "$lang" = "enCLEF" ]; then
		printf "tokeniser=EnglishTokeniser
		TrecQueryTags.doctag=topic
		TrecQueryTags.idtag=identifier\n" >> "$file"
	else
		printf "tokeniser=UTFTokeniser
		trec.encoding=UTF-8
		#query tags specification
		TrecQueryTags.doctag=topic
		TrecQueryTags.idtag=identifier\n" >> "$file"
	fi

	if [ "$lang" = "fr" ]; then
		printf "indexer.meta.forward.keylens=64\n" >> "$file"

	fi

	if [ "$gramCond" = true ]; then
		if [ "$gram" = "${ngrams[0]}" ]; then
			printf "tokeniser.ngram=4\n" >> "$file"
		elif [ "$gram" = "${ngrams[1]}" ]; then
			printf "tokeniser.ngram=5\n" >> "$file"
		fi
	fi

      printf "stopwords.filename=%s\n" "$stoplist" >> "$file"

      if [ "$slCond" = true -a "$gramCond" = false -a "$stCond" = true ]; then
			 printf "termpipelines=%s,%s\n" "Stopwords" "$st" >> "$file"
	  elif [ "$slCond" = true -a "$gramCond" = false -a "$stCond" = false ]; then
			printf "termpipelines=%s\n" "Stopwords">> "$file"
	  elif [ "$slCond" = true -a "$gramCond" = true -a "$stCond" = false ]; then
			printf "termpipelines=%s,%s\n" "Stopwords">> "$file"
			printf "querying.ngrams=true\n">> "$file"
	  elif [ "$slCond" = false -a "$gramCond" = true -a "$stCond" = false ]; then
			printf "termpipelines=\n">> "$file"
			printf "querying.ngrams=true\n">> "$file"			
      elif [ "$slCond" = false -a "$gramCond" = false -a "$stCond" = true ]; then
			printf "termpipelines=%s\n" "$st">> "$file"
	  else		
	  		printf "termpipelines=\n">> "$file"
	  fi
     
     printf "terrier.index.path=%s\n" "$currIndexDir">> "$file"
     
     # copy the file in the property directory 
     cp $file $propertyDir$propertyName

 }






for sl in "${stopwords[@]}"
do
	for st in "${stemmers[@]}"
	do
		if [ "$sl" == "${stopwords[0]}" ]; then

			# available stoplists
			# indri stoplist
			sl_name="${stopwords[0]}".txt

			stoplist=$sl_path$sl_name;

			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[0]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[1]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=true;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[0]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[0]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[0]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[0]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[0]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[0]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[0]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[0]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties

					## create the index
					"$terrier"/bin/trec_terrier.sh -i
					
					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi
		elif [ "$sl" == "${stopwords[1]}" ]; then

			# available stoplists
			# lucene stoplist
			sl_name="${stopwords[1]}".txt

			stoplist=$sl_path$sl_name;

			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[1]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[1]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[1]}" "${stemmerNames[0]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[1]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[1]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[1]}" "${stemmerNames[1]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=true;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[1]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[1]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[1]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[1]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[1]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[1]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[1]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[1]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[1]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties

					## create the index
					"$terrier"/bin/trec_terrier.sh -i
					
					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi
		elif [ "$sl" == "${stopwords[2]}" ]; then

			# available stoplists
			# mild stoplist
			sl_name="${stopwords[2]}".txt

			stoplist=$sl_path$sl_name;

			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[2]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[2]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[2]}" "${stemmerNames[0]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[2]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[2]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[2]}" "${stemmerNames[1]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=true;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[2]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[2]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[2]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[2]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[2]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[2]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[2]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[2]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[2]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties

					## create the index
					"$terrier"/bin/trec_terrier.sh -i
					
					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi		
		elif [ "$sl" == "${stopwords[3]}" ]; then

			# available stoplists
			# proteus stoplist
			sl_name="${stopwords[3]}".txt

			stoplist=$sl_path$sl_name;

			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[3]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[3]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[3]}" "${stemmerNames[0]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[3]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[3]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[3]}" "${stemmerNames[1]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=true;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[3]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[3]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[3]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[3]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[3]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[3]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[3]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[3]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[3]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties

					## create the index
					"$terrier"/bin/trec_terrier.sh -i
					
					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi
		elif [ "$sl" == "${stopwords[4]}" ]; then

			# available stoplists
			# smart stoplist
			sl_name="${stopwords[4]}".txt

			stoplist=$sl_path$sl_name;

			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[4]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[4]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[4]}" "${stemmerNames[0]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[4]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[4]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[4]}" "${stemmerNames[1]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=true;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[4]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[4]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[4]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[4]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[4]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[4]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[4]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[4]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[4]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties

					## create the index
					"$terrier"/bin/trec_terrier.sh -i
					
					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi
		elif [ "$sl" == "${stopwords[5]}" ]; then

			# available stoplists
			# terrier stoplist
			sl_name="${stopwords[5]}".txt

			stoplist=$sl_path$sl_name;

			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[5]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[5]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[5]}" "${stemmerNames[0]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[5]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[5]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[5]}" "${stemmerNames[1]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=true;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[5]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[5]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[5]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[5]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[5]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[5]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[5]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[5]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[5]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties

					## create the index
					"$terrier"/bin/trec_terrier.sh -i
					
					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=true;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi				
		elif [ "$sl" == "${stopwords[6]}" ]; then
			if [ "$st" == "${stemmers[0]}" ]; then
				# weak stemmer
				currIndexDir=$indexDir"${stopwords[6]}"_"${stemmerNames[0]}";
 				
 				#the name of the property file for creating this index
				propertyName="${stopwords[6]}"_"${stemmerNames[0]}".properties;

				mkdir $currIndexDir
				
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[6]}" "${stemmerNames[0]}";

				slCond=false;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties

				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties
			
			elif [ "$st" == "${stemmers[1]}" ]; then
				# aggressive stemmer
				currIndexDir=$indexDir"${stopwords[6]}"_"${stemmerNames[1]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[6]}"_"${stemmerNames[1]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[6]}" "${stemmerNames[1]}";

				slCond=false;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

				# write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties

			elif [ "$st" == "${stemmers[2]}" ]; then
				# no stemmer
				slCond=false;
				stCond=false;

				for gram in "${ngrams[@]}"
				do
					if [ "$gram" == "${ngrams[0]}" ]; then
						gramCond=true;
				
						currIndexDir=$indexDir"${stopwords[6]}"_"${ngrams[0]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[6]}"_"${ngrams[0]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[6]}" "${ngrams[0]}";
					elif [ "$gram" == "${ngrams[1]}" ]; then
						gramCond=true;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[1]}"_"${ngrams[1]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[6]}"_"${ngrams[1]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s-grams" "${stopwords[6]}" "${ngrams[1]}";						
					elif [ "$gram" == "${ngrams[2]}" ]; then
						gramCond=false;
						# no stemmer
						currIndexDir=$indexDir"${stopwords[6]}"_"${stemmerNames[2]}";

						#the name of the property file for creating this index
						propertyName="${stopwords[6]}"_"${stemmerNames[2]}".properties;

						mkdir $currIndexDir
						printf "Indexing TIPSTER with Stoplist: %s no Stemmer and %s" "${stopwords[6]}" "${ngrams[2]}";						
					fi

					# execute the function which creates the properties file
					create_terrier_properties
					
					## create the index
					"$terrier"/bin/trec_terrier.sh -i

					# write the property for the querying part, it differs from the previous just for the ngrams part
					create_terrier_query_properties
				done
			elif [ "$st" == "${stemmers[3]}" ]; then
				# krovetz stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[3]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[3]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[3]}";

				slCond=false;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties	
			elif [ "$st" == "${stemmers[4]}" ]; then
				# lovins stemmer
				currIndexDir=$indexDir"${stopwords[0]}"_"${stemmerNames[4]}";

				#the name of the property file for creating this index
				propertyName="${stopwords[0]}"_"${stemmerNames[4]}".properties;

				mkdir $currIndexDir
				printf "Indexing TIPSTER with Stoplist: %s and Stemmer: %s" "${stopwords[0]}" "${stemmerNames[4]}";

				slCond=false;
				stCond=true;
				gramCond=false;

				# execute the function which creates the properties file
				create_terrier_properties
				
				## create the index
				"$terrier"/bin/trec_terrier.sh -i

			    # write the property for the querying part, it differs from the previous just for the ngrams part
				create_terrier_query_properties		
				
			fi

		fi

	done
done

# DELETE the CORPUS
rm -R "$path"/corpus;



