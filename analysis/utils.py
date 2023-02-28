import scipy.stats as ss
import itertools as it
import pandas as pd
import numpy as np

from bisect import bisect_left
from typing import List
from pandas import Categorical

import ast

def apfd(nqueries: list, hypsize: list, max_nqueries=None):
    hs = hypsize
    nq = nqueries
    assert hs[0] == 1
    assert len(nq) == len(hs)
    
    extra_nqueries, extra_hs = [],[]
    if(not max_nqueries is None): 
        extra_nqueries = [max_nqueries]
        extra_hs = [hs[-1]]

    return 1 - (np.sum(np.multiply([*nq,*extra_nqueries], np.diff([0, *hs,*extra_hs]))) / (np.max([*nq,*extra_nqueries]) * np.max(hs))) + (1.0 / (2 * np.max([*nq,*extra_nqueries])))

def auc_learning(nqueries: list, hypsize: list, max_nqueries=None):
    hs = hypsize
    nq = nqueries
    assert hs[0] == 1
    assert len(nq) == len(hs)
    
    extra_nqueries, extra_hs = [],[]
    if(not max_nqueries is None): 
        extra_nqueries = [max_nqueries]
        extra_hs = [hs[-1]]
    
    return np.trapz([*hs,*extra_hs],[*nq,*extra_nqueries])

def derive_data(data_frame: pd.DataFrame.dtypes):
    # first, copy dataframe
    df = data_frame.copy()
    
    # ... split queries/symbols into different columns
    for qtype in ["Learning", "Testing"]:
        _lst= df[f"{qtype} queries/symbols"].apply(lambda x: [i.split('/') for i in ast.literal_eval(x)])
        df[f"{qtype} queries"]            = _lst.apply(lambda x : np.cumsum([int(i[0]) for i in x])) # resets
        df[f"{qtype} symbols"]            = _lst.apply(lambda x : np.cumsum([int(i[1]) for i in x])) # symbols w/o resets

    # ... and then parsing string with hypotheses sizes as array of integers
    df["HypSize"] = df["HypSize"].apply(lambda x: ast.literal_eval(x)) 
    df["TQ [Symbols]"] = df["EQ [Symbols]"]+df["MQ [Symbols]"]
    df["TQ [Resets]"] = df["EQ [Resets]"]+df["MQ [Resets]"]

    # ... and then append qSize to HypSize, if the run is successfull 
    df["HypSize"] = df.apply(lambda x: x.HypSize + [x.Qsize] if x.Equivalent=='OK' and len(x.HypSize) < x.Rounds else x.HypSize, axis=1)
    
    # ... and then include #EQs from the single-state model
    df["Testing queries"] = df["Testing queries"].apply(lambda x: [0,*x])
    df["Testing symbols"] = df["Testing symbols"].apply(lambda x: [0,*x])
    
    # ... and then calculate the total number of queries
    df["Total queries"] = df.apply(lambda x: np.add(x["Testing queries"],x["Learning queries"]) if x.Equivalent=='OK' else [], axis=1)
    df["Total symbols"] = df.apply(lambda x: np.add(x["Testing symbols"],x["Learning symbols"]) if x.Equivalent=='OK' else [], axis=1)
    
    # ... and then (FINALLY!) calculate the APFD and AUC for EQs, and TQs
    df_eq = df.query('`Equivalent`=="OK"')
    
    the_cols = ["SUL name","Seed","TQ [Symbols]","EQ [Symbols]"]
    max_eqs = df[the_cols].groupby(["SUL name","Seed"]).max().to_dict()

    #df["APFD_testing"] = df.apply(lambda x: apfd(x['Testing symbols'],x['HypSize']) if x.Equivalent=='OK' else -1, axis=1)
    #df["APFD_total"] = df.apply(lambda x: apfd(x['Total symbols'],x['HypSize']) if x.Equivalent=='OK' else -1, axis=1)
    
    #df["APFDx_testing"] = df.apply(lambda x: apfd(x['Testing symbols'],x['HypSize'],max_nqueries=max_eqs['EQ [Symbols]'][(x['SUL name'],x['Seed'])]) if x.Equivalent=='OK' else -1, axis=1)
    df["APFDx"] = df.apply(lambda x: apfd(x['Total symbols'],x['HypSize'],max_nqueries=max_eqs['TQ [Symbols]'][(x['SUL name'],x['Seed'])]) if x.Equivalent=='OK' else -1, axis=1)
    
    #df["AUC_testing"] = df.apply(lambda x: auc_learning(x['Testing symbols'],x['HypSize'],max_nqueries=max_eqs['EQ [Symbols]'][x['SUL name']]) if x.Equivalent=='OK' else -1, axis=1)
    #df["AUC_total"] = df.apply(lambda x: auc_learning(x['Total symbols'],x['HypSize'],max_nqueries=max_eqs['TQ [Symbols]'][x['SUL name']]) if x.Equivalent=='OK' else -1, axis=1)
    
    # to close, return the new dataframe with derived columns
    return df

