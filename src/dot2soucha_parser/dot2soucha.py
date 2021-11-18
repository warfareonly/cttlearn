#!/bin/python3
# Author: CDN (Diego) Damasceno
# Email: d.damasceno@cs.ru.nl
# Description:
#   This script parses .dot files to Michal Soucha's format.
#   A description of Soucha's format is available at the URL below:
#    - https://github.com/Soucha/FSMlib/
#   An a fork of the project is available at:
#    - https://github.com/damascenodiego/FSMlib/blob/master/fsm_file_description.txt

import re
import sys
import networkx as nx

AUTOMATA_WIKI_S0 = '__start0'
DEFAULT_LABEL_REGEX = '([^\/]+)\/([^\/]+)'

def mk_soucha_dict(fsm, c_re = None):
    if c_re is None: c_re = DEFAULT_LABEL_REGEX

    io_pattern = re.compile(c_re)

    soucha_dict = dict()
    soucha_dict["__start0"] = None
    soucha_dict["symbol_in"] = {}
    soucha_dict["symbol_out"] = {}
    soucha_dict["states"] = {}
    soucha_dict["transitions"] = {}

    soucha_dict["index_in"] = {}
    soucha_dict["index_out"] = {}
    soucha_dict["index_state"] = {}

    for si in fsm.nodes:
        si_dict = fsm.nodes[si]

        if si == AUTOMATA_WIKI_S0:  # si == '__start0', where __start0 -> s0
            _s0 = list(fsm.successors(AUTOMATA_WIKI_S0))
            soucha_dict["__start0"] = _s0[0]
            continue

        # if node label is missing/NoneType/Empty string then set node id as label
        if not 'label' in si_dict.keys(): si_dict['label'] = si
        if si_dict['label'] in [None, '']: si_dict['label'] = si

        # set the first node from the list, if there is no '__start0' node
        # where __start0 -> s0 (as conventioned in the Automata wiki)
        if soucha_dict["__start0"] is None: soucha_dict["__start0"] = si

        soucha_dict["index_state"][len(soucha_dict["states"])] = si
        soucha_dict["states"][si] = {"raw_label": si_dict['label'],
                                     "soucha_index": len(soucha_dict["states"]),
                                     }
    for tr in fsm.edges:
        si,sf,edge_id = tr
        tr_attr = fsm[si][sf][edge_id]

        # skip edges without label
        if not 'label' in tr_attr.keys(): continue

        # match label using IO regex
        matched = io_pattern.match(tr_attr['label'])
        symbol_in, symbol_out = (None,None)
        if matched: symbol_in, symbol_out = matched.groups()
        else: continue

        if not symbol_in in soucha_dict["symbol_in"].keys():
            soucha_dict["index_in"][len(soucha_dict["symbol_in"])] = symbol_in
            soucha_dict["symbol_in"][symbol_in] = {"raw_label": symbol_in,
                                                   "soucha_index": len(soucha_dict["symbol_in"]),
                                                   }
        if not symbol_out in soucha_dict["symbol_out"].keys():
            soucha_dict["index_out"][len(soucha_dict["symbol_out"])] = symbol_out
            soucha_dict["symbol_out"][symbol_out] = {"raw_label": symbol_out,
                                                     "soucha_index": len(soucha_dict["symbol_out"]),
                                                     }
        if not si in soucha_dict["transitions"].keys(): soucha_dict["transitions"][si] = {}
        if symbol_in in soucha_dict["transitions"][si].keys():
            sys.exit(f"ERROR: FSM is non-deterministic between '{si}' to '{sf}' label='{fsm[si][sf]['label']}'")
        soucha_dict["transitions"][si][symbol_in] = {"raw_label": tr_attr['label'],
                                                     "symbol_in": symbol_in,
                                                     "symbol_out": symbol_out,
                                                     "si": si,
                                                     "sf": sf,
                                                     }
    return soucha_dict

if __name__ == '__main__':

    if not '-f' in sys.argv or '-h' in sys.argv or '-help' in sys.argv:
        sys.exit(f"dot2soucha -f <path to the .dot file> "
                 f"\n  Optional parameters:"
                 f"\n     -s0 <identifier of the initial state> DEFAULT: {AUTOMATA_WIKI_S0}>"
                 f"\n     -label_regex <Regular expression to parse the input/output label> DEFAULT: {DEFAULT_LABEL_REGEX}>"
                 f"\n     -show_dict Shows the dictionary>"
                 )


    str_file     = None
    in_file      = None
    custom_s0    = None
    custom_regex = None
    SHOW_DICT    = False
    VERBOSE      = False
    try:
        for idx in range(len(sys.argv)):
            if '-f' == sys.argv[idx]:
                str_file = sys.argv[idx+1]
                in_file = open(str_file, "r")
            elif '-s0' == sys.argv[idx]:
                custom_s0 = str(sys.argv[idx+1])
            elif '-label_regex' == sys.argv[idx]:
                custom_regex = sys.argv[idx+1]
            elif '-show_dict' == sys.argv[idx]:
                SHOW_DICT = True
            elif '-verbose' == sys.argv[idx]:
                VERBOSE = True
    except:
        sys.exit("ERROR. Did you make a mistake in the spelling")

    if not in_file is None:
        if VERBOSE: print(f'Reading dot file: {in_file.name}', file=sys.stderr)
        f_dot = nx.nx_agraph.read_dot(in_file)

        soucha_dict = mk_soucha_dict(f_dot, c_re = custom_regex)
        if SHOW_DICT:
            import pprint
            pprint.pprint(soucha_dict, stream=sys.stderr)

        # File's content:
        # t=1 DFSM
        #  =2 Mealy machine
        #  =3 Moore machine
        #  =4 DFA
        # r=0 unreduced
        #  =1 reduced
        # t r
        t = 2;
        r = 1;
        print(f"{t} {r}")
        # n ... the number of states
        # p ... the number of inputs
        # q ... the number of outputs
        # n p q
        n = len(soucha_dict['states']);
        p = len(soucha_dict['symbol_in']);
        q = len(soucha_dict['symbol_out']);
        print(f"{n} {p} {q}")
        # m
        # m ... maximal state ID
        m = len(soucha_dict['states']);
        print(f"{m}")
        #
        # output and state-transition functions listing according to the machine type
        # - all values are separated by a space
        # Output functions: (depends on the machine type)
        #  n lines: state <output on the transition for each input>(p values)
        list_states = [soucha_dict['states'][soucha_dict["__start0"]]['soucha_index']]
        for si in soucha_dict['states'].keys():
            if si == soucha_dict["__start0"]: continue
            list_states.append(soucha_dict['states'][si]['soucha_index'])
        for idx_si in list_states:
            print(idx_si, end='')
            for idx_in in soucha_dict['index_in'].keys():
                _trs_from_si = soucha_dict['transitions'][soucha_dict['index_state'][idx_si]]
                _tr  = _trs_from_si[soucha_dict['index_in'][idx_in]]
                symbol_out = _tr['symbol_out']
                idx_out = soucha_dict['symbol_out'][symbol_out]['soucha_index']
                print(" ",idx_out, end='')
            print('')
        # state-transition function:
        #  n lines: state <the next state for each input>(p values)
        for idx_si in list_states:
            print(idx_si, end='')
            for idx_in in soucha_dict['index_in'].keys():
                _trs_from_si = soucha_dict['transitions'][soucha_dict['index_state'][idx_si]]
                _tr  = _trs_from_si[soucha_dict['index_in'][idx_in]]
                sf = _tr['sf']
                idx_sf = soucha_dict['states'][sf]['soucha_index']
                print(" ",idx_sf, end='')
            print('')
