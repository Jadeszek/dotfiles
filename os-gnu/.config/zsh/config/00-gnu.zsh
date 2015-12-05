export OS='GNU'

# be colorful
eval `dircolors -b` && \
  export ZLS_COLORS=$LS_COLORS

ls_options+=(--color=auto)
grep_options+=(--color=auto)

# create backup files
export VERSION_CONTROL='existing'
export SIMPLE_BACKUP_SUFFIX='.backup'
cp_options+=(-b)
mv_options+=(-b)
