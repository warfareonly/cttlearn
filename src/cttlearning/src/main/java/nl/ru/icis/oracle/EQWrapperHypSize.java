package nl.ru.icis.oracle;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import org.checkerframework.checker.nullness.qual.Nullable;

import de.learnlib.api.logging.LearnLogger;
import de.learnlib.api.oracle.EquivalenceOracle;
import de.learnlib.api.oracle.EquivalenceOracle.MealyEquivalenceOracle;
import de.learnlib.api.query.DefaultQuery;
import de.learnlib.api.statistic.StatisticSUL;
import de.learnlib.filter.statistic.Counter;
import net.automatalib.automata.transducers.MealyMachine;
import net.automatalib.words.Word;

public class EQWrapperHypSize<I, O> implements MealyEquivalenceOracle<I, O> {
	
	private final LearnLogger LOGGER = LearnLogger.getLogger(EQWrapperHypSize.class);
	private MealyEquivalenceOracle<I, O> eqOracle;
	private int iterationNum = 0; 
	private Map<String,StatisticSUL> statisticSuls = new HashMap<>();
	
	public EQWrapperHypSize(MealyEquivalenceOracle<I, O> oracle) {
		this.eqOracle = oracle;
	}
	
	public EQWrapperHypSize(EquivalenceOracle<MealyMachine<?, I, ?, O>, I, Word<O>> oracle) {
		this.eqOracle = (MealyEquivalenceOracle<I,O>) oracle;
	}
	
	public void addStatisticsSUL(String name, StatisticSUL stats) {
		this.statisticSuls.put(name, stats);
	}

	@Override
	public @Nullable DefaultQuery<I, Word<O>> findCounterExample(MealyMachine<?, I, ?, O> hypothesis, Collection<? extends I> inputs) {
		int qry_size = 0;

		DefaultQuery<I, Word<O>> qryToReturn = this.eqOracle.findCounterExample(hypothesis, inputs);
		if(qryToReturn != null) {
			qry_size = qryToReturn.getInput().size();
		}
		iterationNum++;
		
		StringBuffer sb = new StringBuffer();
		sb.append("EQStats:{");
		sb.append("'Iter':%d".formatted(iterationNum));
		sb.append(",'HypSize':%d".formatted(hypothesis.size()));
		sb.append(",'CESize':%d".formatted(qry_size));
		for (String k : this.statisticSuls.keySet()) {
			Counter counter = (Counter) this.statisticSuls.get(k).getStatisticalData();
			sb.append(",'%s':%d".formatted(k,counter.getCount()));
		}
		sb.append("}");
		LOGGER.logEvent(sb.toString());		
		return qryToReturn;
	}

}
