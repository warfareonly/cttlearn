/**
 * 
 */
package nl.ru.icis;

import java.io.File;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;

import de.learnlib.acex.analyzers.AcexAnalyzers;
import de.learnlib.algorithms.lstar.ce.ObservationTableCEXHandler;
import de.learnlib.algorithms.lstar.ce.ObservationTableCEXHandlers;
import de.learnlib.algorithms.lstar.closing.ClosingStrategies;
import de.learnlib.algorithms.lstar.closing.ClosingStrategy;
import de.learnlib.algorithms.lstar.mealy.ExtensibleLStarMealy;
import de.learnlib.algorithms.ttt.mealy.TTTLearnerMealy;
import de.learnlib.api.SUL;
import de.learnlib.api.logging.LearnLogger;
import de.learnlib.api.oracle.EquivalenceOracle;
import de.learnlib.api.oracle.MembershipOracle;
import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
import de.learnlib.api.statistic.StatisticSUL;
import de.learnlib.driver.util.MealySimulatorSUL;
import de.learnlib.filter.cache.sul.SULCache;
import de.learnlib.filter.statistic.sul.ResetCounterSUL;
import de.learnlib.filter.statistic.sul.SymbolCounterSUL;
import de.learnlib.oracle.equivalence.MealyWMethodEQOracle;
import de.learnlib.oracle.equivalence.MealyWpMethodEQOracle;
import de.learnlib.oracle.equivalence.WMethodEQOracle;
import de.learnlib.oracle.equivalence.WpMethodEQOracle;
import de.learnlib.oracle.membership.SULOracle;
import de.learnlib.util.Experiment.MealyExperiment;
import de.learnlib.util.statistics.SimpleProfiler;
import net.automatalib.automata.transducers.MealyMachine;
import net.automatalib.automata.transducers.impl.compact.CompactMealy;
import net.automatalib.serialization.InputModelDeserializer;
import net.automatalib.serialization.dot.DOTParsers;
import net.automatalib.util.automata.Automata;
import net.automatalib.words.Word;
import nl.ru.icis.oracle.EQWrapperHypSize;
import nl.ru.icis.oracle.SouchaCTT;

/**
 * @author damasceno
 *
 */
public class Benchmarking {

	public static final String CONFIG = "config";
	public static final String SOT = "sot";
	public static final String SUL = "sul";
	public static final String HELP = "help";
	public static final String HELP_SHORT = "h";
	public static final String OT = "ot";
	public static final String CEXH = "cexh";
	public static final String CLOS = "clos";
	public static final String EQ = "eq";
	public static final String CACHE = "cache";
	public static final String EXTRA_STATES = "es";
	public static final String SEED = "seed";
	public static final String OUT = "out";
	public static final String LEARN = "learn";
	public static final String INFO = "info";
	
	public static final SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	
	public static final String[] eqMethodsAvailable = {"w" , "wp", "soucha_hsi", "soucha_h", "soucha_spy", "soucha_spyh"};
	public static final String[] closingStrategiesAvailable = {"CloseFirst" , "CloseShortest"};
	private static final String RIVEST_SCHAPIRE_ALLSUFFIXES = "RivestSchapireAllSuffixes";
	public static final String[] cexHandlersAvailable = {"ClassicLStar" , "MalerPnueli", "RivestSchapire", RIVEST_SCHAPIRE_ALLSUFFIXES, "Shahbaz", "Suffix1by1"};
	public static final String[] learningMethodsAvailable = {"lstar", "ttt"};


