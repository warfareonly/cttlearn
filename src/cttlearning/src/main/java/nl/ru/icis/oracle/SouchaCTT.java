/* Copyright (C) 2018 Carlos Diego N Damasceno
 */

package nl.ru.icis.oracle;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import de.learnlib.api.logging.LearnLogger;
import de.learnlib.api.oracle.EquivalenceOracle.MealyEquivalenceOracle;
import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
import de.learnlib.api.query.DefaultQuery;
import de.learnlib.oracle.equivalence.MealyCompleteExplorationEQOracle;
import net.automatalib.automata.transducers.MealyMachine;
import net.automatalib.words.Word;

/**
 * This EQ oracle sets two bounds for counterexample search. (1) the maximum
 * length for a CE is set as five times the number of states in a SUL if this
 * limit is reached without finding a CE, then the machine is reset, and
 * reinitialize the search with a new sequence. (2) the learning process
 * terminates as soon as the number of states in a hypothesis becomes equivalent
 * to the SUL.
 * 
 * @param <I>
 *                input symbol type
 * @param <O>
 *                output symbol type
 *
 * @author damascenodiego
 */

public class SouchaCTT<I, O> implements MealyEquivalenceOracle<I, O> {

	private final LearnLogger LOGGER = LearnLogger.getLogger(SouchaCTT.class);

	/**
	 * Conformance testing method name
	 */
	private String conformanceTesting;

	/**
	 * System under learning.
	 */
	private final MealyMembershipOracle<I, O> sul;

	/**
	 * Number of extra states.
	 */
	private final int extraStates;

	/**
	 * EQ Oracle for testing single-state FSM model
	 */
	private MealyCompleteExplorationEQOracle<I,O> completeExploration;

	public static final String CTT_Wp = "wp";
	public static final String CTT_W = "w";
	public static final String CTT_H = "h";
	public static final String CTT_HSI = "hsi";
	public static final String CTT_SPY = "spy";
	public static final String CTT_SPYh = "spyh";
	public static final String REGEX_TC = "^tc_(?<id>[0-9]+):\\W+(?<tc>[0-9]+(,[0-9]+)*)";
	public static final String REGEX_EXECTIME = "^time_elapsed:\\W+(?<exectime>[0-9]+.[0-9]+)s";
	public static final Pattern PATTERN_TC = Pattern.compile(REGEX_TC);
	public static final Pattern PATTERN_EXECTIME = Pattern.compile(REGEX_EXECTIME);

	public SouchaCTT(MealyMembershipOracle<I, O> sul, String ctt_name, int extra_states) {
		this.sul = sul;
		this.conformanceTesting = ctt_name;
		this.extraStates = extra_states;
		this.completeExploration = new MealyCompleteExplorationEQOracle<I,O>(sul, 1+extra_states); // |I| + extra states 
		LOGGER.logEvent("EquivalenceOracle: SouchaCTT: {Technique=" + this.conformanceTesting + ";ExtraStates=" + this.extraStates + ";}");
	}

	public SouchaCTT(MealyMembershipOracle<I, O> sul) {
		this(sul, "w", 0);
	}

	/**
	 * Max. number of symbols (default: set as 100x|Q|).
	 */

	@Override
	public DefaultQuery<I, Word<O>> findCounterExample(MealyMachine<?, I, ?, O> hypothesis, Collection<? extends I> inputs) {
		return doFindCounterExample(hypothesis, inputs);
	}

