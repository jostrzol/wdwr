import sys
import argparse

import numpy as np
import pandas as pd

from ampl import df_write_dat


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--name", required=True)
    parser.add_argument("-c", "--columns", action="extend", nargs="+", required=True)
    parser.add_argument("--index-position", type=int, default=1)

    args = parser.parse_args()

    df = pd.read_csv(sys.stdin, header=None)
    df.index = np.array(range(len(df))) + 1

    df_write_dat(
        df,
        output=sys.stdout,
        name=args.name,
        columns=args.columns,
        index_pos=args.index_position,
    )