	public static void main(String[] args) throws Exception {

		// create the command line parser
		CommandLineParser parser = new DefaultParser();
		// create the Options
		Options options = createOptions();
		// automatically generate the help statement
		HelpFormatter formatter = new HelpFormatter();

		
		long tstamp = System.currentTimeMillis();
		// random seed
		Random rnd_seed = new Random(tstamp);

		// timestamp
		Timestamp timestamp = new Timestamp(tstamp);

		try {
			
			// parse the command line arguments
			CommandLine line = parser.parse( options, args);

			if(line.hasOption(HELP)){
				formatter.printHelp( "Infer_LearnLib", options );
				System.exit(0);
			}
			
			// set SUL path
			if(!line.hasOption(SUL)) throw new IllegalArgumentException("must provide a SUL");
			File sul = new File(line.getOptionValue(SUL));

			// create log
			LearnLogger logger = LearnLogger.getLogger(Benchmarking.class);

			// set closing strategy
			ClosingStrategy<Object, Object> strategy = getClosingStrategy(line.getOptionValue(CLOS));
			logger.logEvent("ClosingStrategy: "+strategy.toString());
			
			// set CE processing approach
			ObservationTableCEXHandler<Object, Object> handler 	= getCEXHandler(line.getOptionValue(CEXH));
			logger.logEvent("ObservationTableCEXHandler: "+handler.toString());
			
			// load mealy machine
			InputModelDeserializer<String, CompactMealy<String, String>> mealy_parser = DOTParsers.mealy();
			CompactMealy<String, String> mealyss = mealy_parser.readModel(sul).model;
			
			logger.logEvent("SUL name: "+sul.getName());
			logger.logEvent("SUL dir: "+sul.getAbsolutePath());
						
			// set seed from CLI parameter, if passed
			if(line.hasOption(SEED))  tstamp = Long.valueOf(line.getOptionValue(SEED));
			rnd_seed.setSeed(tstamp);
			logger.logEvent("Seed: "+Long.toString(tstamp));
			
			// SUL simulator
			SUL<String,String> sulSim = new MealySimulatorSUL(mealyss);
			
			//////////////////////////////////
			// Setup objects related to MQs	//
			//////////////////////////////////
			
			// use caching to avoid duplicate queries
			logger.logEvent("Cache: "+(line.hasOption(CACHE)?"Y":"N"));

			// Counters for MQs 
			StatisticSUL<String, String>  mq_sym = new SymbolCounterSUL<>("MQ", sulSim);
			StatisticSUL<String, String>  mq_rst = new ResetCounterSUL <>("MQ", mq_sym);
			SUL<String, String> mq_sul = mq_rst; // SUL for counting queries wraps sul
			if(line.hasOption(CACHE))  mq_sul = SULCache.createDAGCache(mealyss.getInputAlphabet(), mq_rst);
			
			int extra_states = 0;
			if(line.hasOption(EXTRA_STATES)) extra_states = Integer.valueOf(line.getOptionValue(EXTRA_STATES).toString());
			
			// Counters for EQs 
			StatisticSUL<String, String>  eq_sym = new SymbolCounterSUL<>("EQ", sulSim);
			StatisticSUL<String, String>  eq_rst = new ResetCounterSUL <>("EQ", eq_sym);
			SUL<String, String> eq_sul = eq_rst; // SUL for counting queries wraps sul
			if(line.hasOption(CACHE))  eq_sul = SULCache.createDAGCache(mealyss.getInputAlphabet(), eq_rst);
			
			
			String ctt_name = "w";
			if(line.hasOption(EQ)) ctt_name = line.getOptionValue(EQ).toLowerCase();
			
			MembershipOracle<String, String>       mqOracle = new SULOracle(mq_sul);
			EquivalenceOracle<MealyMachine<?, String, ?, String>, String, Word<String>> eqOracle = buildEqOracle(rnd_seed, ctt_name, extra_states, logger, eq_sul);
			
			// Wrapper to log the hypothesis size for every EQOracle call
			eqOracle = new EQWrapperHypSize(eqOracle);

			/////////////////////////////
			// Setup experiment object //
			/////////////////////////////

			String learnAlgorithm = "lstar";
			MealyExperiment experiment = null;
			
			if(line.hasOption(LEARN)) learnAlgorithm = line.getOptionValue(LEARN).toLowerCase();
			switch (learnAlgorithm) {
			case "lstar":
				logger.logConfig("Method: L*M");
				experiment = learningLStarM(mealyss, mqOracle, eqOracle, handler, strategy);
				break;
			case "ttt":
				logger.logConfig("Method: TTT");
				experiment = learningTTT(mealyss, mqOracle, eqOracle, handler, strategy);
				break;
			default:
				throw new Exception("Invalid learning method selected: "+learnAlgorithm);
			}
			
			// turn on time profiling
			experiment.setProfile(true);
			
			// run experiment
			experiment.run();

			// learning statistics
			logger.logConfig("Rounds: "+experiment.getRounds().getCount());
			logger.logStatistic(mq_rst.getStatisticalData());
			logger.logStatistic(mq_sym.getStatisticalData());
			logger.logStatistic(eq_rst.getStatisticalData());
			logger.logStatistic(eq_sym.getStatisticalData());

			// profiling
			SimpleProfiler.logResults();

			MealyMachine finalHyp = (MealyMachine) experiment.getFinalHypothesis();
			
			logger.logConfig("Qsize: "+mealyss.getStates().size());
			logger.logConfig("Isize: "+mealyss.getInputAlphabet().size());

			boolean isEquiv = Automata.testEquivalence(mealyss,finalHyp, mealyss.getInputAlphabet());
//			boolean isEquiv = mealyss.getStates().size()==finalHyp.getStates().size();
			if(isEquiv){
				logger.logConfig("Equivalent: OK");
			}else{
				logger.logConfig("Equivalent: NOK");
			}
			
			if(line.hasOption(INFO))  {
				logger.logConfig("Info: "+line.getOptionValue(INFO));
			}else{
				logger.logConfig("Info: N/A");
			}

		}
		catch( Exception exp ) {
			// automatically generate the help statement
			formatter.printHelp( "Infer_LearnLib", options );
			System.err.println( "Unexpected Exception");
			exp.printStackTrace();
		}

	}


