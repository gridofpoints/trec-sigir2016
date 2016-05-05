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

/**
 * Abstract base class for nGrams tokenizers that are also TermPipeline
 * instances
 * 
 * @author <a href="mailto:silvello@dei.unipd.it">Gianmaria Silvello</a>
 * @version 0.1
 * @since 0.1
 * 
 */
public abstract class NGramsTermPipeline implements NGramsTokenizer, TermPipeline {

	protected TermPipeline next;
	
	protected NGramsTermPipeline() {
		this(null);
	}

	/**
	 * Make a new nGramsTermPipeline object, with _next being the next object in
	 * this pipeline.
	 * 
	 * @param _next
	 *            Next pipeline object
	 */
	NGramsTermPipeline(TermPipeline _next) {
		this.next = _next;
	}

	/**
	 * Returns the ngrams of the given term and passes onto the next object in
	 * the term pipeline.
	 * 
	 * @param t
	 *            String the term to tokenize into ngrams.
	 */
	public void processTerm(String t) {
		if (t == null) {
			return;
		}

		for (String term : tokenize(t)){
			next.processTerm(term);
		}
		
	}

	/**
	 * Implements the default operation for all TermPipeline subclasses; By
	 * default do nothing. This method should be overrided by any TermPipeline
	 * that want to implements doc/query oriented lifecycle.
	 * 
	 * @return return how the reset has gone
	 */
	public boolean reset() {
		return next != null ? next.reset() : true;
	}
}
