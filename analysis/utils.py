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
    
    # rename soucha CTTs and set CTTs as Categorical data 
    df['CTT'] = df['CTT'].str.replace('Soucha','')
    df['CTT'] = pd.Categorical(df['CTT'], ["W", "Wp", "Hsi", "SPY", "SPYH", "HadsInt"])
    
    # ... split queries/symbols into different columns
    for qtype in ["Learning", "Testing"]:
        _lst= df[f"{qtype} queries/symbols"].apply(lambda x: [i.split('/') for i in ast.literal_eval(x)])
        df[f"{qtype} queries"]            = _lst.apply(lambda x : np.cumsum([int(i[0]) for i in x])) # resets
        df[f"{qtype} symbols"]            = _lst.apply(lambda x : np.cumsum([int(i[1]) for i in x])) # symbols w/o resets

    # ... and then parsing string with hypotheses sizes as array of integers
    df["HypSize"] = df["HypSize"].apply(lambda x: ast.literal_eval(x)) 
    df["TQ [Symbols]"] = df["EQ [Symbols]"]+df["MQ [Symbols]"]
    df["TQ [Resets]"] = df["EQ [Resets]"]+df["MQ [Resets]"]
    df["TQ"] = df["TQ [Symbols]"]+df["TQ [Resets]"]
    df["MQ"] = df["MQ [Symbols]"]+df["MQ [Resets]"]
    df["EQ"] = df["EQ [Symbols]"]+df["EQ [Resets]"]

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

def sort_vda(df_vda):
    df_vda.estimate = df_vda.estimate.astype(float)
    df_vda['estimate_abs'] = np.abs(df_vda.estimate.astype(float)-0.5)
    df_vda.magnitude = df_vda.apply(lambda x: x['magnitude'] + (f'(A)' if x['estimate']<0.5 else f'(B)'), axis=1)
    return df_vda[['A','B','estimate','magnitude']].set_index(['A','B'])

def _f_s12(x,max_vals):
    d = {}
    d['SUL name'] = x.apply(lambda x: x['SUL name'],axis=1).tolist()
    d['TQ_s1'] = x.apply(lambda x: x['TQ'],axis=1).tolist()
    d['TQ_s2'] = x.apply(lambda x: x['TQ']/max_vals['TQ_max'][x['SUL name']],axis=1).tolist()
    
    d['APFDx_s1'] = x.apply(lambda x: x['APFDx'],axis=1).tolist()
    d['APFDx_s2'] = x.apply(lambda x: x['APFDx']/max_vals['APFDx_max'][x['SUL name']],axis=1).tolist()
    
    return pd.Series(d, index=['SUL name', 'TQ_s1', 'APFDx_s1', 'TQ_s2', 'APFDx_s2'])
    #d['TQ_Resets_s1'] = x.apply(lambda x: x['TQ [Resets]'],axis=1).tolist()
    #d['TQ_Resets_s2'] = x.apply(lambda x: x['TQ [Resets]']/max_vals['TQ_Resets_max'][x['SUL name']],axis=1).tolist()
    #d['TQ_Symbols_s1'] = x.apply(lambda x: x['TQ [Symbols]'],axis=1).tolist()
    #d['TQ_Symbols_s2'] = x.apply(lambda x: x['TQ [Symbols]']/max_vals['TQ_Symbols_max'][x['SUL name']],axis=1).tolist()
    #return pd.Series(d, index=['SUL name', 'TQ_s1', 'TQ_Resets_s1', 'TQ_Symbols_s1', 'APFDx_s1', 'TQ_s2', 'TQ_Resets_s2', 'TQ_Symbols_s2', 'APFDx_s2'])
    
def _f_max(x):
    d = {}
    d['TQ_max'] = x['TQ'].max()
    d['TQ_Resets_max'] = x['TQ [Resets]'].max()
    d['TQ_Symbols_max'] = x['TQ [Symbols]'].max()
    d['APFDx_max'] = x['APFDx'].max()
    return pd.Series(d, index=['TQ_max', 'TQ_Symbols_max', 'TQ_Resets_max', 'APFDx_max'])

def calc_s12(a_df):
    max_vals = a_df.groupby('SUL name').apply(lambda x: _f_max(x)).to_dict()
    metrics_s12 = a_df.groupby('EquivalenceOracle').apply(lambda x: _f_s12(x,max_vals)).explode(['SUL name', 
                  'TQ_s1', 'TQ_s2', 'APFDx_s1',  'APFDx_s2']).reset_index().set_index(['EquivalenceOracle'])
    return metrics_s12