	private static EquivalenceOracle<MealyMachine<?, String, ?, String>, String, Word<String>> buildEqOracle(
			Random rnd_seed, String ctt_name, int extra_states, LearnLogger logger, 
			SUL<String, String> eq_sul) {
		MealyMembershipOracle<String,String> oracleForEQoracle = new SULOracle(eq_sul);
		
		
		EquivalenceOracle<MealyMachine<?, String, ?, String>, String, Word<String>> eqOracle;
		switch (ctt_name) {
		case "wp":
			eqOracle = new MealyWpMethodEQOracle<>(oracleForEQoracle, extra_states);
			logger.logEvent("EquivalenceOracle: WpMethodEQOracle("+extra_states+")");
			break;
		case "soucha_h":
			eqOracle = new SouchaCTT(oracleForEQoracle,"h",extra_states);
			logger.logEvent("EquivalenceOracle: SouchaCTT(h,"+extra_states+")");
			break;
		case "soucha_hsi":
			eqOracle = new SouchaCTT(oracleForEQoracle,"hsi",extra_states);
			logger.logEvent("EquivalenceOracle: SouchaCTT(hsi,"+extra_states+")");
			break;
		case "soucha_spy":
			eqOracle = new SouchaCTT(oracleForEQoracle,"spy",extra_states);
			logger.logEvent("EquivalenceOracle: SouchaCTT(spy,"+extra_states+")");
			break;
		case "soucha_spyh":
			eqOracle = new SouchaCTT(oracleForEQoracle,"spyh",extra_states);
			logger.logEvent("EquivalenceOracle: SouchaCTT(spyh,"+extra_states+")");
			break;
		case "w":
			eqOracle = new MealyWMethodEQOracle<>(oracleForEQoracle, extra_states);
			logger.logEvent("EquivalenceOracle: WMethodEQOracle("+extra_states+")");
			break;
		default:
			eqOracle = new MealyWMethodEQOracle<>(oracleForEQoracle, extra_states);
			logger.logEvent("EquivalenceOracle: WMethodEQOracle("+extra_states+")");
			break;
		}
		return eqOracle;
	}


	private static MealyExperiment<String, String> learningLStarM(
			CompactMealy<String, String> mealyss, 
			MembershipOracle<String, String> mqOracle, 
			EquivalenceOracle<MealyMachine<?, String, ?, String>, String, Word<String>> eqOracle,
			ObservationTableCEXHandler<Object,Object> handler, 
			ClosingStrategy<Object,Object> strategy) {
		List<Word<String>> initPrefixes = new ArrayList<>();
		initPrefixes.add(Word.epsilon());
		List<Word<String>> initSuffixes = new ArrayList<>();
		Word<String> word = Word.epsilon();
		for (String symbol : mealyss.getInputAlphabet()) { 
			initSuffixes.add(word.append(symbol));
		}
		
		// construct standard L*M instance
		ExtensibleLStarMealy<String, String> learner = new ExtensibleLStarMealy(
				mealyss.getInputAlphabet(), 
				mqOracle, 
				initPrefixes,
				initSuffixes,
				handler, 
				strategy);
	
		// The experiment will execute the main loop of active learning
		MealyExperiment<String, String> experiment = new MealyExperiment(learner, eqOracle, mealyss.getInputAlphabet());
		return experiment;
	}