def _interp_addsorted(alist, datapoints=[]):
    cc_dp = alist.copy()
    for newdp in datapoints:
        if(newdp in cc_dp): continue
        cc_dp = np.insert(cc_dp,np.searchsorted(cc_dp,newdp),newdp)
    return cc_dp

def interp(data: pd.DataFrame.dtypes, col_costs: str, col_hypsizes: str, datapoints=[]):
    df_subset = data.copy()
    df_subset[col_hypsizes+'_withdatapoints']=df_subset[col_hypsizes].apply(lambda x: _interp_addsorted(x,datapoints))
    df_subset[col_costs]=df_subset.apply(lambda x: np.interp(x[col_hypsizes+'_withdatapoints'], x[col_hypsizes], x[col_costs]),axis=1)
    df_subset[col_hypsizes]=df_subset[col_hypsizes+'_withdatapoints']
    df_subset.drop(col_hypsizes+'_withdatapoints',inplace=True,axis=1)
    return df_subset


def VD_A(treatment: List[float], control: List[float]):
    """
    Computes Vargha and Delaney A index
    A. Vargha and H. D. Delaney.
    A critique and improvement of the CL common language
    effect size statistics of McGraw and Wong.
    Journal of Educational and Behavioral Statistics, 25(2):101-132, 2000
    The formula to compute A has been transformed to minimize accuracy errors
    See: http://mtorchiano.wordpress.com/2014/05/19/effect-size-of-r-precision/
    :param treatment: a numeric list
    :param control: another numeric list
    :returns the value estimate and the magnitude

    Code extracted from https://gist.github.com/jacksonpradolima/f9b19d65b7f16603c837024d5f8c8a65
    """
    m = len(treatment)
    n = len(control)

    if m != n:
        raise ValueError("Data d and f must have the same length")

    r = ss.rankdata(treatment + control)
    r1 = sum(r[0:m])

    # Compute the measure
    # A = (r1/m - (m+1)/2)/n # formula (14) in Vargha and Delaney, 2000
    A = (2 * r1 - m * (m + 1)) / (2 * n * m)  # equivalent formula to avoid accuracy errors

    levels = [0.147, 0.33, 0.474]  # effect sizes from Hess and Kromrey, 2004
    magnitude = ["negligible", "small", "medium", "large"]
    scaled_A = (A - 0.5) * 2

    magnitude = magnitude[bisect_left(levels, abs(scaled_A))]
    estimate = A

    return estimate, magnitude

def VD_A_DF(data, val_col: str = None, group_col: str = None, sort=True):
    """
    :param data: pandas DataFrame object
        An array, any object exposing the array interface or a pandas DataFrame.
        Array must be two-dimensional. Second dimension may vary,
        i.e. groups may have different lengths.
    :param val_col: str, optional
        Must be specified if `a` is a pandas DataFrame object.
        Name of the column that contains values.
    :param group_col: str, optional
        Must be specified if `a` is a pandas DataFrame object.
        Name of the column that contains group names.
    :param sort : bool, optional
        Specifies whether to sort DataFrame by group_col or not. Recommended
        unless you sort your data manually.
    :return: stats : pandas DataFrame of effect sizes
    Stats summary ::
    'A' : Name of first measurement
    'B' : Name of second measurement
    'estimate' : effect sizes
    'magnitude' : magnitude

    Code extracted from https://gist.github.com/jacksonpradolima/f9b19d65b7f16603c837024d5f8c8a65
    """

    x = data.copy()
    if sort:
        x[group_col] = Categorical(x[group_col], categories=x[group_col].unique(), ordered=True)
        x.sort_values(by=[group_col, val_col], ascending=True, inplace=True)

    groups = x[group_col].unique()

    # Pairwise combinations
    g1, g2 = np.array(list(it.combinations(np.arange(groups.size), 2))).T

    # Compute effect size for each combination
    ef = np.array([VD_A(list(x[val_col][x[group_col] == groups[i]].values),
                        list(x[val_col][x[group_col] == groups[j]].values)) for i, j in zip(g1, g2)])

    return pd.DataFrame({
        'A': np.unique(data[group_col])[g1],
        'B': np.unique(data[group_col])[g2],
        'estimate': ef[:, 0],
        'magnitude': ef[:, 1]
    })