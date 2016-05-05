# TREC Adhoc 5, 6, 7, 8 Grid of Points (SIGIR 2016)

We selected a set of alternative implementations of each component and by using the [Terrier open source system](http://terrier.org/) we created a run for each system defined by combining the available components in all possible ways.

We considered three main components of an IR system: stop list, Lexical Unit Generator (LUG) and IR model. We selected a set of alternative implementations of each component and by using the Terrier open source system we created a run for each system defined by combining the available components in all possible ways. The components we selected are:

- **stop list**: nostop, indri, lucene, smart, terrier
- **LUG**: nolug, weak Porter, Porter, Krovetz, Lovins, 4grams, 5grams;
- **model**: BB2, BM25, DFRBM25, DFRee, DLH, DLH13, DPH, HiemstraLM, IFB2, InL2, InexpB2, InexpC2, LGD, LemurTFIDF, PL2, TFIDF.

## Content

Content of the directories:
- **matlab**: the Matlab code for running the analyses and reproducing the experiments from the Grid of Points contained in the `data` directory. It requires the [MATTERS library](http://matters.dei.unipd.it/).
- **data**: the Grid of Points for the following Adhoc collections: TREC 5 (`AH_MONO_EN_TREC1996` directory), TREC 6 (`AH_MONO_EN_TREC1997` directory), TREC 7 (`AH_MONO_EN_TREC1998` directory), TREC 8 (`AH_MONO_EN_TREC1999` directory). Each directory contains a `.mat` file for each of the following evaluation measures: AP, P@10, nDCG@20, ERR@20, and RBP. Files have to be opened with the `serload` command of the [MATTERS library](http://matters.dei.unipd.it/).
- **java**: it contains the extensions to Terrier 4.1 needed for using n-grams, the Lovins stemmer, and the Krovetz stemmer
- **script**: it contains the shell scripts to index the TREC collections, create the Terrier configuration files, and produce the run files that constitute the various Grid of Points.

## Reference

Ferro, N. and Silvello, G. (2016). A General Linear Mixed Models Approach to Study System Component Effects. In Perego, R., Sebastiani, F., Aslam, J., Ruthven, I., and Zobel, J., editors, *Proc. 39th Annual International ACM SIGIR Conference on Research and Development in Information Retrieval (SIGIR 2016)*. ACM Press, New York, USA.

