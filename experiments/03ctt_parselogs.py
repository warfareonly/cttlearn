#!/usr/bin/python3

import glob, os, re
import pandas as pd
import numpy as np
import ast

P_LOG = re.compile(r"([0-9]+-[0-9]+-[0-9\.]+ [0-9]+:[0-9]+:[0-9\.]+) (?P<lvl>[\w]+)\s*(?P<clz>\w+)\s*\|(?P<key>[^:]+):\s*(?P<val>\S+)")
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
     }

for cttl_log in glob.glob(os.path.join(results_path, "*.log")):

     with open(cttl_log) as cttl_f:
          tmp_stats = {k:np.nan for k in stats_overall.keys()}
          tmp_iter  = []
          line = cttl_f.readline()
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
                         for k,v in stats_iter.items():
                              if k in d_stats.keys(): continue
                              d_stats[k]=tmp_stats[k]
                         for k,v in d_stats.items():
                              stats_iter[k].append(v)
                    finally: pass

          for k, v in stats_overall.items(): v.append(tmp_stats[k])

df_overall = pd.DataFrame.from_dict(stats_overall)
df_overall.to_csv(os.path.join('df_overall.csv'), index = False)

df_iter = pd.DataFrame.from_dict(stats_iter)
df_iter.to_csv(os.path.join('df_iter.csv'), index = False)