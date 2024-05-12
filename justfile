build:
  pandoc \
    -V lang=pl \
    -H disable_float.tex \
    -f markdown+tex_math_dollars+pipe_tables+yaml_metadata_block \
    -o report.pdf \
    report.md

watch:
  watchexec -e md just build
