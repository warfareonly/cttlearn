package nl.ru.icis.oracle;

import java.util.Collection;

import org.checkerframework.checker.nullness.qual.Nullable;

import de.learnlib.api.logging.LearnLogger;
import de.learnlib.api.oracle.EquivalenceOracle;
import de.learnlib.api.oracle.EquivalenceOracle.MealyEquivalenceOracle;
import de.learnlib.api.query.DefaultQuery;
import net.automatalib.automata.transducers.MealyMachine;
import net.automatalib.words.Word;

public class EQWrapperHypSize<I, O> implements MealyEquivalenceOracle<I, O> {
	
	private final LearnLogger LOGGER = LearnLogger.getLogger(EQWrapperHypSize.class);
	private MealyEquivalenceOracle<I, O> eqOracle;
	private int iterationNum = 0; 
	
	public EQWrapperHypSize(MealyEquivalenceOracle<I, O> oracle) {
		this.eqOracle = oracle;
	}
	
	public EQWrapperHypSize(EquivalenceOracle<MealyMachine<?, I, ?, O>, I, Word<O>> oracle) {
		this.eqOracle = (MealyEquivalenceOracle<I,O>) oracle;
	}

	@Override
	public @Nullable DefaultQuery<I, Word<O>> findCounterExample(MealyMachine<?, I, ?, O> hypothesis, Collection<? extends I> inputs) {
		int qry_size = 0;

		DefaultQuery<I, Word<O>> qryToReturn = this.eqOracle.findCounterExample(hypothesis, inputs);
		if(qryToReturn != null) {
			qry_size = qryToReturn.getInput().size();
		}
		iterationNum++;
		LOGGER.logEvent(String.format("EQStats:{'Iter':%d,'HypSize':%d,'CESize':%d}", iterationNum, hypothesis.size(), qry_size));
		return qryToReturn;
	}

}
