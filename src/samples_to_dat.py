import sys
import argparse

import numpy as np
import pandas as pd

from ampl import df_write_dat, scalar_write_dat

REVNUE_NAME = "revenue"
N_SCENARIOS_NAME = "n_scenarios"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--products", type=int, default=4)

    args = parser.parse_args()

    df = pd.read_csv(sys.stdin, header=None)
    df.index = np.array(range(len(df))) + 1

    df_write_dat(
        df,
        output=sys.stdout,
        name=REVNUE_NAME,
        columns=[f"P{i+1}" for i in range(args.products)],
    )

    scalar_write_dat(len(df), output=sys.stdout, name=N_SCENARIOS_NAME)