	private static MealyExperiment<String, String> learningTTT(CompactMealy<String, String> mealyss,
			MembershipOracle<String,String> mqOracle,
			EquivalenceOracle<MealyMachine<?, String, ?, String>, String, Word<String>> eqOracle,
			ObservationTableCEXHandler<Object, Object> handler, ClosingStrategy<Object, Object> strategy) {
		
		// construct TTT instance 
		TTTLearnerMealy<String,String> learner = new TTTLearnerMealy(mealyss.getInputAlphabet(),mqOracle,AcexAnalyzers.LINEAR_FWD);

		// The experiment will execute the main loop of active learning
		MealyExperiment<String, String> experiment = new MealyExperiment(learner, eqOracle, mealyss.getInputAlphabet());
		return experiment;
	}


	private static ClosingStrategy<Object,Object> getClosingStrategy(String optionValue) {
		if(optionValue != null){
			if (optionValue.equals(ClosingStrategies.CLOSE_FIRST.toString())) {
				return ClosingStrategies.CLOSE_FIRST;
			}else if (optionValue.equals(ClosingStrategies.CLOSE_SHORTEST.toString())) {
				return ClosingStrategies.CLOSE_SHORTEST;
			}
		}
		return ClosingStrategies.CLOSE_FIRST;
	}


	private static ObservationTableCEXHandler<Object,Object> getCEXHandler(String optionValue) {
		if(optionValue != null){
			if (optionValue.equals(ObservationTableCEXHandlers.RIVEST_SCHAPIRE.toString())) {
				return ObservationTableCEXHandlers.RIVEST_SCHAPIRE;

			}else if (optionValue.equals(RIVEST_SCHAPIRE_ALLSUFFIXES)) {
				return ObservationTableCEXHandlers.RIVEST_SCHAPIRE_ALLSUFFIXES;
			}else if (optionValue.equals(ObservationTableCEXHandlers.SUFFIX1BY1.toString())) {
				return ObservationTableCEXHandlers.SUFFIX1BY1;
			}else if (optionValue.equals(ObservationTableCEXHandlers.CLASSIC_LSTAR.toString())) {
				return ObservationTableCEXHandlers.CLASSIC_LSTAR;
			}else if (optionValue.equals(ObservationTableCEXHandlers.MALER_PNUELI.toString())) {
				return ObservationTableCEXHandlers.MALER_PNUELI;
			}else if (optionValue.equals(ObservationTableCEXHandlers.SHAHBAZ.toString())) {
				return ObservationTableCEXHandlers.SHAHBAZ;
			}
		}
		return ObservationTableCEXHandlers.RIVEST_SCHAPIRE;
	}


	private static Options createOptions() {
		// create the Options
		Options options = new Options();
		options.addOption( SOT,  false, "Save observation table (OT)" );
		options.addOption( HELP, false, "Shows help" );
		options.addOption( SUL,  true, "System Under Learning (SUL)" );
		//options.addOption( OUT,  true, "Set output directory" );
		options.addOption( CLOS, true, "Set closing strategy."                       + "\nOptions: {"+String.join(", ", closingStrategiesAvailable)+"}");
		options.addOption( EQ, 	 true, "Set equivalence query generator."            + "\nOptions: {"+String.join(", ", eqMethodsAvailable)+"}");
		options.addOption( CEXH, true, "Set counter example (CE) processing method." + "\nOptions: {"+String.join(", ", cexHandlersAvailable)+"}");
		options.addOption( LEARN,true, "Model learning algorithm."                   + "\nOptions: {"+String.join(", ", learningMethodsAvailable)+"}");
		options.addOption( CACHE,false,"Use caching.");
		options.addOption( EXTRA_STATES,  true, "Number of extra states (Default: 0)" );
		options.addOption( SEED, true, "Seed used by the random generator");
		options.addOption( INFO, true, "Add extra information as string");
		return options;
	}

}

