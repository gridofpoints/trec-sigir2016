/*
 * Copyright 2015 University of Padua, Italy
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.terrier.terms;

import org.terrier.terms.TermPipeline;
import org.terrier.utility.ApplicationSetup;

/**
 * Implements a basic tokenizer in nGrams
 * 
 * @author <a href="mailto:silvello@dei.unipd.it">Gianmaria Silvello</a>
 * @version 0.1
 * @since 0.1
 * 
 */
public class BasicNGramsTokenizer extends NGramsTermPipeline {

	/**
	 * The ngram value; default is 4
	 */
	private static final int NGRAM = Integer.parseInt(ApplicationSetup.getProperty("tokeniser.ngram", "4"));

	/**
	 * constructor
	 */
	public BasicNGramsTokenizer() {
		super();
	}

	/**
	 * constructor
	 * 
	 * @param next
	 */
	public BasicNGramsTokenizer(TermPipeline next) {
		super(next);
	}

	@Override
	public String[] tokenize(String s) {

		if (s.length() >= NGRAM) {
			int ngramTokens = (s.length() - NGRAM) + 1;
			char[] sc = s.toCharArray();
			String[] ngramsArr = new String[ngramTokens];

			int pos = 0;

			for (int i = 0; i < ngramTokens; i++) {
				char[] tmpS = new char[NGRAM];

				System.arraycopy(sc, pos, tmpS, 0, NGRAM);

				pos++;
				ngramsArr[i] = new String(tmpS);

			}

			return ngramsArr;

		} else {
			String[] ngramsArr = new String[1];

			ngramsArr[0] = s;
			return ngramsArr;

		}

	}
}
