
printf "Indexing TREC7\n";

START_TIME=$SECONDS

sh terrier_index.sh -l en -c en_tipster_9899

printf "required time: " 
echo ELAPSED_TIME;


printf "Indexing TREC6\n";

START_TIME=$SECONDS

sh terrier_index.sh -l en -c en_tipster_97

printf "required time: " 
echo ELAPSED_TIME;

printf "Indexing TREC5\n";

START_TIME=$SECONDS

sh terrier_index.sh -l en -c en_tipster_96

printf "required time: " 
echo ELAPSED_TIME;
