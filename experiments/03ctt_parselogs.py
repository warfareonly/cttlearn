#!/usr/bin/python3

import glob, os, re
import pandas as pd
import numpy as np
import ast

# REGEX to separate log file lines generated as set in logback.xml file in the cttlearning Java project

# Let the example of log file line: "2022-01-20 13:18:12 INFO Benchmarking |ClosingStrategy: CloseFirst"
# Below, each REGEX part is presented with comments indicating the matching parts of the example above.
P_LOG = re.compile(r"([0-9]+-[0-9]+-[0-9\.]+\s*" # Log timestamp date in format yyyy-MM-dd (e.g., 2022-01-20 )
                   r"[0-9]+:[0-9]+:[0-9\.]+)\s*" # Log timestamp time in format HH:mm:ss   (e.g., 13:18:12 )
                   r"(?P<lvl>[\w]+)\s*" # Outputs the level of the logging event (e.g., INFO)
                   r"(?P<clz>\w+)\s*"   # Outputs origin of the logging event. (e.g., Benchmarking class)
                   r"\|(?P<key>[^:]+):\s*" # cttlearning log format "Message key:"  (e.g., "ClosingStrategy:") 
                   r"(?P<val>.+)"          # cttlearning log format "Message value" (e.g., "CloseFirst")
                   )

# More information on the logback layout parameters used in:
# - cttlearning's logback.xml file: https://github.com/damascenodiego/cttlearn/blob/5fad701d1fffc1397aa49d7eb5fec56e8442f400/src/cttlearning/src/main/resources/logback.xml#L20
# - Logback official website:       https://logback.qos.ch/manual/layouts.html#conversionWord

results_path = "./logs/"

logs_dict = {}
stats_overall = {
     "ClosingStrategy": [], 
     "ObservationTableCEXHandler": [], 
     "SUL name": [],
     "Seed" : [], 
     "Cache" : [], 
     "EquivalenceOracle" : [], 
     "Method" : [], 
     "Rounds" : [], 
     "MQ [Resets]" : [],
     "MQ [Symbols]" : [],
     "EQ [Resets]" : [],
     "EQ [Symbols]" : [],
     "Learning [ms]" : [],
     "Searching for counterexample [ms]" : [],
     "Qsize" : [], 
     "Isize" : [], 
     "Equivalent" : [], 
     "Info" : [], 
     }

stats_iter = {
     "ClosingStrategy": [],
     "ObservationTableCEXHandler": [],
     "SUL name": [],
     "Seed" : [],
     "Cache" : [],
     "EquivalenceOracle" : [],
     "Method" : [],
     "Iter" : [],
     "HypSize" : [],
     "CESize" : [],
     "Info" : [],
     }

for cttl_log in glob.glob(os.path.join(results_path, "*.log")):

     try:
          with open(cttl_log) as cttl_f:
               tmp_stats = {k:np.nan for k in stats_overall.keys()}
               tmp_iter  = []
               counter_EQStats = 0
               line = 'to_start_iteration'
               while line:
                    line = cttl_f.readline()
                    m = P_LOG.match(line)
                    if m is None: continue

                    m_dict = m.groupdict()
                    if len(m_dict) == 0: continue

                    if m_dict['key'] in stats_overall.keys(): tmp_stats[m_dict['key']] = m_dict["val"]

                    if m_dict['key'] == 'EQStats':
                         try:
                              d_stats = ast.literal_eval(m_dict['val'])
                              tmp_iter.append(d_stats)
                         finally: pass
               for k, v in stats_overall.items():
                    v.append(tmp_stats[k])

               for d_stats in tmp_iter:
                    for k, v in tmp_stats.items():
                         if not k in stats_iter.keys(): continue
                         d_stats[k] = v
                    for k, v in d_stats.items():
                         stats_iter[k].append(v)
     except:
          print(f"Could not read file: {cttl_log}")

df_overall = pd.DataFrame.from_dict(stats_overall)
df_overall.to_csv(os.path.join('df_overall.csv'), index = False)

df_iter = pd.DataFrame.from_dict(stats_iter)
df_iter.to_csv(os.path.join('df_iter.csv'), index = False)