	private <S, T> DefaultQuery<I, Word<O>> doFindCounterExample(MealyMachine<S, I, T, O> hypothesis, Collection<? extends I> inputs) {

		if (inputs.isEmpty()) {
			LOGGER.warn("Passed empty set of inputs to equivalence oracle; no counterexample can be found!");
			return null;
		}
		
		if(hypothesis.size()==1) {
			return this.completeExploration.findCounterExample(hypothesis, inputs);
		}
		
		String soucha_fsm = print_mealy_in_soucha_format(hypothesis, inputs);
		
		try {
			Process process = Runtime.getRuntime().exec("../src/fsm_lib -m " + this.conformanceTesting + " -es " + this.extraStates);
			BufferedReader proc_in = new BufferedReader(new InputStreamReader(process.getInputStream()));
			OutputStreamWriter proc_out = new OutputStreamWriter(process.getOutputStream());

			proc_out.write(soucha_fsm);
			proc_out.flush();
			proc_out.close();

			String tc_line = null;

			while ((tc_line = proc_in.readLine()) != null) {
				if (tc_line.isBlank() || tc_line.isEmpty()) {
					continue;
				}
				Word<I> test_case = stringToWord(tc_line, inputs);
				Word<O> outSul = sul.answerQuery(test_case);
				Word<O> outHyp = hypothesis.computeOutput(test_case);
				
				if (!outSul.equals(outHyp)) {
					DefaultQuery<I, Word<O>> ce = new DefaultQuery<>(test_case);
					ce.answer(outSul);
					proc_in.close();
					return ce;
				}
			}
			proc_in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	public String getTestingTechnique() {
		return conformanceTesting;
	}

	public <S, I, T, O> String print_mealy_in_soucha_format(MealyMachine<S, I, T, O> hypothesis, Collection<? extends I> inputs) {

		Map<O, Integer> dict_outputs = new HashMap<>();

		hypothesis.getStates().forEach(st -> inputs.forEach(in -> dict_outputs.putIfAbsent(hypothesis.getOutput(st, in), dict_outputs.size())));
		Map<S, Integer> identified_states = new HashMap<>();
		identified_states.put(hypothesis.getInitialState(), identified_states.size());
		hypothesis.getStates().forEach(st -> identified_states.putIfAbsent(st, identified_states.size()));

		StringBuilder sbuilder = new StringBuilder(50);

		// File's content:
		// t r
		// t=1 DFSM
		//  =2 Mealy machine
		//  =3 Moore machine
		//  =4 DFA
		// r=0 unreduced
		//  =1 reduced
		int t = 2; // the mealy machine  
		int r = 1; // is always minimized
		sbuilder.append(String.format("%d", t));
		sbuilder.append(" ");
		sbuilder.append(String.format("%d", r));
		sbuilder.append("\n");
		// n p q
		// n ... the number of states
		// p ... the number of inputs
		// q ... the number of outputs
		int n = hypothesis.getStates().size();
		int p = inputs.size();
		int q = dict_outputs.size();
		sbuilder.append(String.format("%d", n));
		sbuilder.append(" ");
		sbuilder.append(String.format("%d", p));
		sbuilder.append(" ");
		sbuilder.append(String.format("%d", q));
		sbuilder.append("\n");
		// m
		// m ... maximal state ID
		int m = hypothesis.getStates().size();
		sbuilder.append(String.format("%d", m));
		sbuilder.append("\n");
		// output and state-transition functions listing according to the machine type
		// - all values are separated by a space
		// 
		// Output functions: (depends on the machine type)
		//  n lines: state <output on the transition for each input>(p values)
		for (S origin_state : identified_states.keySet()) {
			int origin_id = identified_states.get(origin_state);
			sbuilder.append(origin_id);
			for (I symbol_I : inputs) {
				int output_id = dict_outputs.get(hypothesis.getOutput(origin_state, symbol_I));
				sbuilder.append(" "); // - all values are separated by a space
				sbuilder.append(output_id);
			}
			sbuilder.append("\n");
		}
		// state-transition function:
		//  n lines: state <the next state for each input>(p values)
		for (S origin_state : identified_states.keySet()) {
			int origin_id = identified_states.get(origin_state);
			sbuilder.append(origin_id);
			for (I symbol_I : inputs) {
				S dest_state = hypothesis.getSuccessor(origin_state, symbol_I);
				int dest_id = identified_states.get(dest_state);
				sbuilder.append(" ");
				sbuilder.append(dest_id);
			}
			sbuilder.append("\n");
		}

		return sbuilder.toString();

	}

	private Word<I> stringToWord(String in_str, Collection<? extends I> inputs) {
		List<? extends I> inputs_list = new ArrayList<>(inputs);
		Word<I> in_word = Word.epsilon();
		Matcher in_matcher = PATTERN_TC.matcher(in_str);
		if (in_matcher.matches()) {
			String result = in_matcher.group("tc");
			for (String in_piece : result.split(",")) {
				Integer in_int = Integer.decode(in_piece);
				I in_I = inputs_list.get(in_int);
				in_word = in_word.append(in_I);
			}
		}

		return in_word;
	}

}
