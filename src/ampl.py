import numpy as np
import pandas as pd

from typing import TextIO, Any
from io import StringIO


def parse_ampl_set(text: TextIO) -> pd.DataFrame:
    for line in text:
        line = line.strip()
        if line == "":
            pass
        elif line.startswith("set"):
            name_part, data_part = line.split(":=")
            (_, name) = name_part.split()
            data = np.array(data_part[:-1].split())
            return pd.Series(data=_try_convert(data), name=name)
        else:
            raise ValueError("not an ampl set on input")


def parse_ampl_table(text: TextIO, names: dict[int, str] | None = None) -> pd.DataFrame:
    names = names if names is not None else {}
    col_names: list[str] = []
    data: list[list[float]] = []
    index: list[list[str]] = []

    for line in text:
        line = line.strip()
        if line == "":
            pass
        elif line.startswith(":"):
            col_names = line.split()[1:-1]
            for i, name in names.items():
                col_names[i] = name
            data = []
        elif line == ";":
            dataframe = pd.DataFrame(
                np.array(data), columns=col_names, index=_make_index(index)
            )
            return dataframe.convert_dtypes()
        else:
            try:
                parts = line.split()
                row_size = len(col_names)
                key, row = parts[:-row_size], parts[-row_size:]
                data.append(list(map(float, row)))
                index.append(key)
            except Exception as e:
                raise ValueError("not an ampl table on input") from e


def _make_index(index: list[list[str]]) -> pd.Index:
    array = np.array(index)
    size = array.shape[1]
    converted: list[np.ndarray] = [_try_convert(array[:, i]) for i in range(size)]
    return pd.Index(converted[0]) if size == 1 else pd.MultiIndex.from_arrays(converted)


def _try_convert(array: np.ndarray) -> np.ndarray:
    types = [int, float, str]
    for type in types:
        try:
            return array.astype(type)
        except Exception:
            pass
    return array


def scalar_write_dat(
    value: Any,
    output: TextIO,
    name: str,
):
    output.write(f"param {name} := {value};\n")


def df_write_dat(
    df: pd.DataFrame,
    output: TextIO,
    name: str,
    columns: list,
    index_pos: int = 1,
):
    output.write(f"param {name} :=\n")

    for key, row in df.iterrows():
        template = ["*", "*"]
        template[index_pos] = str(key)
        output.write(f"  [{','.join(template)}] ")

        for column, value in zip(columns, row):
            output.write(f"{column} {value}, ")

        output.write("\n")

    output.write(";\n")


if __name__ == "__main__":
    text = """
set in_risks_max := 5 20 37;
:   out_risks out_profit_averages    :=
0       0            -300
1       1             529.379
2       2            1208.76
3       3            1888.14
4       4            2567.52
5       5            3246.89
;
"""
    f = StringIO(text)
    in_risks_max = parse_ampl_set(f)
    print(in_risks_max)

    df = parse_ampl_table(f)
    print(df.info())
    print(df.index)
