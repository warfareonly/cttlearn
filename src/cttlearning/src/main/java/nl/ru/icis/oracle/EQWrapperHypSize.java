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
	private MealyEquivalenceOracle<I, O> eq_oracle;
	private int iteration_num = 1; 
	
	public EQWrapperHypSize(MealyEquivalenceOracle<I, O> oracle) {
		this.eq_oracle = oracle;
	}
	
	public EQWrapperHypSize(EquivalenceOracle<MealyMachine<?, I, ?, O>, I, Word<O>> oracle) {
		this.eq_oracle = (MealyEquivalenceOracle<I,O>) oracle;
	}

	@Override
	public @Nullable DefaultQuery<I, Word<O>> findCounterExample(MealyMachine<?, I, ?, O> hypothesis, Collection<? extends I> inputs) {
		String log_formatted = null;
		
		log_formatted = String.format("EQWrapperHypSize: {Iteration=%d;HypothesisSize=%d;}", iteration_num,hypothesis.size());
		LOGGER.logEvent(log_formatted);
		iteration_num++;
		
		String eq_str = "";
		DefaultQuery<I, Word<O>> eq_return = this.eq_oracle.findCounterExample(hypothesis, inputs);
		if (eq_return != null) eq_str = eq_return.getInput().toString();
		log_formatted = String.format("EQWrapperHypSize: {CE=%s;}", eq_str);
		LOGGER.logEvent(log_formatted);
		return eq_return;
	}

}
