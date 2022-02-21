package nl.ru.icis.oracle;

import de.learnlib.api.logging.LearnLogger;
import de.learnlib.api.oracle.EquivalenceOracle.MealyEquivalenceOracle;
import de.learnlib.api.oracle.MembershipOracle.MealyMembershipOracle;
import de.learnlib.api.query.DefaultQuery;
import net.automatalib.automata.transducers.MealyMachine;
import net.automatalib.serialization.dot.GraphDOT;
import net.automatalib.words.Word;
import net.automatalib.words.WordBuilder;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.io.*;
import java.util.Collection;
import java.util.Scanner;

/**
 * Implements the Lee & Yannakakis suffixes by invoking an external program. Because of this indirection to an external
 * program, the findCounterexample method might throw a RuntimeException. Sorry for the hard-coded path to the
 * executable!
 *
 * @param <I> is the input alphabet, usually String.
 * @param <O> is the output alphabet. (So a query will have type Word<String, Word<O>>.)
 */
public class YannakakisCTT<I, O> implements MealyEquivalenceOracle<I, O> {
    private final LearnLogger LOGGER = LearnLogger.getLogger(YannakakisCTT.class);
    private final MealyMembershipOracle<I, O> sulOracle;
    private  ProcessBuilder pb;
    private final Integer extraStates;
    private Process process;
    private Writer processInput;
    private BufferedReader processOutput;
    private StreamGobbler errorGobbler;


    /**
     * @param sulOracle The membership oracle of the SUL, we need this to check the output on the test suite
     * @throws IOException
     */
    public YannakakisCTT(Integer extraStates, MealyMembershipOracle<I, O> sulOracle) throws IOException {
        this.sulOracle = sulOracle;
        this.extraStates = extraStates;
        this.pb = new ProcessBuilder("../src/hybrid-ads/build/main", "-p", "lexmin", "-m", "fixed", "-l", extraStates.toString(), "-k", extraStates.toString());
    }

    /**
     * Uses an external program to find counterexamples. The hypothesis will be written to stdin. Then the external
     * program might do some calculations and write its test suite to stdout. This is in turn read here and fed
     * to the SUL. If a discrepancy occurs, a counterexample is returned. If the external program exits (with value
     * 0), then no counterexample is found, and the hypothesis is correct.
     * <p>
     * This method might throw a RuntimeException if the external program crashes (which it shouldn't of course), or if
     * the communication went wrong (for whatever IO reason).
     */
    @Override
    public @Nullable DefaultQuery<I, Word<O>> findCounterExample(MealyMachine<?, I, ?, O> hypothesis, Collection<? extends I> inputs) {
        if (inputs.isEmpty()) {
            LOGGER.warn("Passed empty set of inputs to equivalence oracle; no counterexample can be found!");
            return null;
        }
        return doFindCounterExample(hypothesis, inputs);
    }

    /**
     * Starts the process and creates buffered/whatnot streams for stdin stderr or the external program
     *
     * @throws IOException if the process could not be started (see ProcessBuilder.start for details).
     */
    private void setupProcess() throws IOException {
        process = pb.start();
        processInput = new OutputStreamWriter(process.getOutputStream());
        processOutput = new BufferedReader(new InputStreamReader(process.getInputStream()));
        errorGobbler = new StreamGobbler(process.getErrorStream(), "ERROR> main");
        errorGobbler.start();
    }

    /**
     * I thought this might be a good idea, but I'm not a native Java speaker, so maybe it's not needed.
     */
    private void closeAll() {
        // Since we're closing, I think it's ok to continue in case of an exception
        try {
            processInput.close();
            processOutput.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            errorGobbler.join(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        process.destroy();
        process = null;
        processInput = null;
        processOutput = null;
        errorGobbler = null;
    }

    private DefaultQuery<I, Word<O>> doFindCounterExample(MealyMachine<?, I, ?, O> hypothesis, Collection<? extends I> inputs) {
        try {
            setupProcess();
        } catch (IOException e) {
            throw new RuntimeException("Unable to start the external program: " + e);
        }

        try {
            // Write the hypothesis to stdin of the external program
            GraphDOT.write(hypothesis, inputs, processInput);
            processInput.flush();

            // Read every line outputted on stdout.
            // We buffer the queries, so that a parallel membership query can be applied
            String line;
            while ((line = processOutput.readLine()) != null) {
                // Read every string of the line, this will be a symbol of the input sequence.
                WordBuilder<I> wb = new WordBuilder<>();
                Scanner s = new Scanner(line);
                while (s.hasNext()) {
                    //noinspection unchecked
                    wb.add((I) s.next());
                }

                // Convert to a word and test on the SUL
                Word<I> test = wb.toWord();
                Word<O> outSul = sulOracle.answerQuery(test);
                Word<O> outHyp = hypothesis.computeOutput(test);

                if (!outSul.equals(outHyp)) {
                    DefaultQuery<I, Word<O>> ce = new DefaultQuery<>(test);
                    ce.answer(outSul);
                    closeAll();
                    return ce;
                }
            }
        } catch (IOException e) {
            throw new RuntimeException("Unable to communicate with the external program: " + e);
        }

        // At this point, the external program closed its stream, so it should have exited.
        if (process.isAlive()) {
            System.err.println("ERROR> log> No counterexample but process stream still active!");
            closeAll();
            throw new RuntimeException("No counterexample but process stream still active!");
        }

        // If the program exited with a non-zero value, something went wrong (for example a segfault)!
        int ret = process.exitValue();
        if (ret != 0) {
            System.err.println("ERROR> log> Something went wrong with the process: return value = " + ret);
            closeAll();
            throw new RuntimeException("Something went wrong with the process: return value = " + ret);
        }

        // Here, the program exited normally, without counterexample, so we may return null.
        return null;
    }

    /**
     * A small class to print all stuff to stderr. Useful as I do not want stderr and stdout of the external program to
     * be merged, but still want to redirect stderr to java's stderr.
     */
    static class StreamGobbler extends Thread {
        private final InputStream stream;
        private final String prefix;

        StreamGobbler(InputStream stream, String prefix) {
            this.stream = stream;
            this.prefix = prefix;
        }

        public void run() {
            try {
                BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
                String line;
                while ((line = reader.readLine()) != null)
                    System.err.println(prefix + "> " + line);
            } catch (IOException e) {
                // It's fine if this thread crashes, nothing depends on it
                e.printStackTrace();
            }
        }
    }
}
